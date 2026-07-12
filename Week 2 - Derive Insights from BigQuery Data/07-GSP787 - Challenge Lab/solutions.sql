-- ============================================================================
-- GSP787: Derive Insights from BigQuery Data - Challenge Lab
-- All task solutions in order.
--
-- *** IMPORTANT: values are PARAMETERIZED PER SESSION. ***
-- Every <PLACEHOLDER> below must be replaced with the value shown in YOUR
-- lab instructions (dates, thresholds, limits). Example values are noted.
-- Output column aliases must match EXACTLY - the grader checks names.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- TASK 1: Total confirmed cases worldwide on a date.
-- ----------------------------------------------------------------------------
SELECT
  SUM(cumulative_confirmed) AS total_cases_worldwide
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
  date = '<DATE>';              -- e.g. '2020-06-15'


-- ----------------------------------------------------------------------------
-- TASK 2: How many US states had more than <DEATH_COUNT> deaths on <DATE>?
-- subregion1_name IS NOT NULL excludes country-level rows.
-- ----------------------------------------------------------------------------
WITH deaths_by_states AS (
  SELECT
    subregion1_name AS state,
    SUM(cumulative_deceased) AS death_count
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name = "United States of America"
    AND subregion1_name IS NOT NULL
    AND date = '<DATE>'          -- e.g. '2020-06-15'
  GROUP BY subregion1_name
)
SELECT
  COUNT(*) AS count_of_states
FROM deaths_by_states
WHERE death_count > <DEATH_COUNT>;   -- e.g. 300


-- ----------------------------------------------------------------------------
-- TASK 3: US states with more than <CONFIRMED_CASES> confirmed cases,
-- descending. NOTE: this task filters on country_code, not country_name.
-- HAVING (not WHERE) filters the aggregate.
-- ----------------------------------------------------------------------------
SELECT
  subregion1_name AS state,
  SUM(cumulative_confirmed) AS total_confirmed_cases
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
  country_code = "US"
  AND subregion1_name IS NOT NULL
  AND date = '<DATE>'                -- e.g. '2020-06-15'
GROUP BY subregion1_name
HAVING total_confirmed_cases > <CONFIRMED_CASES>   -- e.g. 250000
ORDER BY total_confirmed_cases DESC;


-- ----------------------------------------------------------------------------
-- TASK 4: Case-fatality ratio in Italy for <MONTH> 2020.
-- Watch month lengths: Apr/Jun end on 30, May ends on 31.
-- ----------------------------------------------------------------------------
SELECT
  SUM(cumulative_confirmed) AS total_confirmed_cases,
  SUM(cumulative_deceased) AS total_deaths,
  (SUM(cumulative_deceased) / SUM(cumulative_confirmed)) * 100 AS case_fatality_ratio
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
  country_name = "Italy"
  AND date BETWEEN '<MONTH_START>' AND '<MONTH_END>';  -- e.g. '2020-05-01' AND '2020-05-31'


-- ----------------------------------------------------------------------------
-- TASK 5: First day deaths crossed <DEATH_COUNT> in Italy.
-- cumulative_* never decreases, so the earliest qualifying date = crossing day.
-- ----------------------------------------------------------------------------
SELECT date
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
  country_name = "Italy"
  AND cumulative_deceased > <DEATH_COUNT>   -- e.g. 10000
GROUP BY date
ORDER BY date ASC
LIMIT 1;


-- ----------------------------------------------------------------------------
-- TASK 6: Fix the India zero-net-new-cases query.
-- Bugs: empty BETWEEN dates + no final SELECT reading the CTEs.
-- ----------------------------------------------------------------------------
WITH india_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name = "India"
    AND date BETWEEN '<START_DATE>' AND '<CLOSE_DATE>'  -- e.g. '2020-02-21' AND '2020-03-15'
  GROUP BY date
  ORDER BY date ASC
)

, india_previous_day_comparison AS (
  SELECT
    date,
    cases,
    LAG(cases) OVER(ORDER BY date) AS previous_day,
    cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
  FROM india_cases_by_date
)

SELECT
  COUNT(date) AS count_of_days_with_zero_net_new_cases
FROM india_previous_day_comparison
WHERE net_new_cases = 0;


-- ----------------------------------------------------------------------------
-- TASK 7: US dates (2020-03-22 .. 2020-04-20) where cases grew more than
-- <LIMIT_VALUE>% day-over-day. Same LAG skeleton as Task 6 plus the
-- percentage column. Aliases (incl. capitalization) must match exactly.
-- ----------------------------------------------------------------------------
WITH us_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name = "United States of America"
    AND date BETWEEN '2020-03-22' AND '2020-04-20'
  GROUP BY date
  ORDER BY date ASC
)

, us_previous_day_comparison AS (
  SELECT
    date,
    cases,
    LAG(cases) OVER(ORDER BY date) AS previous_day,
    cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases,
    (cases - LAG(cases) OVER(ORDER BY date)) * 100 / LAG(cases) OVER(ORDER BY date) AS percentage_increase
  FROM us_cases_by_date
)

SELECT
  date AS Date,
  cases AS Confirmed_Cases_On_Day,
  previous_day AS Confirmed_Cases_Previous_Day,
  percentage_increase AS Percentage_Increase_In_Cases
FROM us_previous_day_comparison
WHERE percentage_increase > <LIMIT_VALUE>;   -- e.g. 10


-- ----------------------------------------------------------------------------
-- TASK 8: Recovery rates on 2020-05-10, countries with > 50K confirmed,
-- descending, limited to <LIMIT_VALUE> rows.
-- ----------------------------------------------------------------------------
WITH cases_by_country AS (
  SELECT
    country_name AS country,
    SUM(cumulative_confirmed) AS cases,
    SUM(cumulative_recovered) AS recovered_cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    date = '2020-05-10'
  GROUP BY country_name
)

, recovered_rate AS (
  SELECT
    country,
    cases,
    recovered_cases,
    (recovered_cases * 100) / cases AS recovery_rate
  FROM cases_by_country
)

SELECT
  country,
  recovered_cases,
  cases AS confirmed_cases,
  recovery_rate
FROM recovered_rate
WHERE cases > 50000
ORDER BY recovery_rate DESC
LIMIT <LIMIT_VALUE>;   -- e.g. 10


-- ----------------------------------------------------------------------------
-- TASK 9: Fix the France CDGR query. Three planted bugs:
--   1) second date in the IN list was blank -> fill '2020-05-10'
--   2) LEAD(total_cases) had no OVER clause -> add OVER(ORDER BY date)
--   3) SQRT(x, y) doesn't exist -> POWER(x, y)
-- CDGR = (last_day_cases / first_day_cases)^(1/days_diff) - 1
-- ----------------------------------------------------------------------------
WITH
  france_cases AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS total_cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name = "France"
    AND date IN ('2020-01-24', '2020-05-10')
  GROUP BY date
  ORDER BY date
)

, summary AS (
  SELECT
    total_cases AS first_day_cases,
    LEAD(total_cases) OVER(ORDER BY date) AS last_day_cases,
    DATE_DIFF(LEAD(date) OVER(ORDER BY date), date, day) AS days_diff
  FROM france_cases
  LIMIT 1
)

SELECT
  first_day_cases,
  last_day_cases,
  days_diff,
  POWER((last_day_cases / first_day_cases), (1 / days_diff)) - 1 AS cdgr
FROM summary;


-- ----------------------------------------------------------------------------
-- TASK 10: Data Studio report (console + datastudio.google.com).
-- BigQuery connector -> Custom Query under YOUR project -> paste below ->
-- Add -> Add to report -> Time series chart with both metrics.
-- ----------------------------------------------------------------------------
SELECT
  date,
  SUM(cumulative_confirmed) AS country_cases,
  SUM(cumulative_deceased) AS country_deaths
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
  date BETWEEN '<RANGE_START>' AND '<RANGE_END>'   -- e.g. '2020-03-15' AND '2020-04-30'
  AND country_name = "United States of America"
GROUP BY date;
