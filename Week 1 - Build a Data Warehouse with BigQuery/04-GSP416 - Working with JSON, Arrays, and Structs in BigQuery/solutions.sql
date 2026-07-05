-- ============================================================================
-- GSP416: Working with JSON, Arrays, and Structs in BigQuery
-- All task solutions in execution order.
-- NOTE: Task 1 (dataset `fruit_store`), the JSON table loads (Tasks 2 & 6),
-- and starring `bigquery-public-data` (Task 5) are done via the console.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- TASK 2a: An array literal — a list of items in brackets, one row.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  ['raspberry', 'blackberry', 'strawberry', 'cherry'] AS fruit_array;


-- ----------------------------------------------------------------------------
-- TASK 2b: Mixing types FAILS — arrays share exactly one data type.
-- Error: Array elements of types {INT64, STRING} do not have a common supertype
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  ['raspberry', 'blackberry', 'strawberry', 'cherry', 1234567] AS fruit_array;


-- ----------------------------------------------------------------------------
-- TASK 2c: Query a table that already has an array; click the JSON tab in
-- the results to see the nested structure.
-- (Then load gs://spls/gsp416/.../shopping_cart.json as fruit_store.fruit_details,
-- format JSONL, schema auto-detect — fruit_array shows Mode = REPEATED.)
-- ----------------------------------------------------------------------------
#standardSQL
SELECT person, fruit_array, total_cost
FROM `data-to-insights.advanced.fruit_store`;


-- ----------------------------------------------------------------------------
-- TASK 3a: The flat version — 111 rows for one visitor.
-- ----------------------------------------------------------------------------
SELECT
  fullVisitorId,
  date,
  v2ProductName,
  pageTitle
FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
ORDER BY date;


-- ----------------------------------------------------------------------------
-- TASK 3b: ARRAY_AGG rolls the 111 rows up into 2 rows (one per day).
-- ----------------------------------------------------------------------------
SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(v2ProductName) AS products_viewed,
  ARRAY_AGG(pageTitle) AS pages_viewed
FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date;


-- ----------------------------------------------------------------------------
-- TASK 3c: ARRAY_LENGTH counts elements — 109 pages viewed on 20170801.
-- ----------------------------------------------------------------------------
SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(v2ProductName)) AS num_products_viewed,
  ARRAY_AGG(pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(pageTitle)) AS num_pages_viewed
FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date;


-- ----------------------------------------------------------------------------
-- TASK 3d: DISTINCT inside ARRAY_AGG dedups — only 8 distinct pages.
-- ----------------------------------------------------------------------------
SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(DISTINCT v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT v2ProductName)) AS distinct_products_viewed,
  ARRAY_AGG(DISTINCT pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT pageTitle)) AS distinct_pages_viewed
FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date;


-- ----------------------------------------------------------------------------
-- TASK 4a: Explore the native-arrays GA sample table. The "blank" cells are
-- fields at a higher granularity (session vs hit), not missing data.
-- ----------------------------------------------------------------------------
SELECT
  *
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE visitId = 1501570398;


-- ----------------------------------------------------------------------------
-- TASK 4b: Direct access into an array FAILS:
-- Error: Cannot access field page on a value with type ARRAY<STRUCT<...>>
-- ----------------------------------------------------------------------------
SELECT
  visitId,
  hits.page.pageTitle
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE visitId = 1501570398;


-- ----------------------------------------------------------------------------
-- TASK 4c: The fix — UNNEST() flattens the array back into rows.
-- UNNEST always follows the table name in the FROM clause.
-- ----------------------------------------------------------------------------
SELECT DISTINCT
  visitId,
  h.page.pageTitle
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`,
UNNEST(hits) AS h
WHERE visitId = 1501570398
LIMIT 10;


-- ----------------------------------------------------------------------------
-- TASK 5: STRUCTs — the GA schema has 32 RECORDs (STRUCTs) and 11 REPEATED
-- fields (ARRAYs). The .* syntax returns every field of a STRUCT with no JOIN.
-- ----------------------------------------------------------------------------
SELECT
  visitId,
  totals.*,
  device.*
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE visitId = 1501570398
LIMIT 10;


-- ----------------------------------------------------------------------------
-- TASK 6a: STRUCT literals — dot notation for nested fields; an array can be
-- one of the fields inside a struct.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT STRUCT("Rudisha" as name, 23.4 as split) as runner;

#standardSQL
SELECT STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits) AS runner;


-- ----------------------------------------------------------------------------
-- TASK 6b: (Console) Create dataset `racing`; load race_results.json from GCS
-- (JSONL) with this schema pasted via "Edit as text":
--
-- [
--     {"name": "race", "type": "STRING", "mode": "NULLABLE"},
--     {"name": "participants", "type": "RECORD", "mode": "REPEATED",
--      "fields": [
--          {"name": "name", "type": "STRING", "mode": "NULLABLE"},
--          {"name": "splits", "type": "FLOAT", "mode": "REPEATED"}
--      ]}
-- ]
--
-- participants = the STRUCT (Type RECORD); participants.splits = the ARRAY
-- (Mode REPEATED).
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
-- TASK 6c: One row holds the whole 800M race (8 runners nested inside).
-- ----------------------------------------------------------------------------
#standardSQL
SELECT * FROM racing.race_results;


-- ----------------------------------------------------------------------------
-- TASK 6d: Direct struct access FAILS (granularity clash):
-- Error: Cannot access field name on a value with type ARRAY<STRUCT<...>>
-- ----------------------------------------------------------------------------
#standardSQL
SELECT race, participants.name
FROM racing.race_results;


-- ----------------------------------------------------------------------------
-- TASK 6e: Fix with a correlated CROSS JOIN on the struct — 8 rows, one per
-- racer, each tagged 800M. The comma form is the idiomatic shorthand.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT race, participants.name
FROM racing.race_results
CROSS JOIN
race_results.participants;  -- full STRUCT name (dataset prefix required)

#standardSQL
SELECT race, participants.name
FROM racing.race_results AS r, r.participants;


-- ----------------------------------------------------------------------------
-- TASK 7: COUNT the racers — UNNEST the participants struct array first.
-- Answer: 8.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT COUNT(p.name) AS racer_count
FROM racing.race_results AS r, UNNEST(r.participants) AS p;


-- ----------------------------------------------------------------------------
-- TASK 8: Total race time for runners whose names begin with R, fastest
-- first. Double UNNEST: struct array, then the splits array inside it.
-- Answer: Rudisha ~102.2, Rotich 103.6.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  p.name,
  SUM(split_times) as total_race_time
FROM racing.race_results AS r
, UNNEST(r.participants) AS p
, UNNEST(p.splits) AS split_times
WHERE p.name LIKE 'R%'
GROUP BY p.name
ORDER BY total_race_time ASC;


-- ----------------------------------------------------------------------------
-- TASK 9: Filter within array values — who ran the 23.2s lap?
-- Answer: Kipketer.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  p.name,
  split_time
FROM racing.race_results AS r
, UNNEST(r.participants) AS p
, UNNEST(p.splits) AS split_time
WHERE split_time = 23.2;
