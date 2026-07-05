-- ============================================================================
-- GSP413: Creating a Data Warehouse Through Joins and Unions
-- All task solutions in execution order.
-- NOTE: Task 1 (create the `ecommerce` dataset, Data Location = us) is done
-- via the console before running these queries.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- TASK 2a: Copy the data science team's sentiment table into your own
-- dataset so you can browse it (Preview / Schema tabs). The rest of the lab
-- queries the public `data-to-insights` project directly.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE ecommerce.products AS
SELECT
  *
FROM
  `data-to-insights.ecommerce.products`;


-- ----------------------------------------------------------------------------
-- TASK 2b: Top 5 products with the MOST POSITIVE sentiment.
-- Answer: G Noise-reducing Bluetooth Headphones has the highest sentiment.
-- ----------------------------------------------------------------------------
SELECT
  SKU,
  name,
  sentimentScore,
  sentimentMagnitude
FROM
  `data-to-insights.ecommerce.products`
ORDER BY
  sentimentScore DESC
LIMIT 5;


-- ----------------------------------------------------------------------------
-- TASK 2c: Top 5 products with the MOST NEGATIVE sentiment.
-- The IS NOT NULL filter removes unreviewed products (NULL scores).
-- Answer: Mens Vintage Henley has the lowest sentiment.
-- ----------------------------------------------------------------------------
SELECT
  SKU,
  name,
  sentimentScore,
  sentimentMagnitude
FROM
  `data-to-insights.ecommerce.products`
WHERE sentimentScore IS NOT NULL
ORDER BY
  sentimentScore
LIMIT 5;


-- ----------------------------------------------------------------------------
-- TASK 3a: Daily sales volume by productSKU for 08/01/2017.
-- IFNULL treats missing quantities as 0 so the SUM never breaks.
-- Result: 462 distinct SKUs sold; GGOEGOAQ012899 is the top seller.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE ecommerce.sales_by_sku_20170801 AS
SELECT
  productSKU,
  SUM(IFNULL(productQuantity, 0)) AS total_ordered
FROM
  `data-to-insights.ecommerce.all_sessions_raw`
WHERE date = '20170801'
GROUP BY productSKU
ORDER BY total_ordered DESC;  -- 462 SKUs sold


-- ----------------------------------------------------------------------------
-- TASK 3b: Enrich sales with inventory + sentiment via LEFT JOIN on SKU.
-- LEFT JOIN keeps every sold product even when inventory has no match.
-- ----------------------------------------------------------------------------
SELECT DISTINCT
  website.productSKU,
  website.total_ordered,
  inventory.name,
  inventory.stockLevel,
  inventory.restockingLeadTime,
  inventory.sentimentScore,
  inventory.sentimentMagnitude
FROM
  ecommerce.sales_by_sku_20170801 AS website
  LEFT JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU
ORDER BY total_ordered DESC;


-- ----------------------------------------------------------------------------
-- TASK 3c: Add sell-through ratio and keep only products that burned 50%+
-- of their stock. SAFE_DIVIDE returns NULL instead of erroring when
-- stockLevel = 0.
-- Answer: Leather Journal-Black — 250 orders out of 354 in stock.
-- ----------------------------------------------------------------------------
SELECT DISTINCT
  website.productSKU,
  website.total_ordered,
  inventory.name,
  inventory.stockLevel,
  inventory.restockingLeadTime,
  inventory.sentimentScore,
  inventory.sentimentMagnitude,
  SAFE_DIVIDE(website.total_ordered, inventory.stockLevel) AS ratio
FROM
  ecommerce.sales_by_sku_20170801 AS website
  LEFT JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU
WHERE SAFE_DIVIDE(website.total_ordered, inventory.stockLevel) >= .50
ORDER BY total_ordered DESC;


-- ----------------------------------------------------------------------------
-- TASK 4a: Create an empty table for the 08/02/2017 in-store sales.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE ecommerce.sales_by_sku_20170802
(
  productSKU STRING,
  total_ordered INT64
);


-- ----------------------------------------------------------------------------
-- TASK 4b: Insert the record provided by the sales team.
-- ----------------------------------------------------------------------------
INSERT INTO ecommerce.sales_by_sku_20170802
(productSKU, total_ordered)
VALUES('GGOEGHPA002910', 101);


-- ----------------------------------------------------------------------------
-- TASK 4c: Append both daily tables with UNION ALL.
-- UNION ALL keeps duplicates; plain UNION (DISTINCT) removes them.
-- ----------------------------------------------------------------------------
SELECT * FROM ecommerce.sales_by_sku_20170801
UNION ALL
SELECT * FROM ecommerce.sales_by_sku_20170802;


-- ----------------------------------------------------------------------------
-- TASK 4d: Same result with a table wildcard — scales to any number of
-- date-sharded tables without chaining UNIONs.
-- ----------------------------------------------------------------------------
SELECT * FROM `ecommerce.sales_by_sku_2017*`;


-- ----------------------------------------------------------------------------
-- TASK 4e: Wildcard filtered to a single day via _TABLE_SUFFIX.
-- ----------------------------------------------------------------------------
SELECT * FROM `ecommerce.sales_by_sku_2017*`
WHERE _TABLE_SUFFIX = '0802';
