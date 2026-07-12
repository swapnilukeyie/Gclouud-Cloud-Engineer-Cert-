-- ============================================================================
-- GSP407: Explore an Ecommerce Dataset with SQL in BigQuery
-- All queries in execution order.
-- Task 1 (star the data-to-insights project) is console-only:
--   Explorer > + Add data > Star a project by name > data-to-insights
-- ============================================================================


-- ----------------------------------------------------------------------------
-- TASK 2a (console): inspect all_sessions_raw via the three free tabs —
-- Schema (types), Details (5.63 GB, 21+ million rows), Preview (sample rows).
-- CLI: bq show --format=prettyjson data-to-insights:ecommerce.all_sessions_raw
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
-- TASK 2b: Find duplicate rows in the RAW table.
-- GROUP BY every field: identical rows collapse into one group whose
-- COUNT(*) > 1. HAVING filters after aggregation (WHERE cannot).
-- Result: 615 duplicated records.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT COUNT(*) as num_duplicate_rows, * FROM
`data-to-insights.ecommerce.all_sessions_raw`
GROUP BY
fullVisitorId, channelGrouping, time, country, city, totalTransactionRevenue, transactions, timeOnSite, pageviews, sessionQualityDim, date, visitId, type, productRefundAmount, productQuantity, productPrice, productRevenue, productSKU, v2ProductName, v2ProductCategory, productVariant, currencyCode, itemQuantity, itemRevenue, transactionRevenue, transactionId, pageTitle, searchKeyword, pagePathLevel1, eCommerceAction_type, eCommerceAction_step, eCommerceAction_option
HAVING num_duplicate_rows > 1;


-- ----------------------------------------------------------------------------
-- TASK 2c: Confirm the deduplicated all_sessions table is clean — group by
-- the fields the GA export schema says are unique together.
-- Note the GROUP BY 1,2,3... positional shorthand.
-- Result: zero records.
-- Schema reference: https://support.google.com/analytics/answer/3437719
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
fullVisitorId, # the unique visitor ID
visitId, # a visitor can have multiple visits
date, # session date stored as string YYYYMMDD
time, # time of the individual site hit (can be 0 to many per visitor session)
v2ProductName, # not unique since a product can have variants like Color
productSKU, # unique for each product
type, # a visitor can visit Pages and/or can trigger Events
eCommerceAction_type, # maps to 'add to cart', 'completed checkout'
eCommerceAction_step,
eCommerceAction_option,
  transactionRevenue, # revenue of the order
  transactionId, # unique identifier for revenue bearing transaction
COUNT(*) as row_count
FROM
`data-to-insights.ecommerce.all_sessions`
GROUP BY 1,2,3 ,4, 5, 6, 7, 8, 9, 10,11,12
HAVING row_count > 1;


-- ----------------------------------------------------------------------------
-- TASK 3a: Total product views vs unique visitors.
-- COUNT(*) = all rows; COUNT(DISTINCT ...) = different people.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  COUNT(*) AS product_views,
  COUNT(DISTINCT fullVisitorId) AS unique_visitors
FROM `data-to-insights.ecommerce.all_sessions`;


-- ----------------------------------------------------------------------------
-- TASK 3b: Unique visitors by marketing channel (channelGrouping).
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  COUNT(DISTINCT fullVisitorId) AS unique_visitors,
  channelGrouping
FROM `data-to-insights.ecommerce.all_sessions`
GROUP BY channelGrouping
ORDER BY channelGrouping DESC;


-- ----------------------------------------------------------------------------
-- TASK 3c: All unique product names alphabetically — GROUP BY does the
-- deduplication; ORDER BY defaults to ascending. Result: 633 products.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  (v2ProductName) AS ProductName
FROM `data-to-insights.ecommerce.all_sessions`
GROUP BY ProductName
ORDER BY ProductName;


-- ----------------------------------------------------------------------------
-- TASK 3d: Top 5 most-viewed products. type = 'PAGE' isolates real page
-- views (GA also logs event/transaction/item/social/... interaction types).
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  COUNT(*) AS product_views,
  (v2ProductName) AS ProductName
FROM `data-to-insights.ecommerce.all_sessions`
WHERE type = 'PAGE'
GROUP BY v2ProductName
ORDER BY product_views DESC
LIMIT 5;


-- ----------------------------------------------------------------------------
-- TASK 3e (bonus): Count each visitor once per product using a WITH clause
-- (CTE). Step 1 dedups to (visitor, product) pairs; step 2 counts the pairs.
-- ----------------------------------------------------------------------------
WITH unique_product_views_by_person AS (
-- find each unique product viewed by each visitor
SELECT
 fullVisitorId,
 (v2ProductName) AS ProductName
FROM `data-to-insights.ecommerce.all_sessions`
WHERE type = 'PAGE'
GROUP BY fullVisitorId, v2ProductName )

-- aggregate the top viewed products and sort them
SELECT
  COUNT(*) AS unique_view_count,
  ProductName
FROM unique_product_views_by_person
GROUP BY ProductName
ORDER BY unique_view_count DESC
LIMIT 5;


-- ----------------------------------------------------------------------------
-- TASK 3f: Add order stats. KEY INSIGHT: COUNT(productQuantity) counts only
-- non-NULL rows (= rows where an order happened), while SUM(productQuantity)
-- totals the units. Views != orders != units.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  COUNT(*) AS product_views,
  COUNT(productQuantity) AS orders,
  SUM(productQuantity) AS quantity_product_ordered,
  v2ProductName
FROM `data-to-insights.ecommerce.all_sessions`
WHERE type = 'PAGE'
GROUP BY v2ProductName
ORDER BY product_views DESC
LIMIT 5;


-- ----------------------------------------------------------------------------
-- TASK 3g: Average units per order = SUM(quantity) / COUNT(orders).
-- Winner: 22 oz YouTube Bottle Infuser at 9.38 units per order.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT
  COUNT(*) AS product_views,
  COUNT(productQuantity) AS orders,
  SUM(productQuantity) AS quantity_product_ordered,
  SUM(productQuantity) / COUNT(productQuantity) AS avg_per_order,
  (v2ProductName) AS ProductName
FROM `data-to-insights.ecommerce.all_sessions`
WHERE type = 'PAGE'
GROUP BY v2ProductName
ORDER BY product_views DESC
LIMIT 5;
