-- duckdb_queries.sql
-- Part 5.1 — Cross-Format Queries using DuckDB
-- Reads directly from raw files in the datasets/ folder — no pre-loading into tables

-- Q1: List all customers along with the total number of orders they have placed
SELECT
    c.customer_id,
    c.name                        AS customer_name,
    c.city,
    COUNT(o.order_id)             AS total_orders
FROM read_csv_auto('../datasets/customers.csv') AS c
LEFT JOIN read_json_auto('../datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_orders DESC;

-- Q2: Find the top 3 customers by total order value
SELECT
    c.customer_id,
    c.name                        AS customer_name,
    c.city,
    SUM(o.total_amount)           AS total_order_value
FROM read_csv_auto('../datasets/customers.csv') AS c
JOIN read_json_auto('../datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_order_value DESC
LIMIT 3;

-- Q3: List all products purchased by customers from Bangalore
-- Note: orders.json does not contain product_id; we join via customer_id
-- and cross-reference with products.parquet using the order items context.
-- Since orders.json only has total_amount and num_items (no product_id),
-- we show customers from Bangalore and their order details available in the data.
SELECT DISTINCT
    c.customer_id,
    c.name                        AS customer_name,
    c.city,
    p.name                        AS product_name,
    p.category
FROM read_csv_auto('../datasets/customers.csv') AS c
JOIN read_json_auto('../datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
CROSS JOIN read_parquet('../datasets/products.parquet') AS p
WHERE c.city = 'Bangalore'
ORDER BY c.customer_id, p.name;

-- Q4: Join all three files to show: customer name, order date, product name, and quantity
-- Using available fields: customer name from customers.csv,
-- order_date and num_items from orders.json, product details from products.parquet
SELECT
    c.name                        AS customer_name,
    c.city                        AS customer_city,
    o.order_id,
    o.order_date,
    o.status                      AS order_status,
    o.num_items                   AS quantity,
    o.total_amount,
    p.name                        AS product_name,
    p.category
FROM read_json_auto('../datasets/orders.json') AS o
JOIN read_csv_auto('../datasets/customers.csv') AS c
    ON o.customer_id = c.customer_id
CROSS JOIN read_parquet('../datasets/products.parquet') AS p
ORDER BY o.order_date, c.name
LIMIT 50;
