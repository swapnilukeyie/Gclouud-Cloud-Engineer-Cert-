-- ============================================================================
-- GSP412: Troubleshooting and Solving Data Join Pitfalls
-- All task solutions in execution order.
-- NOTE: Task 1 (create the `ecommerce` dataset) and Task 2 (star the
-- data-to-insights project) are done via the console first.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- TASK 4a: How many products are on the website? (SKU + name pairs)
-- Result: 2,273 rows.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT DISTINCT
  productSKU,
  v2ProductName
FROM `data-to-insights.ecommerce.all_sessions_raw`;


-- ----------------------------------------------------------------------------
-- TASK 4b: How many DISTINCT SKUs? Result: 1,909 — fewer than 2,273, which
-- means multiple product names share the same SKU. Red flag for a join key.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT DISTINCT
  productSKU
FROM `data-to-insights.ecommerce.all_sessions_raw`;


-- ----------------------------------------------------------------------------
-- TASK 4c: Product names with MORE THAN ONE SKU (legitimate: size/colour
-- variants). Top result: Waze Womens Typography Short Sleeve Tee (12 SKUs).
-- ----------------------------------------------------------------------------
SELECT
  v2ProductName,
  COUNT(DISTINCT productSKU) AS SKU_count,
  STRING_AGG(DISTINCT productSKU LIMIT 5) AS SKU
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE productSKU IS NOT NULL
GROUP BY v2ProductName
HAVING SKU_count > 1
ORDER BY SKU_count DESC;


-- ----------------------------------------------------------------------------
-- TASK 4d: SKUs with MORE THAN ONE product name (the dangerous direction —
-- names are similar but not identical: renames, special characters).
-- Tip: swap STRING_AGG() for ARRAY_AGG() to see BigQuery's native arrays.
-- ----------------------------------------------------------------------------
SELECT
  productSKU,
  COUNT(DISTINCT v2ProductName) AS product_count,
  STRING_AGG(DISTINCT v2ProductName LIMIT 5) AS product_name
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE v2ProductName IS NOT NULL
GROUP BY productSKU
HAVING product_count > 1
ORDER BY product_count DESC;


-- ----------------------------------------------------------------------------
-- TASK 5a: One SKU, three product names (the 7" Dog Frisbee).
-- ----------------------------------------------------------------------------
SELECT DISTINCT
  v2ProductName,
  productSKU
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE productSKU = 'GGOEGPJC019099';


-- ----------------------------------------------------------------------------
-- TASK 5b: Inventory side is clean — exactly 1 row, stockLevel = 154.
-- Relationship is therefore many-to-one (website 3 rows -> inventory 1 row).
-- ----------------------------------------------------------------------------
SELECT
  SKU,
  name,
  stockLevel
FROM `data-to-insights.ecommerce.products`
WHERE SKU = 'GGOEGPJC019099';


-- ----------------------------------------------------------------------------
-- TASK 5c: The join duplicates stockLevel — 154 appears 3 times, once per
-- website product name.
-- ----------------------------------------------------------------------------
SELECT DISTINCT
  website.v2ProductName,
  website.productSKU,
  inventory.stockLevel
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU
WHERE productSKU = 'GGOEGPJC019099';


-- ----------------------------------------------------------------------------
-- TASK 5d: SUM over the duplicated rows triple-counts the inventory:
-- 462 instead of 154. This is an unintentional cross join.
-- ----------------------------------------------------------------------------
WITH inventory_per_sku AS (
  SELECT DISTINCT
    website.v2ProductName,
    website.productSKU,
    inventory.stockLevel
  FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
  JOIN `data-to-insights.ecommerce.products` AS inventory
    ON website.productSKU = inventory.SKU
  WHERE productSKU = 'GGOEGPJC019099'
)
SELECT
  productSKU,
  SUM(stockLevel) AS total_inventory
FROM inventory_per_sku
GROUP BY productSKU;


-- ----------------------------------------------------------------------------
-- TASK 6a: Fix duplicates BEFORE joining — gather all names into an array
-- so there is only one row per SKU.
-- ----------------------------------------------------------------------------
SELECT
  productSKU,
  ARRAY_AGG(DISTINCT v2ProductName) AS push_all_names_into_array
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE productSKU = 'GGOEGAAX0098'
GROUP BY productSKU;

-- Keep exactly one name per SKU with LIMIT 1 inside the array:
SELECT
  productSKU,
  ARRAY_AGG(DISTINCT v2ProductName LIMIT 1) AS push_all_names_into_array
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE productSKU = 'GGOEGAAX0098'
GROUP BY productSKU;


-- ----------------------------------------------------------------------------
-- TASK 6b: Pitfall — losing rows. Plain JOIN is an INNER JOIN: only 1,090 of
-- the 1,909 website SKUs survive; 819 are silently dropped.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT DISTINCT
  website.productSKU
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU;

-- Pull the ID from both sides to confirm the matches:
#standardSQL
SELECT DISTINCT
  website.productSKU AS website_SKU,
  inventory.SKU AS inventory_SKU
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU;


-- ----------------------------------------------------------------------------
-- TASK 6c: Solution — LEFT JOIN keeps all 1,909 website SKUs; unmatched
-- inventory SKUs come back NULL.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT DISTINCT
  website.productSKU AS website_SKU,
  inventory.SKU AS inventory_SKU
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
LEFT JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU;

-- Filter for the NULLs: 819 website SKUs are missing from inventory.
#standardSQL
SELECT DISTINCT
  website.productSKU AS website_SKU,
  inventory.SKU AS inventory_SKU
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
LEFT JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU
WHERE inventory.SKU IS NULL;

-- Spot-check one missing SKU (returns zero results):
#standardSQL
SELECT * FROM `data-to-insights.ecommerce.products`
WHERE SKU = 'GGOEGATJ060517';


-- ----------------------------------------------------------------------------
-- TASK 6d: Reverse direction — RIGHT JOIN finds 2 inventory SKUs missing
-- from the website (an in-store-only soundbar and a brand-new product with
-- zero orders). Production tip: use LEFT JOIN with tables swapped instead.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT DISTINCT
  website.productSKU AS website_SKU,
  inventory.SKU AS inventory_SKU
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
RIGHT JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU
WHERE website.productSKU IS NULL;

-- Same, with full inventory details:
#standardSQL
SELECT DISTINCT
  website.productSKU AS website_SKU,
  inventory.*
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
RIGHT JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU
WHERE website.productSKU IS NULL;


-- ----------------------------------------------------------------------------
-- TASK 6e: FULL JOIN = LEFT + RIGHT — all 821 mismatches (819 + 2) at once.
-- ----------------------------------------------------------------------------
#standardSQL
SELECT DISTINCT
  website.productSKU AS website_SKU,
  inventory.SKU AS inventory_SKU
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
FULL JOIN `data-to-insights.ecommerce.products` AS inventory
  ON website.productSKU = inventory.SKU
WHERE website.productSKU IS NULL OR inventory.SKU IS NULL;


-- ----------------------------------------------------------------------------
-- TASK 6f: Unintentional CROSS JOIN demo.
-- 1 discount row  -> 82 clearance products.
-- 3 discount rows -> 246 rows (82 x 3): the dataset gets multiplied.
-- ----------------------------------------------------------------------------
#standardSQL
CREATE OR REPLACE TABLE ecommerce.site_wide_promotion AS
SELECT .05 AS discount;

-- 82 rows: one per clearance product (no ON clause in a CROSS JOIN)
SELECT DISTINCT
  productSKU,
  v2ProductCategory,
  discount
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
CROSS JOIN ecommerce.site_wide_promotion
WHERE v2ProductCategory LIKE '%Clearance%';

-- Sabotage: now 3 discount rows exist
INSERT INTO ecommerce.site_wide_promotion (discount)
VALUES (.04),
       (.03);

SELECT discount FROM ecommerce.site_wide_promotion;  -- 3 records

-- Re-run: 246 rows now (82 x 3)
SELECT DISTINCT
  productSKU,
  v2ProductCategory,
  discount
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
CROSS JOIN ecommerce.site_wide_promotion
WHERE v2ProductCategory LIKE '%Clearance%';

-- Zoom in on one SKU: it appears 3 times, once per discount value.
#standardSQL
SELECT DISTINCT
  productSKU,
  v2ProductCategory,
  discount
FROM `data-to-insights.ecommerce.all_sessions_raw` AS website
CROSS JOIN ecommerce.site_wide_promotion
WHERE v2ProductCategory LIKE '%Clearance%'
  AND productSKU = 'GGOEGOLC013299';
