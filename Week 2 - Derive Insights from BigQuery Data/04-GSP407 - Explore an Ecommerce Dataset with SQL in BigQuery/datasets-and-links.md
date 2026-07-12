# 🔗 Datasets & Useful Links — GSP407

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Derive Insights from BigQuery Data | https://www.cloudskillsboost.google/course_templates/623 |
| Lab (GSP407): Explore an Ecommerce Dataset with SQL in BigQuery | https://www.cloudskillsboost.google/focuses/3618?parent=catalog |
| BigQuery Console | https://console.cloud.google.com/bigquery |

## Tools & Services (deep-dive links)

| Tool | Link |
|---|---|
| GoogleSQL query syntax reference | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax |
| Google Analytics BigQuery export schema | https://support.google.com/analytics/answer/3437719 |
| Getting table info (Schema/Details/Preview) | https://cloud.google.com/bigquery/docs/tables#get_information_about_tables |
| Aggregate functions (COUNT, SUM, COUNTIF) | https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions |
| WITH clause / CTEs | https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#with_clause |
| Introducing the GA sample dataset (article) | https://www.en.advertisercommunity.com/t5/Articles/Introducing-the-Google-Analytics-Sample-Dataset-for-BigQuery/ba-p/1676331 |

## Datasets Used in This Lab

> Source project **`data-to-insights`** — starred via **+ Add data → Star a project by name**. The same ecommerce data used throughout Week 1.

### 1. Raw sessions table — *Task 2 source*
- **BigQuery table:** `data-to-insights.ecommerce.all_sessions_raw`
- **What it contains:** Google Analytics logs for the [Google Merchandise Store](https://shop.googlemerchandisestore.com/) — **21+ million rows / 5.63 GB**, 32 fields, and **615 duplicated records** (found via the GROUP-BY-everything check).

### 2. Deduplicated sessions table — *Tasks 2–3 source*
- **BigQuery table:** `data-to-insights.ecommerce.all_sessions`
- **What it contains:** The cleaned version — zero duplicates on the GA-schema key fields. All analysis queries run here. Key fields: `fullVisitorId`, `channelGrouping`, `v2ProductName` (633 distinct), `productQuantity`, `type`.

### 3. Objects created during the lab

None — this lab is read-only analysis; no datasets or tables are created in your project.

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full beginner-friendly walkthrough with diagrams, tools intro, CLI alternatives, and pro tips |
| `solutions.sql` | All queries in execution order, commented |
| `datasets-and-links.md` | This file — dataset references and links |
