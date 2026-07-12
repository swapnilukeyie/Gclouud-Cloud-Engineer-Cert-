# 🔗 Datasets & Useful Links — GSP787

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Derive Insights from BigQuery Data | https://www.cloudskillsboost.google/course_templates/623 |
| Challenge Lab (GSP787) | https://www.cloudskillsboost.google/focuses/11988?parent=catalog |
| BigQuery Console | https://console.cloud.google.com/bigquery |
| Looker Studio (Task 10) | https://lookerstudio.google.com/ |

## Tools & Services (deep-dive links)

| Tool | Link |
|---|---|
| Window / navigation functions (`LAG`, `LEAD`) | https://cloud.google.com/bigquery/docs/reference/standard-sql/navigation_functions |
| Functions, operators & conditionals (incl. `POWER`) | https://cloud.google.com/bigquery/docs/reference/standard-sql/functions-and-operators |
| Mathematical functions (`POWER` vs `SQRT`) | https://cloud.google.com/bigquery/docs/reference/standard-sql/mathematical_functions |
| DATE_DIFF | https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#date_diff |
| WITH clause / CTEs | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#with_clause |
| BigQuery connector for Looker Studio (custom query) | https://support.google.com/looker-studio/answer/6370296 |

## Datasets Used in This Lab

### COVID-19 Open Data — *all tasks*
- **BigQuery table:** `bigquery-public-data.covid19_open_data.covid19_open_data`
- **Marketplace:** https://console.cloud.google.com/marketplace/product/bigquery-public-datasets/covid19-open-data
- **What it contains:** Country-level daily time-series for COVID-19 globally — demographics, economy, epidemiology, geography, health, hospitalizations, mobility, government response, and weather.
- **Key columns used:** `date`, `country_name`, `country_code`, `subregion1_name` (state — NULL on country-level rows), `cumulative_confirmed`, `cumulative_deceased`, `cumulative_recovered` (all **running totals**, never daily deltas).

### Objects created during the lab

| Object | Created in | Notes |
|---|---|---|
| Data Studio report (US cases + deaths time series) | Task 10 | Lives in the temporary lab account, built on a Custom Query data source |

No BigQuery datasets or tables are created — Tasks 1–9 are read-only queries.

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full walkthrough with per-task explanations, planted-bug diagnoses, common errors, and challenge strategy |
| `solutions.sql` | All ten task solutions with `<PLACEHOLDER>` markers for the session-specific values |
| `datasets-and-links.md` | This file — dataset references and links |
