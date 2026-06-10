with previous as 
(

select
*,
lag(stop) over (partition by patient order by start, stop) 
as previous_encounter,
row_number() over (partition by patient order by start
) as rn
from encounters
),


readmissions as (
select 
id,
start,
stop,
previous_encounter,
coalesce(
case 
   when previous_encounter is null then null else
   extract ( epoch from (start - previous_encounter))/86400 
    end ,0) as since_last_admission,
extract (epoch from ( stop-start))/3600 as encounter_duration,
patient,
payer,
initcap(encounterclass) as encounterclass,
btrim
(
regexp_replace(description, '(procedure)', ' ', 'g')
) as description,
payer_cost as payer_coverage,
coalesce(reasondescription, 'Other') as cause
from previous)


select 
r.*,
coalesce
(
case 
    when r.previous_encounter is null then null
    when r.since_last_admission <= 30 then 'Yes'
    else 'No'
end, 'No') as readmission_in_30days,
case 
    when r.since_last_admission <= 30 then 1 else 0 end as readmitted,
case
    when r.since_last_admission <= 7 then '0-7 days'
    when r.since_last_admission <= 15 then '8-15 days'
    when r.since_last_admission <= 30 then '16-30 days'
    when r.since_last_admission <= 90 then '31-90 days'
    else 'No readmission'
    end readmission_range,
case 
    when r.encounter_duration <=24 then 'under 24hrs' else 'over 24hrs' end as time_frame,
case
    when p.gender='F' THEN 'Female' else 'Male' end as gender,
initcap(p.race) as race,
btrim(
   initcap(
      regexp_replace(
         regexp_replace(pa.name,'UnitedHealthcare', 'United Health Care', 'g'), '[^a-zA-Z0-9]',' ','g'
              )))
as payer_name,

p.fullname

from 
   readmissions as r
left join 
   cleanpatients as p
   on r.patient=p.id
left join 
   payers as pa
   on r.payer=pa.id

