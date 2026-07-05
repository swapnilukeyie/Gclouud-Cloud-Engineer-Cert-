# 🔗 Datasets & Useful Links — GSP414

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Build a Data Warehouse with BigQuery | https://www.cloudskillsboost.google/course_templates/624 |
| Lab (GSP414): Creating Date-Partitioned Tables in BigQuery | https://www.cloudskillsboost.google/focuses/3694?parent=catalog |
| BigQuery Console | https://console.cloud.google.com/bigquery |
| BigQuery Documentation | https://cloud.google.com/bigquery/docs |
| Partitioned Tables Docs | https://cloud.google.com/bigquery/docs/partitioned-tables |
| Creating Partitioned Tables Docs | https://cloud.google.com/bigquery/docs/creating-partitioned-tables |
| Querying Partitioned Tables (pruning) Docs | https://cloud.google.com/bigquery/docs/querying-partitioned-tables |
| Wildcard Tables / `_TABLE_SUFFIX` Docs | https://cloud.google.com/bigquery/docs/querying-wildcard-tables |
| PARSE_DATE Function Docs | https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#parse_date |
| DATE_DIFF Function Docs | https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#date_diff |

## Datasets Used in This Lab

### 1. Ecommerce web analytics — *Tasks 2–3 source*
- **BigQuery tables:** `data-to-insights.ecommerce.all_sessions_raw` (non-partitioned) and `data-to-insights.ecommerce.partition_by_day` (pre-created, partitioned)
- **What it contains:** Millions of Google Analytics session records from the [Google Merchandise Store](https://shop.googlemerchandisestore.com/); `date` is a `YYYYMMDD` **string** in the raw table, a proper `DATE` in the partitioned one.
- Same source project as [lab 01 (GSP413)](../01-GSP413%20-%20Creating%20a%20Data%20Warehouse%20Through%20Joins%20and%20Unions/datasets-and-links.md).

### 2. NOAA GSOD weather data — *Tasks 4–6 source*
- **BigQuery tables:** `bigquery-public-data.noaa_gsod.gsod1929` … `gsod2018` (year-sharded) and `bigquery-public-data.noaa_gsod.stations` (station names)
- **Marketplace:** https://console.cloud.google.com/marketplace/product/noaa-public/gsod
- **What it contains:** Global Surface Summary of the Day — daily weather readings (precipitation `prcp`, temperature, wind, etc.) from thousands of stations since 1929. Note `prcp = 99.9` means "unknown".

### 3. Tables created during the lab (in your `ecommerce` dataset)

| Table | Created in | Contents |
|---|---|---|
| `ecommerce.partition_by_day` | Task 2 | Visitor IDs + dates, partitioned by `date_formatted` |
| `ecommerce.days_with_rain` | Task 5 | Rainy station-days since 2018, partitioned by `date`, partitions expire after 730 days |

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full beginner-friendly walkthrough with diagrams and explanations |
| `solutions.sql` | All task queries in execution order, commented |
| `datasets-and-links.md` | This file — dataset references and links |
