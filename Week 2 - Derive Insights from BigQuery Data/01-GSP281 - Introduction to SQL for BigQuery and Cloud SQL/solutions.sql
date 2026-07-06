-- ============================================================================
-- GSP281: Introduction to SQL for BigQuery and Cloud SQL
-- All queries in execution order.
-- The lab has two halves: BigQuery (GoogleSQL, web console) and
-- Cloud SQL (MySQL 8.0, via Cloud Shell). Console-only steps are noted.
-- ============================================================================


-- ============================================================================
-- PART 1 — BIGQUERY (run in the BigQuery query editor)
-- Prereq: Explorer > + Add data > Star a project by name > bigquery-public-data
-- ============================================================================

-- ----------------------------------------------------------------------------
-- TASK 2a: SELECT one column — returns all 83,434,866 rows.
-- ----------------------------------------------------------------------------
SELECT end_station_name FROM `bigquery-public-data.london_bicycles.cycle_hire`;

-- ----------------------------------------------------------------------------
-- TASK 2b: WHERE filter — trips of 20+ minutes (duration is in seconds,
-- 60 * 20 = 1200). Returns 26,441,016 rows: ~30% of all rides.
-- ----------------------------------------------------------------------------
SELECT * FROM `bigquery-public-data.london_bicycles.cycle_hire` WHERE duration>=1200;

-- ----------------------------------------------------------------------------
-- TASK 3a: GROUP BY — unique starting stations. Returns 954 rows.
-- ----------------------------------------------------------------------------
SELECT start_station_name FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name;

-- ----------------------------------------------------------------------------
-- TASK 3b: COUNT per group — rides beginning at each station.
-- ----------------------------------------------------------------------------
SELECT start_station_name, COUNT(*) FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name;

-- ----------------------------------------------------------------------------
-- TASK 3c: AS — alias the count column to num_starts.
-- ----------------------------------------------------------------------------
SELECT start_station_name, COUNT(*) AS num_starts FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name;

-- ----------------------------------------------------------------------------
-- TASK 3d: ORDER BY three ways — alphabetical, ascending count, descending
-- count. Top station: "Hyde Park Corner, Hyde Park" with 671,688 starts
-- (still < 1% of all rides).
-- ----------------------------------------------------------------------------
SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY start_station_name;

SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num;

SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num DESC;
-- ^ Save results > Local download > CSV  ->  start_station_name.csv

-- ----------------------------------------------------------------------------
-- TASK 4: Twin query for END stations.
-- Save results > Local download > CSV  ->  end_station_name.csv
-- Then (console): create a Cloud Storage bucket named after your Project ID
-- and upload both CSVs into it.
-- ----------------------------------------------------------------------------
SELECT end_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY end_station_name ORDER BY num DESC;


-- ============================================================================
-- PART 2 — CLOUD SQL (MySQL 8.0)
-- Console: create instance `my-demo` (Enterprise edition, Development preset,
-- MySQL 8.0, Multiple zones, primary europe-west1-d, password ChangeMe1!).
-- Connect from Cloud Shell:
--
--   gcloud sql connect my-demo --user=root --quiet
--
-- Everything below runs at the mysql> prompt.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- TASK 6a: Create the database.
-- ----------------------------------------------------------------------------
CREATE DATABASE bike;

-- ----------------------------------------------------------------------------
-- TASK 6b: Create the two tables shaped to receive the CSVs.
-- VARCHAR(255) = text up to 255 chars; INT = whole number.
-- ----------------------------------------------------------------------------
USE bike;
CREATE TABLE london1 (start_station_name VARCHAR(255), num INT);

USE bike;
CREATE TABLE london2 (end_station_name VARCHAR(255), num INT);

-- Confirm both are empty ("Empty set") before import:
SELECT * FROM london1;
SELECT * FROM london2;

-- ----------------------------------------------------------------------------
-- TASK 7 (console): Cloud SQL instance page > Import, for each file:
--   CSV | bucket file start_station_name.csv | database bike | table london1
--   CSV | bucket file end_station_name.csv   | database bike | table london2
-- Then verify: london1 = 955 rows, london2 = 959 rows (headers included!).
-- ----------------------------------------------------------------------------
SELECT * FROM london1;
SELECT * FROM london2;

-- ----------------------------------------------------------------------------
-- TASK 8a: DELETE — the CSV header line imported as a data row with num=0;
-- remove it from both tables. (DELETE removes ALL rows matching the WHERE.)
-- ----------------------------------------------------------------------------
DELETE FROM london1 WHERE num=0;
DELETE FROM london2 WHERE num=0;

-- ----------------------------------------------------------------------------
-- TASK 8b: INSERT INTO — add a new row (columns listed first, then VALUES).
-- ----------------------------------------------------------------------------
INSERT INTO london1 (start_station_name, num) VALUES ("test destination", 1);

-- ----------------------------------------------------------------------------
-- TASK 8c: UNION — stations with over 100,000 ride starts OR ends, sorted
-- Z->A. The first SELECT's aliases (top_stations, num) name the output.
-- Insight: 13 of the 14 top stations appear on both lists.
-- ----------------------------------------------------------------------------
SELECT start_station_name AS top_stations, num FROM london1 WHERE num>100000
UNION
SELECT end_station_name, num FROM london2 WHERE num>100000
ORDER BY top_stations DESC;
