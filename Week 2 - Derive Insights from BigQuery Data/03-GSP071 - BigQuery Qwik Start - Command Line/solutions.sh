#!/bin/bash
# ============================================================================
# GSP071: BigQuery Qwik Start - Command Line
# All commands in execution order — this lab lives entirely in Cloud Shell,
# so the solutions file is a shell script rather than a .sql file.
# ============================================================================


# ----------------------------------------------------------------------------
# SETUP: activate Cloud Shell first (console top-right >_ icon, then
# Continue -> Authorize; it provisions a temp VM with a persistent 5GB
# home dir and gcloud/bq pre-installed).
# Then confirm identity and project — expected: your student account and
# the qwiklabs-gcp-XX-... project from the Lab setup panel.
# ----------------------------------------------------------------------------
gcloud auth list            # ACTIVE: * ACCOUNT: student-XX-...@qwiklabs.net
gcloud config list project  # [core] project = qwiklabs-gcp-XX-...

# Broader project/auth basics (not needed in Cloud Shell, but essential
# on a real machine where nothing is pre-configured):
#   gcloud projects list                    # all projects you can access
#   gcloud config set project PROJECT_ID    # select / switch project
#   gcloud config set account ACCOUNT_EMAIL # switch account
#   gcloud auth login                       # sign in (outside Cloud Shell)


# ----------------------------------------------------------------------------
# TASK 1: Examine a table — bq show prints schema + stats.
# Target grammar: project:dataset.table (colon after the project).
# shakespeare = 164,656 rows: word, word_count, corpus, corpus_date.
# ----------------------------------------------------------------------------
bq show bigquery-public-data:samples.shakespeare


# ----------------------------------------------------------------------------
# TASK 2: The built-in manual.
# ----------------------------------------------------------------------------
bq help query   # docs for the query command
bq help         # list all bq commands


# ----------------------------------------------------------------------------
# TASK 3a: Query — words containing "raisin" across all of Shakespeare.
# --use_legacy_sql=false selects standard SQL.
# Quote trick: single quotes outside, double quotes inside (no escaping).
# Result: praising 8, Praising 4, raising 5, dispraising 2,
#         dispraisingly 1, raisins 1 — "raisin" itself never appears.
# ----------------------------------------------------------------------------
bq query --use_legacy_sql=false \
'SELECT
   word,
   SUM(word_count) AS count
 FROM
   `bigquery-public-data`.samples.shakespeare
 WHERE
   word LIKE "%raisin%"
 GROUP BY
   word'


# ----------------------------------------------------------------------------
# TASK 3b: A word Shakespeare never wrote — returns no results.
# ----------------------------------------------------------------------------
bq query --use_legacy_sql=false \
'SELECT
   word
 FROM
   `bigquery-public-data`.samples.shakespeare
 WHERE
   word = "huzzah"'


# ----------------------------------------------------------------------------
# TASK 4a: List datasets — yours (empty), then the public project's
# (note the trailing colon on the project ID).
# ----------------------------------------------------------------------------
bq ls
bq ls bigquery-public-data:


# ----------------------------------------------------------------------------
# TASK 4b: Create the dataset. Naming rules: <=1024 chars, A-Za-z0-9_,
# cannot start with a number/underscore, no spaces.
# ----------------------------------------------------------------------------
bq mk babynames
bq ls   # confirm it appears


# ----------------------------------------------------------------------------
# TASK 4c: Download the SSA baby-names data INTO Cloud Shell and unzip.
# (Unlike GSP072, the source here is the public internet, not a GCS bucket.)
# ----------------------------------------------------------------------------
wget http://www.ssa.gov/OACT/babynames/names.zip
ls
unzip names.zip
ls   # one yobXXXX.txt file per year


# ----------------------------------------------------------------------------
# TASK 4d: bq load — creates the table AND loads the data in one step.
# Args: dataset.table  source-file  schema (compact column:type list).
# Loads from a LOCAL file. Synchronous; takes a few seconds.
# UTF-8 is assumed; use -E for ISO-8859-1 (Latin-1) data.
# ----------------------------------------------------------------------------
bq load babynames.names2010 yob2010.txt name:string,gender:string,count:integer

bq ls babynames                 # names2010   TABLE
bq show babynames.names2010     # schema + 34,073 rows


# ----------------------------------------------------------------------------
# TASK 5a: Top 5 most popular girls' names of 2010.
# (Double quotes outside, 'F' inside — the quote trick reversed.)
# Result: Isabella 22913, Sophia 20643, Emma 17345, Olivia 17028, Ava 15433.
# ----------------------------------------------------------------------------
bq query "SELECT name,count FROM babynames.names2010 WHERE gender = 'F' ORDER BY count DESC LIMIT 5"


# ----------------------------------------------------------------------------
# TASK 5b: Top 5 most UNUSUAL boys' names — ORDER BY count ASC.
# All show count = 5: the SSA omits names with fewer than 5 occurrences.
# ----------------------------------------------------------------------------
bq query "SELECT name,count FROM babynames.names2010 WHERE gender = 'M' ORDER BY count ASC LIMIT 5"


# ----------------------------------------------------------------------------
# TASK 7: Clean up — -r (recursive) also deletes every table inside.
# Confirm with Y when prompted.
# ----------------------------------------------------------------------------
bq rm -r babynames
