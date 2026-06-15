# Healthcare-readmission-analysis
Healthcare analytics project using SQL and Power BI to analyze patient encounters, healthcare utilization patterns, and 30-day return encounter behavior.


> End-to-end healthcare analytics project analyzing 27,890 patient encounters and 30-day readmission patterns across Massachusetts hospitals (2011–2022) — built with SQL and Power BI.

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-316192) ![PowerBI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811) ![DAX](https://img.shields.io/badge/DAX-Measures-yellow) ![Maven](https://img.shields.io/badge/Maven-Data%20Challenge-orange)

🔗 [Live Dashboard](https://drive.google.com/file/d/1g5bhZuPTeE-DM-8AuOHiTDGI3pso2Lll/view?usp=drive_link) • [Data Source](https://www.mavenanalytics.io/challenges/maven-hospital-challenge) • [Full SQL Code](SQL/encounters.sql)

---

## 📌 Business Problem

High 30-day readmission rates cost hospitals millions in penalties under value-based care models and signal gaps in post-discharge coordination. This project identifies the patterns driving avoidable readmissions using SQL feature engineering and Power BI dashboards.

---

## 📊 Key Results

| Metric | Value |
|--------|-------|
| Total Encounters | 27,890 |
| Total Patients | 974 |
| 30-Day Readmissions | 773 |
| Readmission Rate | **62.19%** |
| Period | 2011–2022 |

---

## ⚙️ Tech Stack
`PostgreSQL` • `Power Query` • `Power BI` • `DAX`

---

## 💻 SQL Logic

Three core transformations powered the entire analysis:

**1. Sequence encounters per patient**
```sql
LAG(stop) OVER (PARTITION BY patient ORDER BY start, stop) AS previous_encounter
```

**2. Calculate days between admissions**
```sql
EXTRACT(EPOCH FROM (start - previous_encounter)) / 86400 AS since_last_admission
```

**3. Flag 30-day readmissions**
```sql
CASE
    WHEN previous_encounter IS NULL THEN NULL
    WHEN since_last_admission <= 30 THEN 'Yes'
    ELSE 'No'
END AS readmission_in_30days
```

**4. Segment readmission timing**
```sql
CASE
    WHEN since_last_admission <= 7  THEN '0–7 days'
    WHEN since_last_admission <= 15 THEN '8–15 days'
    WHEN since_last_admission <= 30 THEN '16–30 days'
    WHEN since_last_admission <= 90 THEN '31–90 days'
    ELSE 'No readmission'
END AS readmission_range
```

---

## 📈 Dashboards

### Patient Encounters Overview
Encounter volume, payer distribution, duration & encounter type breakdown.

<!-- 📸 INSERT IMAGE: Patient Encounters Dashboard screenshot -->
![Encounters Dashboard](image/patient-encounter.png)

### 30-Day Readmission Analysis
Readmission trends, timing buckets, and demographic & clinical drivers.

<!-- 📸 INSERT IMAGE: Readmission Analysis Dashboard screenshot -->
![Readmission Dashboard](image/patient-behaviour.png)

---

## 🔍 Key Insights

- **62.19% readmission rate** — majority of returns happen within the first **7 days** post-discharge
- **Medicare & uninsured patients** drive the highest utilisation burden
- **Ambulatory & outpatient** encounters dominate — low-acuity, high-volume
- **Chronic conditions** (congestive heart failure, malignancies) are the top readmission drivers
- Female patients account for a slightly higher proportion of encounters and readmissions

---

## 📌 Recommendations

- Prioritise post-discharge follow-up within **7 days** to cut early readmissions
- Build chronic disease management programs for high-risk patient groups
- Improve care coordination for Medicare and uninsured populations
- Develop **predictive risk models** to flag patients before they readmit

---

## 🔮 What's Next
**Project 3:** REST API extraction → PostgreSQL → Power BI dashboard

---

## 🤝 Connect
**Emeka Ike** — Data Analyst & Engineer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/emeka-ike-108748198)
📧 ikeernest4700@gmail.com

---
*Built with PostgreSQL • Power BI • DAX • Power Query*

- LinkedIn: [https://www.linkedin.com/in/emeka-ike-108748198]  
- Email: [ikeernest4700@gmail.com]  

---

⭐ If you found this project useful, feel free to connect or reach out for collaboration opportunities.
