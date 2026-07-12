# 🔗 Datasets & Useful Links — GSP409

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Derive Insights from BigQuery Data | https://www.cloudskillsboost.google/course_templates/623 |
| Lab (GSP409): Explore and Create Reports with Data Studio | https://www.cloudskillsboost.google/focuses/3614?parent=catalog |
| Looker Studio (formerly Data Studio) | https://lookerstudio.google.com/ |
| BigQuery Console | https://console.cloud.google.com/bigquery |

## Tools & Services (deep-dive links)

| Tool | Link |
|---|---|
| Looker Studio help center | https://support.google.com/looker-studio |
| BigQuery connector for Looker Studio | https://support.google.com/looker-studio/answer/6370296 |
| Table chart reference (dimensions, metrics, sort, style) | https://support.google.com/looker-studio/answer/7189044 |
| Data source credentials (owner's vs viewer's) | https://support.google.com/looker-studio/answer/6371135 |
| Calculated fields | https://support.google.com/looker-studio/answer/6299685 |
| BigQuery BI Engine (dashboard acceleration) | https://cloud.google.com/bigquery/docs/bi-engine-intro |
| Looker Studio Linking API (programmatic reports) | https://developers.google.com/looker-studio/integrate/linking-api |

## Datasets Used in This Lab

> Source project **`data-to-insights`** — reached via the BigQuery connector's **Shared projects** path (your `qwiklabs-` project authorizes and bills; the shared project supplies the data).

### 1. Sales report table — *both tasks*
- **BigQuery table:** `data-to-insights.ecommerce.sales_report`
- **What it contains:** One row per product with `name`, `productSKU`, `stockLevel`, `restockingLeadTime`, `total_ordered`, and the pre-computed `ratio` (= total_ordered / stockLevel — the same sell-through metric built by hand in [Week 1's GSP413 lab](../../Week%201%20-%20Build%20a%20Data%20Warehouse%20with%20BigQuery/01-GSP413%20-%20Creating%20a%20Data%20Warehouse%20Through%20Joins%20and%20Unions/README.md)).

### 2. Objects created during the lab

| Object | Created in | Notes |
|---|---|---|
| Data Studio report "Ecommerce Product Operations Report" | Tasks 1–2 | Lives in Data Studio (tied to the temporary lab account), not in your Cloud project |
| BigQuery data source (connector config) | Task 1 | Points at `data-to-insights.ecommerce.sales_report` |

No BigQuery datasets or tables are created.

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full walkthrough with diagrams, tools intro, concepts, and pro tips |
| `solutions.md` | The exact click-path recipe (this lab has no SQL) |
| `datasets-and-links.md` | This file — dataset references and links |
