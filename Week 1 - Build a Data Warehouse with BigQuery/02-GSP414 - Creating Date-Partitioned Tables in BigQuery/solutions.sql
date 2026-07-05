-- ============================================================================
-- GSP414: Creating Date-Partitioned Tables in BigQuery
-- All task solutions in execution order.
-- NOTE: Task 1 (create the `ecommerce` dataset, defaults are fine) is done
-- via the console before running these queries.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- TASK 2a: Query the NON-partitioned table for 2017 visitors.
-- Query Validator: "This query will process 1.74 GB when run." Returns 5 rows.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT DISTINCT
  fullVisitorId,
  date,
  city,
  pageTitle
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE date = '20170708'
LIMIT 5;


-- ----------------------------------------------------------------------------
-- TASK 2b: Same query for a 2018 date that has no data.
-- Returns 0 rows but STILL scans 1.74 GB — the engine must check every record,
-- and LIMIT never reduces bytes scanned.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT DISTINCT
  fullVisitorId,
  date,
  city,
  pageTitle
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE date = '20180708'
LIMIT 5;


-- ----------------------------------------------------------------------------
-- TASK 2c: Create a date-partitioned table.
-- PARTITION BY requires a DATE or TIMESTAMP column, so PARSE_DATE converts
-- the string "20170708" into a proper DATE first.
-- Verify on the Details tab: Partitioned by Day, on date_formatted.
-- ----------------------------------------------------------------------------
#standardSQL
CREATE OR REPLACE TABLE ecommerce.partition_by_day
PARTITION BY date_formatted
OPTIONS(
  description="a table partitioned by date"
) AS
SELECT DISTINCT
  PARSE_DATE("%Y%m%d", date) AS date_formatted,
  fullvisitorId
FROM `data-to-insights.ecommerce.all_sessions_raw`;


-- ----------------------------------------------------------------------------
-- TASK 3a: Query the partitioned table for an existing date.
-- Partition pruning opens one drawer only: ~25 KB scanned instead of 1.74 GB.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT *
FROM `data-to-insights.ecommerce.partition_by_day`
WHERE date_formatted = '2016-08-01';


-- ----------------------------------------------------------------------------
-- TASK 3b: Query a date whose partition does not exist.
-- "This query will process 0 B when run" — the engine knows which partitions
-- exist before running, so it scans nothing at all.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT *
FROM `data-to-insights.ecommerce.partition_by_day`
WHERE date_formatted = '2018-07-08';


-- ----------------------------------------------------------------------------
-- TASK 4: Explore the NOAA GSOD weather data (sharded gsod1929..gsod2018
-- tables, NOT partitioned — added via + Add data > Public datasets).
-- Scans ~1.83 GB even with LIMIT 10, because shards have no pruning.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  DATE(CAST(year AS INT64), CAST(mo AS INT64), CAST(da AS INT64)) AS date,
  (SELECT ANY_VALUE(name) FROM `bigquery-public-data.noaa_gsod.stations` AS stations
   WHERE stations.usaf = stn) AS station_name,  -- Stations may have multiple names
  prcp
FROM `bigquery-public-data.noaa_gsod.gsod*` AS weather
WHERE prcp < 99.9  -- Filter unknown values
  AND prcp > 0     -- Filter stations/days with no precipitation
  AND _TABLE_SUFFIX >= '2018'
ORDER BY date DESC -- Where has it rained/snowed recently
LIMIT 10;


-- ----------------------------------------------------------------------------
-- TASK 5: Create an auto-expiring partitioned table (rolling 2-year window).
-- partition_expiration_days=730 deletes each daily partition once it is
-- 730 days old — used for storage cost control and privacy compliance.
-- ----------------------------------------------------------------------------
#standardSQL
CREATE OR REPLACE TABLE ecommerce.days_with_rain
PARTITION BY date
OPTIONS (
  partition_expiration_days=730,
  description="weather stations with precipitation, partitioned by day"
) AS
SELECT
  DATE(CAST(year AS INT64), CAST(mo AS INT64), CAST(da AS INT64)) AS date,
  (SELECT ANY_VALUE(name) FROM `bigquery-public-data.noaa_gsod.stations` AS stations
   WHERE stations.usaf = stn) AS station_name,  -- Stations may have multiple names
  prcp
FROM `bigquery-public-data.noaa_gsod.gsod*` AS weather
WHERE prcp < 99.9  -- Filter unknown values
  AND prcp > 0     -- Filter
  AND _TABLE_SUFFIX >= '2018';


-- ----------------------------------------------------------------------------
-- TASK 5b: Track average rainfall for the Wakayama, Japan station and
-- compute each partition's age with DATE_DIFF. Most recent days first.
-- ----------------------------------------------------------------------------
#standardSQL
# avg monthly precipitation
SELECT
  AVG(prcp) AS average,
  station_name,
  date,
  CURRENT_DATE() AS today,
  DATE_DIFF(CURRENT_DATE(), date, DAY) AS partition_age,
  EXTRACT(MONTH FROM date) AS month
FROM ecommerce.days_with_rain
WHERE station_name = 'WAKAYAMA' #Japan
GROUP BY station_name, date, today, month, partition_age
ORDER BY date DESC; # most recent days first


-- ----------------------------------------------------------------------------
-- TASK 6: Confirm expiration works — sort oldest partitions first.
-- The top row's partition_age must be at or below 730 days.
-- ----------------------------------------------------------------------------
#standardSQL
# avg monthly precipitation
SELECT
  AVG(prcp) AS average,
  station_name,
  date,
  CURRENT_DATE() AS today,
  DATE_DIFF(CURRENT_DATE(), date, DAY) AS partition_age,
  EXTRACT(MONTH FROM date) AS month
FROM ecommerce.days_with_rain
WHERE station_name = 'WAKAYAMA' #Japan
GROUP BY station_name, date, today, month, partition_age
ORDER BY partition_age DESC;
