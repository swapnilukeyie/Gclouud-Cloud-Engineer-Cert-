# 🔗 Datasets & Useful Links — GSP416

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Build a Data Warehouse with BigQuery | https://www.cloudskillsboost.google/course_templates/624 |
| Lab (GSP416): Working with JSON, Arrays, and Structs in BigQuery | https://www.cloudskillsboost.google/focuses/3696?parent=catalog |
| BigQuery Console | https://console.cloud.google.com/bigquery |
| Work with Arrays Guide (incl. UNNEST) | https://cloud.google.com/bigquery/docs/arrays |
| Work with STRUCTs / Nested & Repeated Columns | https://cloud.google.com/bigquery/docs/nested-repeated |
| ARRAY_AGG Function Docs | https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions#array_agg |
| ARRAY_LENGTH Function Docs | https://cloud.google.com/bigquery/docs/reference/standard-sql/array_functions#array_length |
| Loading JSON Data from Cloud Storage | https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-json |
| Google Analytics Sample Dataset (BigQuery) | https://console.cloud.google.com/marketplace/product/obfuscated-ga360-data/obfuscated-ga360-data |

## Datasets Used in This Lab

### 1. Fruit store demo tables — *Task 2 source*
- **BigQuery table:** `data-to-insights.advanced.fruit_store` (person, fruit_array, total_cost)
- **JSON load file:** `gs://spls/gsp416/data-insights-course/labs/optimizing-for-performance/shopping_cart.json` → loaded as `fruit_store.fruit_details` (JSONL, auto-detect schema; `fruit_array` becomes Mode = REPEATED)

### 2. Course ecommerce data — *Task 3 source*
- **BigQuery table:** `data-to-insights.ecommerce.all_sessions`
- **What it contains:** Google Analytics sessions from the [Google Merchandise Store](https://shop.googlemerchandisestore.com/) — flat (no arrays), which is why Task 3 builds arrays manually with `ARRAY_AGG`. VisitId `1501570398` = 111 flat rows → 2 array rows.

### 3. Google Analytics public sample — *Tasks 4–5 source*
- **BigQuery table:** `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
- **What it contains:** Real GA export schema with fields stored natively as nested types: **32 STRUCTs** (RECORD — e.g. `totals`, `device`, `trafficSource`, and nested `trafficSource.adwordsClickInfo`) and **11 ARRAYs** (REPEATED — e.g. `hits`). Starred into Explorer via **+ Add data → Star a project by name → `bigquery-public-data`**.

### 4. Race results JSON — *Tasks 6–9 source*
- **JSON load file:** `gs://spls/gsp416/data-insights-course/labs/optimizing-for-performance/race_results.json` → loaded as `racing.race_results` (JSONL, manual schema)
- **Schema:** `race STRING` + `participants` RECORD/REPEATED (the STRUCT) containing `name STRING` and `splits FLOAT REPEATED` (the ARRAY). One row = one 800M race holding 8 runners × 4 lap times.

### 5. Tables/datasets created during the lab

| Object | Created in | Contents |
|---|---|---|
| Dataset `fruit_store` | Task 1 | Holds the JSON-loaded fruit table |
| `fruit_store.fruit_details` | Task 2 | Shopping-cart JSON with a REPEATED fruit_array |
| Dataset `racing` | Task 6 | Holds the race results |
| `racing.race_results` | Task 6 | Nested STRUCT + ARRAY race data (1 row, 8 runners) |

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full beginner-friendly walkthrough with diagrams and explanations |
| `solutions.sql` | All task queries in execution order, commented |
| `datasets-and-links.md` | This file — dataset references and links |
