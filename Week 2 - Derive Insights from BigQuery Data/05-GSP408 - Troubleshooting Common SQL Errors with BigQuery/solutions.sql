-- ============================================================================
-- GSP408: Troubleshooting Common SQL Errors with BigQuery
-- The broken queries (commented, with diagnosis) and the working fixes,
-- in execution order.
-- Task 1 (star the data-to-insights project) is console-only.
-- ============================================================================


-- ============================================================================
-- TASK 2: How many unique visitors reached checkout?
-- ============================================================================

-- BROKEN (rung 1): typo in the dataset name (data-to-inghts) AND no columns.
--   SELECT  FROM `data-to-inghts.ecommerce.rev_transactions` LIMIT 1000

-- BROKEN (rung 2): legacy SQL syntax — square brackets + project:dataset colon.
--   SELECT * FROM [data-to-insights:ecommerce.rev_transactions] LIMIT 1000

-- BROKEN (rung 3): standard SQL now, but still no columns in the SELECT.
--   SELECT FROM `data-to-insights.ecommerce.rev_transactions`

-- RUNS BUT USELESS (rung 4): no aggregation, limit, or sorting — no insight.
--   SELECT fullVisitorId FROM `data-to-insights.ecommerce.rev_transactions`

-- LOGIC BUG (rung 5): missing comma! hits_page_pageTitle silently becomes an
-- ALIAS for fullVisitorId — returns 1 column with the wrong name, no error.
--   SELECT fullVisitorId hits_page_pageTitle
--   FROM `data-to-insights.ecommerce.rev_transactions` LIMIT 1000

-- RUNS (rung 6): comma fixed, two real columns — but visitors repeat across
-- rows, and raw rows still don't answer "how many?".
#standardSQL
SELECT
  fullVisitorId
  , hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions` LIMIT 1000;

-- BROKEN (rung 7a): aggregate + bare column with no GROUP BY.
--   SELECT COUNT(fullVisitorId) AS visitor_count, hits_page_pageTitle
--   FROM `data-to-insights.ecommerce.rev_transactions`

-- WORKING (rung 7b): COUNT(DISTINCT) dedups visitors; GROUP BY satisfies the
-- aggregate rule; WHERE zooms to the checkout page.
#standardSQL
SELECT
COUNT(DISTINCT fullVisitorId) AS visitor_count
, hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_page_pageTitle = "Checkout Confirmation"
GROUP BY hits_page_pageTitle;


-- ============================================================================
-- TASK 3: Cities with the most transactions
-- ============================================================================

-- Step 1: complete the partial query — totals_transactions must be wrapped
-- in SUM() once aggregates are present, and GROUP BY needs the city column.
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS totals_transactions,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors
FROM
`data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city;

-- Step 2: top cities first. Answer: Mountain View has the most distinct
-- visitors (ignoring 'not available in this demo dataset').
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS totals_transactions,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors
FROM
`data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city
ORDER BY distinct_visitors DESC;

-- Step 3: calculated field — average products per order by city.
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS total_products_ordered,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
FROM
`data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city
ORDER BY avg_products_ordered DESC;

-- BROKEN: WHERE cannot filter an aggregated field (WHERE runs BEFORE
-- GROUP BY, so avg_products_ordered doesn't exist yet). Use HAVING.
--   ... WHERE avg_products_ordered > 20 GROUP BY geoNetwork_city ...

-- WORKING: HAVING filters after aggregation.
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
ORDER BY avg_products_ordered DESC;


-- ============================================================================
-- TASK 4: Total number of products in each category
-- ============================================================================

-- RUNS BUT WASTEFUL: giant GROUP BY with no aggregates is just an expensive
-- DISTINCT — filter first and/or aggregate.
--   SELECT hits_product_v2ProductName, hits_product_v2ProductCategory
--   FROM `data-to-insights.ecommerce.rev_transactions`
--   GROUP BY 1,2

-- LOGIC BUG: COUNT() counts ROWS (product appearances), not distinct
-- products — popular products inflate their category.
--   SELECT COUNT(hits_product_v2ProductName) as number_of_products, ...

-- WORKING: COUNT(DISTINCT ...) counts each product once per category.
-- Answer: "(not set)" has the most distinct products.
--   (not set)  = product has no category assigned
--   ${productitem.product.origCatName} = un-rendered front-end template code:
--   the GA tracking script fired before the page finished rendering.
#standardSQL
SELECT
COUNT(DISTINCT hits_product_v2ProductName) as number_of_products,
hits_product_v2ProductCategory
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_product_v2ProductName IS NOT NULL
GROUP BY hits_product_v2ProductCategory
ORDER BY number_of_products DESC
LIMIT 5;
