# Google Cloud — Data Engineer / Cloud Engineer Certification Journey ☁️

Hands-on labs, challenge lab solutions, and study notes from Google Cloud Skills Boost.

## 📚 Contents

| Week | Skill Badge / Course | Folder |
|---|---|---|
| Week 1 | [Build a Data Warehouse with BigQuery](https://www.cloudskillsboost.google/course_templates/624) | [`Week 1 - Build a Data Warehouse with BigQuery`](./Week%201%20-%20Build%20a%20Data%20Warehouse%20with%20BigQuery) |
| Week 2 | [Derive Insights from BigQuery Data](https://www.cloudskillsboost.google/course_templates/623) | [`Week 2 - Derive Insights from BigQuery Data`](./Week%202%20-%20Derive%20Insights%20from%20BigQuery%20Data) |

### Week 1 labs

| # | Lab | Topics |
|---|---|---|
| 01 | [GSP413 — Creating a Data Warehouse Through Joins and Unions](./Week%201%20-%20Build%20a%20Data%20Warehouse%20with%20BigQuery/01-GSP413%20-%20Creating%20a%20Data%20Warehouse%20Through%20Joins%20and%20Unions/README.md) | JOINs, UNIONs, table wildcards, `SAFE_DIVIDE` |
| 02 | [GSP414 — Creating Date-Partitioned Tables in BigQuery](./Week%201%20-%20Build%20a%20Data%20Warehouse%20with%20BigQuery/02-GSP414%20-%20Creating%20Date-Partitioned%20Tables%20in%20BigQuery/README.md) | Partitioning, partition pruning, auto-expiration, `PARSE_DATE` |
| 03 | [GSP412 — Troubleshooting and Solving Data Join Pitfalls](./Week%201%20-%20Build%20a%20Data%20Warehouse%20with%20BigQuery/03-GSP412%20-%20Troubleshooting%20and%20Solving%20Data%20Join%20Pitfalls/README.md) | Join types, non-unique keys, `ARRAY_AGG`, cross joins |
| 04 | [GSP416 — Working with JSON, Arrays, and Structs in BigQuery](./Week%201%20-%20Build%20a%20Data%20Warehouse%20with%20BigQuery/04-GSP416%20-%20Working%20with%20JSON,%20Arrays,%20and%20Structs%20in%20BigQuery/README.md) | Semi-structured JSON, ARRAY, STRUCT, `UNNEST` |
| 05 | [GSP340 — Challenge Lab](./Week%201%20-%20Build%20a%20Data%20Warehouse%20with%20BigQuery/05-GSP340%20-%20Challenge%20Lab/README.md) | Partitioned tables, schema changes, `UPDATE ... FROM` joins |

### Week 2 labs

| # | Lab | Topics |
|---|---|---|
| 01 | [GSP281 — Introduction to SQL for BigQuery and Cloud SQL](./Week%202%20-%20Derive%20Insights%20from%20BigQuery%20Data/01-GSP281%20-%20Introduction%20to%20SQL%20for%20BigQuery%20and%20Cloud%20SQL/README.md) | SQL fundamentals, Cloud Storage staging, Cloud SQL (MySQL) |
| 02 | [GSP072 — BigQuery Qwik Start - Console](./Week%202%20-%20Derive%20Insights%20from%20BigQuery%20Data/02-GSP072%20-%20BigQuery%20Qwik%20Start%20-%20Console/README.md) | Public datasets, dataset creation, loading CSV from GCS |
| 03 | [GSP071 — BigQuery Qwik Start - Command Line](./Week%202%20-%20Derive%20Insights%20from%20BigQuery%20Data/03-GSP071%20-%20BigQuery%20Qwik%20Start%20-%20Command%20Line/README.md) | The `bq` CLI: show, query, mk, load, rm |
| 04 | [GSP407 — Explore an Ecommerce Dataset with SQL in BigQuery](./Week%202%20-%20Derive%20Insights%20from%20BigQuery%20Data/04-GSP407%20-%20Explore%20an%20Ecommerce%20Dataset%20with%20SQL%20in%20BigQuery/README.md) | Metadata, dedup checks (`HAVING`), CTEs, COUNT variants |
| 05 | [GSP408 — Troubleshooting Common SQL Errors with BigQuery](./Week%202%20-%20Derive%20Insights%20from%20BigQuery%20Data/05-GSP408%20-%20Troubleshooting%20Common%20SQL%20Errors%20with%20BigQuery/README.md) | Syntax vs logic errors, legacy vs standard SQL, WHERE vs HAVING |
| 06 | GSP409 — Explore and Create Reports with Data Studio | *(coming soon)* |
| 07 | GSP787 — Derive Insights from BigQuery Data: Challenge Lab | *(coming soon)* |

Each lab folder contains:
- **README.md** — beginner-friendly walkthrough with diagrams (rendered automatically by GitHub)
- **solutions.sql** — all queries, commented and in execution order
- **datasets-and-links.md** — public dataset references and documentation links
