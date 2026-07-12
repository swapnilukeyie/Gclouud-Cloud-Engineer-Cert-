# Troubleshooting Common SQL Errors with BigQuery (GSP408)

> **A beginner-friendly, step-by-step guide** — written so that even someone with a non-technical background can understand *what* we are doing, *why* we are doing it, and *how* each SQL query works.

---

## 📋 Table of Contents

1. [Where This Lab Fits — Prerequisites & Learning Path](#1-where-this-lab-fits--prerequisites--learning-path)
2. [The Big Picture — What Is This Lab About?](#2-the-big-picture--what-is-this-lab-about)
3. [Tools & Services Used in This Lab](#3-tools--services-used-in-this-lab)
4. [Key Concepts — A Field Guide to SQL Errors](#4-key-concepts--a-field-guide-to-sql-errors)
5. [Task 1 — Pin the Project & Meet the Query Validator](#5-task-1--pin-the-project--meet-the-query-validator)
6. [Task 2 — Fix the Checkout-Visitors Query (7-Step Error Ladder)](#6-task-2--fix-the-checkout-visitors-query-7-step-error-ladder)
7. [Task 3 — Cities with the Most Transactions](#7-task-3--cities-with-the-most-transactions)
8. [Task 4 — Products per Category](#8-task-4--products-per-category)
9. [Quiz Answers — All in One Place](#9-quiz-answers--all-in-one-place)
10. [Quick Reference — The Final Working Queries](#10-quick-reference--the-final-working-queries)
11. [Command-Line Alternatives (Cloud Shell)](#11-command-line-alternatives-cloud-shell)

---

## 1. Where This Lab Fits — Prerequisites & Learning Path

This is **lab 5 of the "Derive Insights from BigQuery Data" skill badge** ([course 623](https://www.cloudskillsboost.google/course_templates/623)) — Week 2 of this study plan.

| # | Lab | What it teaches |
|---|---|---|
| 01 | [Introduction to SQL for BigQuery and Cloud SQL (GSP281)](../01-GSP281%20-%20Introduction%20to%20SQL%20for%20BigQuery%20and%20Cloud%20SQL/README.md) | SQL fundamentals, BigQuery + Cloud SQL |
| 02 | [BigQuery: Qwik Start - Console (GSP072)](../02-GSP072%20-%20BigQuery%20Qwik%20Start%20-%20Console/README.md) | The BigQuery loop via the web UI |
| 03 | [BigQuery: Qwik Start - Command Line (GSP071)](../03-GSP071%20-%20BigQuery%20Qwik%20Start%20-%20Command%20Line/README.md) | The same loop with the `bq` tool |
| 04 | [Explore an Ecommerce Dataset with SQL in BigQuery (GSP407)](../04-GSP407%20-%20Explore%20an%20Ecommerce%20Dataset%20with%20SQL%20in%20BigQuery/README.md) | Analyst workflow: metadata → dedup → insights |
| **05** | **Troubleshooting Common SQL Errors with BigQuery (GSP408)** | **Reading error messages, fixing syntax & logic bugs** |
| 06 | [Explore and Create Reports with Data Studio (GSP409)](../06-GSP409%20-%20Explore%20and%20Create%20Reports%20with%20Data%20Studio/README.md) | Visualizing BigQuery data |
| 07 | [Derive Insights from BigQuery Data: Challenge Lab (GSP787)](../07-GSP787%20-%20Challenge%20Lab/README.md) | Everything combined, no hand-holding |

### Prerequisites

Labs 01–04. Everything you *debug* here you already *wrote* correctly in lab 04 (`GROUP BY`, `HAVING`, `COUNT(DISTINCT ...)`) — this lab flips the exercise: now you play **code reviewer** for a junior analyst's broken queries.

---

## 2. The Big Picture — What Is This Lab About?

### The Scenario (in plain English)

A new data analyst on your team sends you their queries against the ecommerce dataset (the Google Merchandise Store's analytics records). None of them quite work. Your job: **diagnose and fix each one** — using the two skills every SQL practitioner leans on daily:

1. **Reading what the tools tell you** — the red exclamation mark in the editor, the query validator verdict, the error text in Job information (which even gives `[line:column]` coordinates).
2. **Recognizing the classic bug patterns** — because the same ~8 mistakes account for most broken SQL ever written.

```mermaid
flowchart LR
    A[Broken query from teammate]
    B[Validator or error message points at the problem]
    C[Recognize the pattern - typo, legacy SQL, missing comma, WHERE vs HAVING]
    D[Fix, re-validate, run]
    E[Meaningful business answer]

    A --> B
    B --> C
    C --> D
    D --> E
```

**Think of it like proofreading:** the lab hands you sentences with spelling mistakes (syntax errors) and sentences that are grammatical but say the wrong thing (logic errors). Spelling mistakes are easy — the red squiggle finds them. The dangerous ones are the *grammatically correct lies*: queries that run fine and return confidently wrong numbers.

---

## 3. Tools & Services Used in This Lab

| Tool / Service | What it is (in one breath) | Learn more |
|---|---|---|
| **BigQuery query editor** | Where you write SQL — flags errors live with a **red exclamation point at the offending line**. | [Docs](https://cloud.google.com/bigquery/docs) |
| **Query Validator** | The bottom-corner verdict: red = broken (with a reason), **green checkmark = valid + bytes estimate**. Your pre-flight check before every Run. | [Cost best practices](https://cloud.google.com/bigquery/docs/best-practices-costs) |
| **Job information** | Where a *failed run's* full error message lives, including `[line:column]` coordinates pointing at the exact spot. | [Jobs docs](https://cloud.google.com/bigquery/docs/jobs-overview) |
| **GoogleSQL (standard SQL)** | The modern dialect — backtick-quoted `` `project.dataset.table` `` names. Its predecessor **legacy SQL** used `[project:dataset.table]` brackets; mixing them is one of this lab's bugs. | [Query syntax](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax) · [Migrating from legacy SQL](https://cloud.google.com/bigquery/docs/reference/standard-sql/migrating-from-legacy-sql) |
| **Google Analytics ecommerce data** | The `data-to-insights.ecommerce.rev_transactions` table — revenue-bearing transactions from the [Google Merchandise Store](https://shop.googlemerchandisestore.com/). | [GA sample dataset](https://www.en.advertisercommunity.com/t5/Articles/Introducing-the-Google-Analytics-Sample-Dataset-for-BigQuery/ba-p/1676331) |

---

## 4. Key Concepts — A Field Guide to SQL Errors

The lab's bugs fall into two families:

### Syntax errors (the query won't run — the validator catches them)

| Bug | Symptom | Fix |
|---|---|---|
| **Typo in project/dataset/table name** | `Not found: data-to-inghts` | Read the name character by character; copy-paste beats retyping. |
| **Legacy SQL syntax** | `[project:dataset.table]` brackets fail under standard SQL | Use backticks: `` `project.dataset.table` `` |
| **No columns in SELECT** | `SELECT FROM ...` — syntax error | Name your columns (or `*` while exploring). |
| **Filtering aggregates with WHERE** | `WHERE avg_products_ordered > 20` errors | Aggregate conditions go in **`HAVING`**, after GROUP BY. |
| **Aggregate + bare column, no GROUP BY** | `SELECT COUNT(x), y` errors | Every non-aggregated SELECT column must appear in **GROUP BY**. |

### Logic errors (the query runs — and quietly lies)

| Bug | Symptom | Fix |
|---|---|---|
| **Missing comma between columns** | `SELECT a b` runs fine — but `b` became an **alias** for `a`: one column, wrong name | Count your commas; unexpected column names are the tell. |
| **COUNT instead of COUNT(DISTINCT)** | Visitors counted once *per row*, not per person | `COUNT(DISTINCT fullVisitorId)` |
| **No aggregation/sorting/limits at all** | 1000 raw rows that answer no question | Add the aggregation that matches the question being asked. |
| **Giant GROUP BY with no aggregates** | Runs, but slow and pointless — it's just an expensive DISTINCT | Filter first and/or aggregate something. |

> 🔑 **The meta-lesson:** the validator catches the first family for free. The second family only gets caught by a human who asks *"does this result actually answer the question?"*

---

## 5. Task 1 — Pin the Project & Meet the Query Validator

Standard setup: **Navigation menu → BigQuery → Done**, then **Explorer → + Add data → Star a project by name** → `data-to-insights` → **Star**.

Workflow for every exercise in this lab: paste the query → look for the **red exclamation point** (error line) and the **validator verdict** (bottom corner) → fix until you see the **green checkmark** → **Run**.

---

## 6. Task 2 — Fix the Checkout-Visitors Query (7-Step Error Ladder)

### 🎯 The business question

*How many unique visitors successfully went through checkout?* The analyst's attempts get one step closer with each fix:

### Rung 1 — Two bugs at once

```sql
#standardSQL
SELECT  FROM `data-to-inghts.ecommerce.rev_transactions` LIMIT 1000
```

→ **There is a typo in the dataset name** (`data-to-inghts` ≠ `data-to-insights`) — and no columns in the SELECT either.

### Rung 2 — Fixed the typo, broke the dialect

```sql
#standardSQL
SELECT * FROM [data-to-insights:ecommerce.rev_transactions] LIMIT 1000
```

→ **We are using legacy SQL** — square brackets and the `project:dataset` colon are the *old* dialect. Standard SQL wants backticks: `` `data-to-insights.ecommerce.rev_transactions` ``.

### Rung 3 — Right name, right dialect, no columns

```sql
#standardSQL
SELECT FROM `data-to-insights.ecommerce.rev_transactions`
```

→ **Still no columns defined in SELECT.**

### Rung 4 — A column! But no insight

```sql
#standardSQL
SELECT
fullVisitorId
FROM `data-to-insights.ecommerce.rev_transactions`
```

→ Runs, but: **without aggregations, limits, or sorting, this query is not insightful** — it's just a raw dump of IDs.

### Rung 5 — The sneakiest bug in SQL: the missing comma

```sql
#standardSQL
SELECT fullVisitorId hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions` LIMIT 1000
```

→ Returns **1 column, named `hits_page_pageTitle`** — no error at all! With the comma missing, SQL reads `hits_page_pageTitle` as an **alias** for `fullVisitorId` (an implicit `AS`). The query runs happily and shows visitor IDs under a page-title header. 😱

### Rung 6 — Comma restored, but is it *right*?

```sql
#standardSQL
SELECT
  fullVisitorId
  , hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions` LIMIT 1000
```

→ Two proper columns now — but visitors can appear on many rows (counted twice!), and 1000 raw rows still don't answer "how many?". Time to aggregate.

### Rung 7a — COUNT added… GROUP BY forgotten

```sql
#standardSQL
SELECT
COUNT(fullVisitorId) AS visitor_count
, hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions`
```

→ Error: **it is missing a GROUP BY clause.** Rule: mix an aggregate with a bare column and the bare column *must* be grouped.

### Rung 7b — The working query 🎉

```sql
#standardSQL
SELECT
COUNT(DISTINCT fullVisitorId) AS visitor_count
, hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_page_pageTitle = "Checkout Confirmation"
GROUP BY hits_page_pageTitle
```

| Fix | Why it matters |
|---|---|
| `COUNT(DISTINCT ...)` | Each visitor counts once, however many rows they generate. |
| `GROUP BY hits_page_pageTitle` | Satisfies the aggregate + bare-column rule. |
| `WHERE hits_page_pageTitle = "Checkout Confirmation"` | Zooms from *all* pages to exactly the business question: who reached checkout. |

✅ **Check my progress.**

---

## 7. Task 3 — Cities with the Most Transactions

### Step 1 — Complete the partial query

The skeleton was missing its `GROUP BY` column (and `totals_transactions` needed wrapping in `SUM()` to coexist with the aggregates):

```sql
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS totals_transactions,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors
FROM
`data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city
```

### Step 2 — Order the top cities first

```sql
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS totals_transactions,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors
FROM
`data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city
ORDER BY distinct_visitors DESC
```

→ **Mountain View** has the most distinct visitors (ignoring the placeholder value 'not available in this demo dataset').

### Step 3 — Add a calculated field

```sql
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS total_products_ordered,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
FROM
`data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city
ORDER BY avg_products_ordered DESC
```

Dividing one aggregate by another creates the per-city average — same pattern as lab 04's `avg_per_order`.

### Step 4 — The WHERE-vs-HAVING trap

The analyst tries to keep only cities averaging > 20:

```sql
WHERE avg_products_ordered > 20   -- ❌ fails!
```

→ **You cannot filter aggregated fields in the WHERE clause (use HAVING instead).** `WHERE` runs *before* grouping — the average doesn't exist yet at that point (remember the execution order from [lab 01](../01-GSP281%20-%20Introduction%20to%20SQL%20for%20BigQuery%20and%20Cloud%20SQL/README.md)'s pro tips: `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`).

```sql
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS total_products_ordered,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
FROM
`data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city
HAVING avg_products_ordered > 20
ORDER BY avg_products_ordered DESC
```

✅ **Check my progress.**

---

## 8. Task 4 — Products per Category

### Bug 1 — The pointless giant GROUP BY

```sql
#standardSQL
SELECT hits_product_v2ProductName, hits_product_v2ProductCategory
FROM `data-to-insights.ecommerce.rev_transactions`
GROUP BY 1,2
```

→ It *runs*, but: **large GROUP BYs really hurt performance — filter first and/or use aggregation functions.** Grouping by everything with no aggregate is just an expensive `SELECT DISTINCT` that answers nothing.

### Bug 2 — COUNT that isn't DISTINCT

```sql
#standardSQL
SELECT
COUNT(hits_product_v2ProductName) as number_of_products,
hits_product_v2ProductCategory
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_product_v2ProductName IS NOT NULL
GROUP BY hits_product_v2ProductCategory
ORDER BY number_of_products DESC
```

→ **The COUNT() function is not the distinct number of products in each category** — it counts *rows* (product appearances), so one popular product inflates its category. A logic error: runs fine, wrong number.

### The working query

```sql
#standardSQL
SELECT
COUNT(DISTINCT hits_product_v2ProductName) as number_of_products,
hits_product_v2ProductCategory
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_product_v2ProductName IS NOT NULL
GROUP BY hits_product_v2ProductCategory
ORDER BY number_of_products DESC
LIMIT 5
```

→ The category with the most distinct products: **(not set)**.

> 🧐 **Two odd category values worth decoding:**
> - `(not set)` — the product simply has **no category assigned**.
> - `${productitem.product.origCatName}` — that's **un-rendered front-end template code**: the Google Analytics tracking script fired *before the page finished rendering*. Real-world data is messy in instructive ways.

✅ **Check my progress.** 🏁 **Lab complete!**

---

## 9. Quiz Answers — All in One Place

| # | Question | Answer |
|---|---|---|
| 1 | What's wrong with the first query (1000 items)? | **There is a typo in the dataset name** (`data-to-inghts`) |
| 2 | What's wrong with the bracketed query? | **We are using legacy SQL** |
| 3 | What's wrong with `SELECT FROM ...`? | **Still no columns defined in SELECT** |
| 4 | What's wrong with the bare `fullVisitorId` query? | **Without aggregations, limits, or sorting, this query is not insightful** |
| 5 | How many columns does the missing-comma query return? | **1, a column named hits_page_pageTitle** (the "second column" became an alias) |
| 6 | What's wrong with the COUNT() + pageTitle query? | **It is missing a GROUP BY clause** |
| 7 | Which city had the most distinct visitors? | **Mountain View** |
| 8 | What's wrong with `WHERE avg_products_ordered > 20`? | **You cannot filter aggregated fields in the WHERE clause (use HAVING instead)** |
| 9 | What's wrong with the GROUP BY 1,2 query? | **Large GROUP BYs really hurt performance (filter first and/or use aggregation functions)** |
| 10 | What's wrong with the category COUNT query? | **COUNT() is not the distinct number of products in each category** |
| 11 | Which category has the most distinct products? | **(not set)** |

---

## 10. Quick Reference — The Final Working Queries

```sql
-- Task 2: unique visitors who reached checkout
SELECT
COUNT(DISTINCT fullVisitorId) AS visitor_count
, hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_page_pageTitle = "Checkout Confirmation"
GROUP BY hits_page_pageTitle;

-- Task 3: cities by avg products ordered, only where avg > 20
SELECT
geoNetwork_city,
SUM(totals_transactions) AS total_products_ordered,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
FROM `data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city
HAVING avg_products_ordered > 20
ORDER BY avg_products_ordered DESC;

-- Task 4: top 5 categories by distinct product count
SELECT
COUNT(DISTINCT hits_product_v2ProductName) as number_of_products,
hits_product_v2ProductCategory
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_product_v2ProductName IS NOT NULL
GROUP BY hits_product_v2ProductCategory
ORDER BY number_of_products DESC
LIMIT 5;
```

---

## 11. Command-Line Alternatives (Cloud Shell)

### Universal setup commands (work in any lab)

```bash
gcloud auth list                        # active account
gcloud config list project              # current project
gcloud config set project PROJECT_ID    # select / switch project
gcloud services enable bigquery.googleapis.com   # enable a service API
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:someone@example.com" --role="roles/bigquery.jobUser"  # IAM grant
```

### UI step → CLI equivalent for this lab

| Console (UI) step | Cloud Shell command |
|---|---|
| Star `data-to-insights` | UI-only; CLI uses full names: `bq ls data-to-insights:ecommerce` |
| Query Validator (pre-run check) | `bq query --use_legacy_sql=false --dry_run 'SELECT ...'` — errors surface *without* running; success prints bytes-to-scan |
| Red exclamation / Job information error | Run it and read stderr — same `[line:column]` coordinates: `Error in query string: ... at [3:1]` |
| The legacy-SQL bug, CLI edition | `bq query` **defaults to legacy SQL** — that's why every guide here uses `--use_legacy_sql=false`. The lab's Rung-2 bug is the exact mistake the flag prevents. |
| Run the fixed queries | `bq query --use_legacy_sql=false '<any query from section 10>'` |

---

### 💎 Beyond the Lab — Pro Tips

Extra details the lab doesn't tell you, worth knowing for real work and the certification exam:

- **Error coordinates are `[line:column]`.** `at [3:1]` = line 3, column 1 of your query. Navigating straight there instead of re-reading the whole query is half the skill of debugging SQL.
- **The missing-comma bug has a modern vaccine:** GoogleSQL supports **trailing commas** in SELECT lists (`SELECT a, b, FROM ...`) — ending *every* line with a comma makes a missing one impossible. The lab's leading-comma style (`, hits_page_pageTitle`) is the older convention for the same purpose.
- **Aliases-in-HAVING is a BigQuery kindness, not a SQL standard.** `HAVING avg_products_ordered > 20` works because BigQuery lets HAVING see SELECT aliases — many other databases force you to repeat the whole `SUM(...)/COUNT(...)` expression. Don't be surprised when this breaks elsewhere.
- **Dry-run everything you didn't write.** Before running a teammate's query, `--dry_run` it (or just read the validator): you get syntax errors *and* the bytes estimate without spending a cent — catching both bug families' cheapest symptoms.
- **`(not set)` vs `${...}` is a data-quality lesson**, not trivia: one means "no value assigned", the other means "instrumentation bug upstream" (the GA script fired before render). Distinguishing *missing data* from *broken pipelines* is a real analyst skill.
- **Exam tip:** legacy vs standard SQL identifiers are a favorite question — `[project:dataset.table]` = legacy, `` `project.dataset.table` `` = standard, and the `bq` CLI still *defaults to legacy* while the console defaults to standard.

---

### 🏁 Summary of the Journey

```mermaid
flowchart LR
    T2[Task 2 - Climb the 7-rung error ladder to checkout visitors]
    T3[Task 3 - Cities analysis and the WHERE vs HAVING trap]
    T4[Task 4 - Category counts and the COUNT DISTINCT logic bug]
    DONE[Lab Complete]

    T2 --> T3
    T3 --> T4
    T4 --> DONE
```

**Key lessons learned:**
1. **Two families of bugs:** syntax errors (the validator catches them) and logic errors (only a human asking "does this answer the question?" catches them).
2. The **missing comma** is the sneakiest bug in SQL — it silently turns your second column into an alias and returns *wrong-looking-right* results.
3. **WHERE filters rows before grouping; HAVING filters groups after** — filtering an aggregate in WHERE is impossible by design, not by BigQuery's whim.
4. Backticks = standard SQL, square brackets + colon = legacy SQL — know both on sight.
5. `COUNT(x)` counts rows; **`COUNT(DISTINCT x)` counts things** — pick per the question, not by habit.
6. Messy category values like `(not set)` and un-rendered `${template}` code are diagnostic clues about the *data pipeline*, not just noise to filter.
