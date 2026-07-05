# 🔗 Datasets & Useful Links — GSP412

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Build a Data Warehouse with BigQuery | https://www.cloudskillsboost.google/course_templates/624 |
| Lab (GSP412): Troubleshooting and Solving Data Join Pitfalls | https://www.cloudskillsboost.google/focuses/3642?parent=catalog |
| BigQuery Console | https://console.cloud.google.com/bigquery |
| BigQuery Documentation | https://cloud.google.com/bigquery/docs |
| JOIN Types (GoogleSQL query syntax) | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#join_types |
| Standard SQL Query Syntax | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax |
| STRING_AGG Function Docs | https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions#string_agg |
| ARRAY_AGG Function / Work with Arrays Guide | https://cloud.google.com/bigquery/docs/arrays |
| HAVING Clause Docs | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#having_clause |

## Datasets Used in This Lab

> The source project is **`data-to-insights`** — starred into your Explorer pane
> in Task 2 via **+ Add data → Star a project by name**.

### 1. Website ecommerce data — *Tasks 3–6 source*
- **BigQuery table:** `data-to-insights.ecommerce.all_sessions_raw`
- **What it contains:** Millions of Google Analytics records from the [Google Merchandise Store](https://shop.googlemerchandisestore.com/). Key fields here: `productSKU` (2,273 SKU+name pairs but only **1,909 distinct SKUs** — the same SKU can carry several product names) and `v2ProductCategory` (used for the `%Clearance%` filter).
- Same table used in [lab 01 (GSP413)](../01-GSP413%20-%20Creating%20a%20Data%20Warehouse%20Through%20Joins%20and%20Unions/datasets-and-links.md) and [lab 02 (GSP414)](../02-GSP414%20-%20Creating%20Date-Partitioned%20Tables%20in%20BigQuery/datasets-and-links.md).

### 2. Product inventory — *Tasks 5–6 source*
- **BigQuery table:** `data-to-insights.ecommerce.products`
- **What it contains:** One clean row per SKU with `name`, `stockLevel`, `restockingLeadTime`, plus sentiment fields. Contains 2 SKUs that never appear in web analytics (an in-store-only soundbar and a brand-new product with zero orders).

### 3. Tables created during the lab (in your `ecommerce` dataset)

| Table | Created in | Contents |
|---|---|---|
| `ecommerce.site_wide_promotion` | Task 6 | Discount rows (`.05`, then `.04` and `.03` added) used to demonstrate the CROSS JOIN multiplication effect |

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full beginner-friendly walkthrough with diagrams and explanations |
| `solutions.sql` | All task queries in execution order, commented |
| `datasets-and-links.md` | This file — dataset references and links |
