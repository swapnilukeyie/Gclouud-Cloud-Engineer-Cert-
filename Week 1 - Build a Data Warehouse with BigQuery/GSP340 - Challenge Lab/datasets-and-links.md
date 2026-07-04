# 🔗 Datasets & Useful Links — GSP340 Challenge Lab

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Build a Data Warehouse with BigQuery | https://www.cloudskillsboost.google/course_templates/624 |
| Challenge Lab (GSP340) | https://www.cloudskillsboost.google/focuses/14341?parent=catalog |
| BigQuery Public Datasets (Marketplace) | https://console.cloud.google.com/marketplace/browse?filter=solution-type:dataset |
| BigQuery Documentation | https://cloud.google.com/bigquery/docs |
| Partitioned Tables Docs | https://cloud.google.com/bigquery/docs/partitioned-tables |
| UPDATE Statement (DML) Docs | https://cloud.google.com/bigquery/docs/reference/standard-sql/dml-syntax#update_statement |

## Public Datasets Used in This Lab

### 1. COVID-19 Government Response (Oxford Policy Tracker) — *Task 1 source*
- **BigQuery table:** `bigquery-public-data.covid19_govt_response.oxford_policy_tracker`
- **Marketplace:** https://console.cloud.google.com/marketplace/product/bigquery-public-datasets/covid19-govt-response
- **What it contains:** Government actions per country per day (school closures, lockdowns, stringency index, etc.)

### 2. European Centre for Disease Control (ECDC) COVID-19 — *Task 3 source (population)*
- **BigQuery table:** `bigquery-public-data.covid19_ecdc.covid_19_geographic_distribution_worldwide`
- **Marketplace:** https://console.cloud.google.com/marketplace/product/bigquery-public-datasets/covid19-ecdc
- **What it contains:** Daily case/death counts per country, plus `pop_data_2019` (2019 population)

### 3. Census Bureau International — *Task 4 source (country area)*
- **BigQuery table:** `bigquery-public-data.census_bureau_international.country_names_area`
- **Marketplace:** https://console.cloud.google.com/marketplace/product/united-states-census-bureau/international-census-data
- **What it contains:** Country names, FIPS country codes, and geographic area (`country_area`)

### 4. Utility US (country code translator) — *Task 4 bridge table*
- **BigQuery table:** `bigquery-public-data.utility_us.country_code_iso`
- **What it contains:** Mapping between FIPS codes, ISO alpha-2, and ISO alpha-3 country codes

### 5. Google COVID-19 Community Mobility Reports — *Task 2 schema reference*
- **BigQuery table:** `bigquery-public-data.covid19_google_mobility.mobility_report`
- **Marketplace:** https://console.cloud.google.com/marketplace/product/bigquery-public-datasets/covid19-google-mobility
- **Original reports:** https://www.google.com/covid19/mobility/
- **What it contains:** Daily % change in visits to retail, grocery, parks, transit, workplaces, and residential areas

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full beginner-friendly walkthrough with diagrams and explanations |
| `solutions.sql` | All four task queries in execution order, commented |
| `datasets-and-links.md` | This file — dataset references and links |
