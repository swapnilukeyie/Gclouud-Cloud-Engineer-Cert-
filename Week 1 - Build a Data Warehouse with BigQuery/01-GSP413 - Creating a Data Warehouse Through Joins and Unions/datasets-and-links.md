# 🔗 Datasets & Useful Links — GSP413

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Build a Data Warehouse with BigQuery | https://www.cloudskillsboost.google/course_templates/624 |
| Lab (GSP413): Creating a Data Warehouse Through Joins and Unions | https://www.cloudskillsboost.google/focuses/3641?parent=catalog |
| Google Merchandise Store (source of the analytics data) | https://shop.googlemerchandisestore.com/ |
| BigQuery Console | https://console.cloud.google.com/bigquery |
| BigQuery Documentation | https://cloud.google.com/bigquery/docs |
| JOIN Syntax (GoogleSQL) | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#join_types |
| UNION / Set Operators Docs | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#set_operators |
| Wildcard Tables Docs | https://cloud.google.com/bigquery/docs/querying-wildcard-tables |
| SAFE_DIVIDE Function Docs | https://cloud.google.com/bigquery/docs/reference/standard-sql/mathematical_functions#safe_divide |

## Datasets Used in This Lab

> The source project is **`data-to-insights`** — a public dataset that is *not*
> displayed by default in the BigQuery explorer, but can be queried directly
> by its fully-qualified name.

### 1. Product sentiment / inventory — *Tasks 2 & 3 source*
- **BigQuery table:** `data-to-insights.ecommerce.products`
- **What it contains:** One row per product SKU with `name`, `orderedQuantity`, `stockLevel`, `restockingLeadTime`, plus review-analysis fields `sentimentScore` and `sentimentMagnitude` (FLOAT) produced by the Natural Language API.

### 2. Website ecommerce data — *Task 3 source*
- **BigQuery table:** `data-to-insights.ecommerce.all_sessions_raw`
- **What it contains:** Millions of raw Google Analytics session records from the Google Merchandise Store — one row per hit, with `productSKU`, `productQuantity`, `date` (as a `YYYYMMDD` string), and many more fields.

### 3. Tables created during the lab (in your `ecommerce` dataset)

| Table | Created in | Contents |
|---|---|---|
| `ecommerce.products` | Task 2 | Browsable copy of the public products table |
| `ecommerce.sales_by_sku_20170801` | Task 3 | Total ordered per SKU for 08/01/2017 (462 SKUs) |
| `ecommerce.sales_by_sku_20170802` | Task 4 | In-store sales for 08/02/2017 (1 inserted record) |

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full beginner-friendly walkthrough with diagrams and explanations |
| `solutions.sql` | All task queries in execution order, commented |
| `datasets-and-links.md` | This file — dataset references and links |
