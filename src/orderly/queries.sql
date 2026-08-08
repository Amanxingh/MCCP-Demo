-- Orderly analytical queries.
-- Each query is introduced by a marker comment of the form:
--   -- @query: <name>
-- The test suite extracts queries by marker and runs them against the seed
-- database. Keep one statement per query.

-- @query: category_totals
-- Revenue per product category, completed orders only, highest first.
SELECT p.category,
       SUM(oi.qty * oi.unit_price) AS revenue
FROM order_items oi
JOIN orders   o ON o.id = oi.order_id
JOIN products p ON p.id = oi.product_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY revenue DESC;

-- @query: monthly_revenue
-- TODO(T3-Q1): monthly revenue AND order count, completed orders only,
-- one row per month ('YYYY-MM'), ordered by month. Expected columns:
-- month, revenue, order_count
SELECT 'replace-me' AS month, 0 AS revenue, 0 AS order_count;

-- @query: top_products_per_month
-- TODO(T3-Q2): for each month, the top 2 products by total quantity sold
-- (completed orders). Use a window function. Expected columns:
-- month, product, total_qty, rnk
SELECT 'replace-me' AS month, 'replace-me' AS product, 0 AS total_qty, 0 AS rnk;

-- @query: customers_without_orders
-- TODO(T3-Q3): customers who have NEVER placed a completed order.
-- Use NOT EXISTS or NOT IN. Expected columns: name, city  (ordered by name)
SELECT 'replace-me' AS name, 'replace-me' AS city;
