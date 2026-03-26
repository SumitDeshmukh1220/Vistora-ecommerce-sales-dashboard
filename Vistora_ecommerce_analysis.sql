-- ============================================================
--   VISTORA ECOMMERCE SALES ANALYSIS — SQL QUERIES
--   Author  : Sumit Ganesh Deshmukh
--   Dataset : Orders.csv + Details.csv (500 orders, 1500 line items)
--   Purpose : Data cleaning, transformation & KPI extraction
--             before loading into Power BI
-- ============================================================


-- ─────────────────────────────────────────────────────────────
-- 1. TABLE CREATION
-- ─────────────────────────────────────────────────────────────

CREATE TABLE orders (
    order_id     VARCHAR(20) PRIMARY KEY,
    order_date   DATE,
    customer_name VARCHAR(100),
    state        VARCHAR(100),
    city         VARCHAR(100)
);

CREATE TABLE details (
    order_id     VARCHAR(20),
    amount       DECIMAL(10, 2),
    profit       DECIMAL(10, 2),
    quantity     INT,
    category     VARCHAR(50),
    sub_category VARCHAR(50),
    payment_mode VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


-- ─────────────────────────────────────────────────────────────
-- 2. DATA CLEANING
-- ─────────────────────────────────────────────────────────────

-- 2a. Check for NULL or missing values in Orders
SELECT
    SUM(CASE WHEN order_id     IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN order_date   IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS null_customer,
    SUM(CASE WHEN state        IS NULL THEN 1 ELSE 0 END) AS null_state,
    SUM(CASE WHEN city         IS NULL THEN 1 ELSE 0 END) AS null_city
FROM orders;

-- 2b. Check for NULL or missing values in Details
SELECT
    SUM(CASE WHEN order_id     IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN amount       IS NULL THEN 1 ELSE 0 END) AS null_amount,
    SUM(CASE WHEN profit       IS NULL THEN 1 ELSE 0 END) AS null_profit,
    SUM(CASE WHEN quantity     IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN category     IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN sub_category IS NULL THEN 1 ELSE 0 END) AS null_sub_category,
    SUM(CASE WHEN payment_mode IS NULL THEN 1 ELSE 0 END) AS null_payment
FROM details;

-- 2c. Trim whitespace from state and city columns
UPDATE orders
SET state = TRIM(state),
    city  = TRIM(city);

-- 2d. Standardize payment mode casing
UPDATE details
SET payment_mode = INITCAP(TRIM(payment_mode));

-- 2e. Check for duplicate Order IDs in Details
SELECT order_id, COUNT(*) AS occurrences
FROM details
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- 2f. Remove records with zero or negative quantity/amount
DELETE FROM details
WHERE quantity <= 0 OR amount <= 0;

-- 2g. Verify date format consistency (orders should be in 2018)
SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order
FROM orders;


-- ─────────────────────────────────────────────────────────────
-- 3. DATA TRANSFORMATION
-- ─────────────────────────────────────────────────────────────

-- 3a. Join Orders + Details into a unified master table
CREATE VIEW vw_master_sales AS
SELECT
    o.order_id,
    o.order_date,
    DATENAME(MONTH, o.order_date)  AS order_month,
    MONTH(o.order_date)            AS month_num,
    DATEPART(QUARTER, o.order_date) AS quarter,
    YEAR(o.order_date)             AS order_year,
    o.customer_name,
    o.state,
    o.city,
    d.amount,
    d.profit,
    d.quantity,
    d.category,
    d.sub_category,
    d.payment_mode,
    ROUND(d.amount / NULLIF(d.quantity, 0), 2) AS aov   -- Average Order Value
FROM orders o
JOIN details d ON o.order_id = d.order_id;

-- 3b. Add profit margin column
CREATE VIEW vw_sales_with_margin AS
SELECT *,
    ROUND((profit / NULLIF(amount, 0)) * 100, 2) AS profit_margin_pct
FROM vw_master_sales;


-- ─────────────────────────────────────────────────────────────
-- 4. KPI SUMMARY QUERIES
-- ─────────────────────────────────────────────────────────────

-- 4a. Top-level KPIs (card visuals in Power BI)
SELECT
    ROUND(SUM(amount),   0) AS total_revenue,    -- 438K
    ROUND(SUM(profit),   0) AS total_profit,     -- 37K
    SUM(quantity)           AS total_quantity,   -- 5615
    ROUND(SUM(amount) / NULLIF(COUNT(DISTINCT order_id), 0), 0) AS avg_order_value  -- 121K
FROM vw_master_sales;

-- 4b. Profit by Month (bar chart)
SELECT
    order_month,
    month_num,
    ROUND(SUM(profit), 0) AS monthly_profit
FROM vw_master_sales
GROUP BY order_month, month_num
ORDER BY month_num;

-- 4c. Revenue by State (horizontal bar chart)
SELECT
    state,
    ROUND(SUM(amount), 0) AS total_revenue
FROM vw_master_sales
GROUP BY state
ORDER BY total_revenue DESC;

-- 4d. Quantity sold by Category (donut chart)
SELECT
    category,
    SUM(quantity)                                              AS total_quantity,
    ROUND(SUM(quantity) * 100.0 / SUM(SUM(quantity)) OVER(), 1) AS pct_share
FROM vw_master_sales
GROUP BY category
ORDER BY total_quantity DESC;
-- Results: Clothing 63% | Electronics 21% | Furniture 17%

-- 4e. Quantity by Payment Mode (donut chart)
SELECT
    payment_mode,
    SUM(quantity)                                              AS total_quantity,
    ROUND(SUM(quantity) * 100.0 / SUM(SUM(quantity)) OVER(), 1) AS pct_share
FROM vw_master_sales
GROUP BY payment_mode
ORDER BY total_quantity DESC;
-- Results: COD 44% | UPI 21% | Debit Card 13% | Credit Card 12% | EMI ~10%

-- 4f. Profit by Sub-Category (horizontal bar chart)
SELECT
    sub_category,
    ROUND(SUM(profit), 0) AS total_profit
FROM vw_master_sales
GROUP BY sub_category
ORDER BY total_profit DESC;
-- Top: Printers | Bookcases | Saree | Accessories | Tables

-- 4g. Revenue by Top Customers (bar chart)
SELECT
    customer_name,
    ROUND(SUM(amount), 0) AS total_spent
FROM vw_master_sales
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;


-- ─────────────────────────────────────────────────────────────
-- 5. DEEP-DIVE ANALYSIS
-- ─────────────────────────────────────────────────────────────

-- 5a. Most profitable sub-categories per category
SELECT
    category,
    sub_category,
    ROUND(SUM(profit), 0)        AS total_profit,
    ROUND(AVG(profit / NULLIF(amount, 0)) * 100, 2) AS avg_margin_pct
FROM vw_master_sales
GROUP BY category, sub_category
ORDER BY category, total_profit DESC;

-- 5b. Loss-making months (negative profit)
SELECT
    order_month,
    month_num,
    ROUND(SUM(profit), 0) AS monthly_profit
FROM vw_master_sales
GROUP BY order_month, month_num
HAVING SUM(profit) < 0
ORDER BY month_num;

-- 5c. State-wise profit margin ranking
SELECT
    state,
    ROUND(SUM(amount), 0)                              AS revenue,
    ROUND(SUM(profit), 0)                              AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(amount), 0) * 100, 2) AS profit_margin_pct,
    RANK() OVER (ORDER BY SUM(profit) DESC)            AS profit_rank
FROM vw_master_sales
GROUP BY state
ORDER BY profit_rank;

-- 5d. Quarter-over-quarter performance
SELECT
    quarter,
    ROUND(SUM(amount), 0) AS revenue,
    ROUND(SUM(profit), 0) AS profit,
    SUM(quantity)          AS units_sold
FROM vw_master_sales
GROUP BY quarter
ORDER BY quarter;

-- 5e. Payment mode preference by category
SELECT
    category,
    payment_mode,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 0) AS revenue
FROM vw_master_sales
GROUP BY category, payment_mode
ORDER BY category, revenue DESC;

-- 5f. High-value orders (top 10% by amount)
SELECT *
FROM vw_master_sales
WHERE amount >= (
    SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY amount)
    FROM vw_master_sales
)
ORDER BY amount DESC;

-- 5g. Customer frequency analysis
SELECT
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(amount), 0)    AS lifetime_value,
    ROUND(AVG(amount), 0)    AS avg_order_value
FROM vw_master_sales
GROUP BY customer_name
ORDER BY total_orders DESC;


-- ─────────────────────────────────────────────────────────────
-- 6. DATA VALIDATION (pre Power BI load checks)
-- ─────────────────────────────────────────────────────────────

-- 6a. Confirm total record counts
SELECT
    (SELECT COUNT(*) FROM orders)  AS total_orders,
    (SELECT COUNT(*) FROM details) AS total_line_items;

-- 6b. Confirm no orphaned detail records (details without a matching order)
SELECT COUNT(*) AS orphaned_records
FROM details d
LEFT JOIN orders o ON d.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 6c. Final sanity check — totals must match dashboard KPIs
SELECT
    SUM(amount)   AS should_be_438K,
    SUM(profit)   AS should_be_37K,
    SUM(quantity) AS should_be_5615
FROM details;
