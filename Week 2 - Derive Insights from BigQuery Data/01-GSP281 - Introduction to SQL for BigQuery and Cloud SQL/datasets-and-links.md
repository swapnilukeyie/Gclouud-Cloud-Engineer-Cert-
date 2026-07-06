# 🔗 Datasets & Useful Links — GSP281

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Derive Insights from BigQuery Data | https://www.cloudskillsboost.google/course_templates/623 |
| Lab (GSP281): Introduction to SQL for BigQuery and Cloud SQL | https://www.cloudskillsboost.google/focuses/2802?parent=catalog |
| BigQuery Console | https://console.cloud.google.com/bigquery |
| Suggested next-level lab: Weather Data in BigQuery | https://www.cloudskillsboost.google/focuses/609?parent=catalog |

## Tools & Services (deep-dive links)

| Tool | Link |
|---|---|
| BigQuery introduction | https://cloud.google.com/bigquery/docs/introduction |
| Cloud SQL for MySQL introduction | https://cloud.google.com/sql/docs/mysql/introduction |
| Cloud SQL — importing CSV data | https://cloud.google.com/sql/docs/mysql/import-export/import-export-csv |
| Cloud Storage buckets | https://cloud.google.com/storage/docs/buckets |
| Cloud Shell | https://cloud.google.com/shell/docs |
| `gcloud sql connect` reference | https://cloud.google.com/sdk/gcloud/reference/sql/connect |
| MySQL 8.0 reference manual | https://dev.mysql.com/doc/refman/8.0/en/ |
| GoogleSQL query syntax | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax |
| BigQuery public datasets | https://cloud.google.com/bigquery/public-data |

## Datasets Used in This Lab

### 1. London Bicycles (BigQuery public dataset) — *Tasks 2–4 source*
- **BigQuery tables:** `bigquery-public-data.london_bicycles.cycle_hire` (83,434,866 rows — every London bikeshare trip 2015–2017; `duration` in seconds) and `cycle_stations`
- **Marketplace:** https://console.cloud.google.com/marketplace/product/greater-london-authority/london-bicycles
- Added to Explorer via **+ Add data → Star a project by name → `bigquery-public-data`**

### 2. Files & objects created during the lab

| Object | Created in | Contents |
|---|---|---|
| `start_station_name.csv` | Task 4 (local download) | Station name + ride-start count, descending (954 stations + header) |
| `end_station_name.csv` | Task 4 (local download) | Station name + ride-end count, descending (958 stations + header) |
| Cloud Storage bucket (named after your Project ID) | Task 4 | Staging area holding both CSVs |
| Cloud SQL instance `my-demo` | Task 5 | MySQL 8.0, Enterprise/Development preset, multi-zone, primary `europe-west1-d` |
| Database `bike` | Task 6 | Holds the two tables below |
| Table `bike.london1` | Tasks 6–7 | start_station_name VARCHAR(255), num INT — 955 rows imported |
| Table `bike.london2` | Tasks 6–7 | end_station_name VARCHAR(255), num INT — 959 rows imported |

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full beginner-friendly walkthrough with diagrams, tools intro, and explanations |
| `solutions.sql` | All queries (BigQuery + MySQL) in execution order, commented |
| `datasets-and-links.md` | This file — dataset references and links |
