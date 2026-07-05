-- ============================================================================
-- GSP340: Build a Data Warehouse with BigQuery - Challenge Lab
-- All task solutions in execution order.
-- NOTE: Replace `qwiklabs-gcp-00-6a4f298cff37` with YOUR lab project ID.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- TASK 1: Create a date-partitioned table (dataset `covid` must exist first,
-- created via console with Location = US, matching the public source data).
-- Excludes GBR, BRA, CAN, USA. Partition expiry = 2175 days.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `qwiklabs-gcp-00-6a4f298cff37.covid.oxford_policy_tracker`
PARTITION BY date
OPTIONS (
  partition_expiration_days = 2175
) AS
SELECT
  *
FROM
  `bigquery-public-data.covid19_govt_response.oxford_policy_tracker`
WHERE
  alpha_3_code NOT IN ('GBR', 'BRA', 'CAN', 'USA');


-- ----------------------------------------------------------------------------
-- TASK 2: Add new columns to `covid_data.global_mobility_tracker_data`.
-- Task spec types map to GoogleSQL as: INTEGER -> INT64, FLOAT -> FLOAT64,
-- RECORD -> STRUCT.
-- ----------------------------------------------------------------------------
ALTER TABLE `qwiklabs-gcp-00-6a4f298cff37.covid_data.global_mobility_tracker_data`
ADD COLUMN population INT64,
ADD COLUMN country_area FLOAT64,
ADD COLUMN mobility STRUCT<
  avg_retail FLOAT64,
  avg_grocery FLOAT64,
  avg_parks FLOAT64,
  avg_transit FLOAT64,
  avg_workplace FLOAT64,
  avg_residential FLOAT64
>;


-- ----------------------------------------------------------------------------
-- TASK 3: Populate the population column in
-- `covid_data.consolidate_covid_tracker_data` from the ECDC public dataset.
-- SELECT DISTINCT is required: UPDATE...FROM must match at most ONE source
-- row per target row (the ECDC table has one row per country per day).
-- ----------------------------------------------------------------------------
UPDATE
  `qwiklabs-gcp-00-6a4f298cff37.covid_data.consolidate_covid_tracker_data` AS t0
SET
  t0.population = t2.pop_data_2019
FROM (
  SELECT DISTINCT
    country_territory_code,
    pop_data_2019
  FROM
    `bigquery-public-data.covid19_ecdc.covid_19_geographic_distribution_worldwide`
) AS t2
WHERE
  t0.alpha_3_code = t2.country_territory_code;


-- ----------------------------------------------------------------------------
-- TASK 4: Populate the country_area column from the Census Bureau
-- International dataset. The census table uses FIPS codes (no ISO alpha-3),
-- so we bridge via `utility_us.country_code_iso`.
-- MAX() + GROUP BY collapses duplicate join results to one row per country,
-- avoiding the "UPDATE/MERGE must match at most one source row" error.
-- ----------------------------------------------------------------------------
UPDATE
  `qwiklabs-gcp-00-6a4f298cff37.covid_data.consolidate_covid_tracker_data` AS t0
SET
  t0.country_area = t2.country_area
FROM (
  SELECT
    iso.alpha_3_code,
    MAX(census.country_area) AS country_area
  FROM
    `bigquery-public-data.census_bureau_international.country_names_area` AS census
  INNER JOIN
    `bigquery-public-data.utility_us.country_code_iso` AS iso
  ON
    census.country_code = iso.fips_code
  GROUP BY 1
) AS t2
WHERE
  t0.alpha_3_code = t2.alpha_3_code;
