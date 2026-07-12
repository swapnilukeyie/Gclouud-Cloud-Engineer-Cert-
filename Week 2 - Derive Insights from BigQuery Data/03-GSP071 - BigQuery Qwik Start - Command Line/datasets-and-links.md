# 🔗 Datasets & Useful Links — GSP071

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Derive Insights from BigQuery Data | https://www.cloudskillsboost.google/course_templates/623 |
| Lab (GSP071): BigQuery Qwik Start - Command Line | https://www.cloudskillsboost.google/focuses/577?parent=catalog |
| BigQuery Console | https://console.cloud.google.com/bigquery |

## Tools & Services (deep-dive links)

| Tool | Link |
|---|---|
| `bq` command-line tool | https://cloud.google.com/bigquery/docs/cli_tool |
| `bq` CLI full reference | https://cloud.google.com/bigquery/docs/reference/bq-cli-reference |
| BigQuery as a data warehouse (solution overview) | https://cloud.google.com/solutions/bigquery-data-warehouse |
| Introduction to loading data (incl. encodings / `-E` flag) | https://cloud.google.com/bigquery/docs/loading-data |
| BigQuery client libraries (Java, .NET, Python…) | https://cloud.google.com/bigquery/docs/reference/libraries |
| BigQuery solution providers (third-party tools) | https://cloud.google.com/bigquery/providers |
| Cloud Shell | https://cloud.google.com/shell/docs |
| gcloud CLI overview | https://cloud.google.com/sdk/gcloud |

## Datasets Used in This Lab

### 1. Shakespeare sample table (BigQuery public data) — *Tasks 1–3 source*
- **BigQuery table:** `bigquery-public-data:samples.shakespeare`
- **What it contains:** one row for **every word in every Shakespeare play** — `word`, `word_count`, `corpus` (the play), `corpus_date`. 164,656 rows / 6.4 MB.
- **All sample tables:** https://cloud.google.com/bigquery/public-data#sample_tables

### 2. US baby names (Social Security Administration) — *Tasks 4–5 source*
- **Download:** `http://www.ssa.gov/OACT/babynames/names.zip` (~7 MB; unzips to one `yobXXXX.txt` per year)
- **File loaded:** `yob2010.txt` → 34,073 rows
- **Columns:** `name:string, gender:string, count:integer` (names with fewer than 5 occurrences are omitted by the SSA)
- **Original source:** https://www.ssa.gov/OACT/babynames/

### 3. Objects created during the lab

| Object | Created in | Notes |
|---|---|---|
| Dataset `babynames` | Task 4 (`bq mk`) | Deleted again in Task 7 (`bq rm -r`) |
| Table `babynames.names2010` | Task 4 (`bq load`) | 2010 US baby names; created and loaded in one step |
| `names.zip` + `yobXXXX.txt` files | Task 4 (`wget`/`unzip`) | Live in your Cloud Shell home directory |

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full beginner-friendly walkthrough with diagrams, tools intro, and console equivalents |
| `solutions.sh` | Every command in execution order, commented — a shell script this time, since the whole lab is CLI |
| `datasets-and-links.md` | This file — dataset references and links |
