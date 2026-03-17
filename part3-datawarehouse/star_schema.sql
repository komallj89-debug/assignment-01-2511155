-- star_schema.sql
-- Part 3.1 — Star Schema Design for retail_transactions.csv
-- Data warehouse for business intelligence reporting

-- ============================================================
-- DIMENSION TABLE: dim_date
-- ============================================================
CREATE TABLE dim_date (
    date_id        INT          NOT NULL,
    full_date      DATE         NOT NULL,
    day            INT          NOT NULL,
    month          INT          NOT NULL,
    month_name     VARCHAR(20)  NOT NULL,
    quarter        INT          NOT NULL,
    year           INT          NOT NULL,
    PRIMARY KEY (date_id)
);

INSERT INTO dim_date VALUES
(20230105, '2023-01-05',  5,  1, 'January',   1, 2023),
(20230201, '2023-02-01',  1,  2, 'February',  1, 2023),
(20230208, '2023-02-08',  8,  2, 'February',  1, 2023),
(20230331, '2023-03-31', 31,  3, 'March',     1, 2023),
(20230418, '2023-04-18', 18,  4, 'April',     2, 2023),
(20230521, '2023-05-21', 21,  5, 'May',       2, 2023),
(20230604, '2023-06-04',  4,  6, 'June',      2, 2023),
(20230801, '2023-08-01',  1,  8, 'August',    3, 2023),
(20230809, '2023-08-09',  9,  8, 'August',    3, 2023),
(20230829, '2023-08-29', 29,  8, 'August',    3, 2023),
(20231026, '2023-10-26', 26, 10, 'October',   4, 2023),
(20231118, '2023-11-18', 18, 11, 'November',  4, 2023),
(20231208, '2023-12-08',  8, 12, 'December',  4, 2023);

-- ============================================================
-- DIMENSION TABLE: dim_store
-- ============================================================
CREATE TABLE dim_store (
    store_id    INT          NOT NULL,
    store_name  VARCHAR(100) NOT NULL,
    store_city  VARCHAR(50)  NOT NULL,
    region      VARCHAR(50)  NOT NULL,
    PRIMARY KEY (store_id)
);

INSERT INTO dim_store VALUES
(1, 'Chennai Anna',    'Chennai',   'South'),
(2, 'Delhi South',     'Delhi',     'North'),
(3, 'Bangalore MG',    'Bangalore', 'South'),
(4, 'Mumbai Central',  'Mumbai',    'West'),
(5, 'Pune FC Road',    'Pune',      'West');

-- ============================================================
-- DIMENSION TABLE: dim_product
-- ============================================================
CREATE TABLE dim_product (
    product_id       INT          NOT NULL,
    product_name     VARCHAR(100) NOT NULL,
    category         VARCHAR(50)  NOT NULL,
    PRIMARY KEY (product_id)
);

INSERT INTO dim_product VALUES
(1,  'Speaker',     'Electronics'),
(2,  'Tablet',      'Electronics'),
(3,  'Phone',       'Electronics'),
(4,  'Smartwatch',  'Electronics'),
(5,  'Atta 10kg',   'Grocery'),
(6,  'Jeans',       'Clothing'),
(7,  'Biscuits',    'Grocery'),
(8,  'Jacket',      'Clothing'),
(9,  'Milk 1L',     'Grocery'),
(10, 'Saree',       'Clothing'),
(11, 'Laptop',      'Electronics'),
(12, 'Headphones',  'Electronics');

-- ============================================================
-- FACT TABLE: fact_sales
-- ============================================================
CREATE TABLE fact_sales (
    sale_id        INT          NOT NULL AUTO_INCREMENT,
    transaction_id VARCHAR(20)  NOT NULL,
    date_id        INT          NOT NULL,
    store_id       INT          NOT NULL,
    product_id     INT          NOT NULL,
    units_sold     INT          NOT NULL,
    unit_price     DECIMAL(12,2) NOT NULL,
    total_revenue  DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (date_id)    REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id)   REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- Cleaned data: standardized dates to YYYY-MM-DD, 
-- normalized category casing, removed NULL rows
INSERT INTO fact_sales (transaction_id, date_id, store_id, product_id, units_sold, unit_price, total_revenue) VALUES
('TXN5000', 20230829, 1,  1,  3,  49262.78, 147788.34),
('TXN5001', 20231208, 1,  2, 11,  23226.12, 255487.32),
('TXN5002', 20230201, 1,  3, 20,  48703.39, 974067.80),
('TXN5003', 20230201, 2,  2, 14,  23226.12, 325165.68),
('TXN5004', 20230105, 1,  4, 10,  58851.01, 588510.10),
('TXN5005', 20230809, 3,  5, 12,  52464.00, 629568.00),
('TXN5006', 20230331, 5,  4,  6,  58851.01, 353106.06),
('TXN5007', 20231026, 5,  6, 16,   2317.47,  37079.52),
('TXN5008', 20231208, 3,  7,  9,  27469.99, 247229.91),
('TXN5009', 20230809, 3,  4,  3,  58851.01, 176553.03),
('TXN5010', 20230604, 1,  8, 15,  30187.24, 452808.60),
('TXN5011', 20231026, 4,  6, 13,   2317.47,  30127.11),
('TXN5012', 20230521, 3, 11, 13,  42343.15, 550460.95),
('TXN5013', 20230418, 4,  9, 10,  43374.39, 433743.90),
('TXN5014', 20231118, 2,  8,  5,  30187.24, 150936.20),
('TXN5015', 20230201, 4, 10, 15,  35451.81, 531777.15),
('TXN5016', 20230801, 4, 10, 11,  35451.81, 389969.91),
('TXN5017', 20230521, 3,  8,  6,  30187.24, 181123.44),
('TXN5018', 20230208, 3, 12, 15,  39854.96, 597824.40);
