# 🔗 Datasets & Useful Links — GSP408

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Derive Insights from BigQuery Data | https://www.cloudskillsboost.google/course_templates/623 |
| Lab (GSP408): Troubleshooting Common SQL Errors with BigQuery | https://www.cloudskillsboost.google/focuses/3642?parent=catalog |
| BigQuery Console | https://console.cloud.google.com/bigquery |

## Tools & Services (deep-dive links)

| Tool | Link |
|---|---|
| GoogleSQL query syntax reference | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax |
| Migrating from legacy SQL (brackets → backticks) | https://cloud.google.com/bigquery/docs/reference/standard-sql/migrating-from-legacy-sql |
| Jobs overview (where failed-run errors live) | https://cloud.google.com/bigquery/docs/jobs-overview |
| HAVING clause | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#having_clause |
| Aggregate functions (COUNT / COUNT DISTINCT / SUM) | https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions |
| Estimating costs / dry runs | https://cloud.google.com/bigquery/docs/best-practices-costs |

## Datasets Used in This Lab

> Source project **`data-to-insights`** — starred via **+ Add data → Star a project by name**.

### 1. Revenue transactions table — *all tasks*
- **BigQuery table:** `data-to-insights.ecommerce.rev_transactions`
- **What it contains:** Revenue-bearing transactions from the [Google Merchandise Store](https://shop.googlemerchandisestore.com/) analytics export. Key fields used: `fullVisitorId`, `hits_page_pageTitle` (incl. "Checkout Confirmation"), `geoNetwork_city`, `totals_transactions`, `hits_product_v2ProductName`, `hits_product_v2ProductCategory`.
- **Data-quality quirks worth remembering:** city value `'not available in this demo dataset'`, category `(not set)` (no category assigned), and `${productitem.product.origCatName}` (un-rendered template code — GA script fired before page render).

### 2. Objects created during the lab

None — this lab is read-only troubleshooting; no datasets or tables are created in your project.

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full walkthrough as a 7-rung error ladder, with the error field guide, CLI alternatives, and pro tips |
| `solutions.sql` | Broken queries (commented with diagnosis) + all working fixes in order |
| `datasets-and-links.md` | This file — dataset references and links |
