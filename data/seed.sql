-- Orderly seed data (deterministic — do not edit)
PRAGMA foreign_keys = ON;
CREATE TABLE customers (
    id      INTEGER PRIMARY KEY,
    name    TEXT NOT NULL,
    city    TEXT NOT NULL,
    segment TEXT NOT NULL CHECK (segment IN ('retail','wholesale'))
);

CREATE TABLE products (
    id         INTEGER PRIMARY KEY,
    name       TEXT NOT NULL,
    category   TEXT NOT NULL,
    unit_price REAL NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE orders (
    id         INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    order_date TEXT NOT NULL,           -- ISO 'YYYY-MM-DD'
    status     TEXT NOT NULL CHECK (status IN ('completed','cancelled','returned'))
);

CREATE TABLE order_items (
    id         INTEGER PRIMARY KEY,
    order_id   INTEGER NOT NULL REFERENCES orders(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    qty        INTEGER NOT NULL CHECK (qty > 0),
    unit_price REAL NOT NULL
);
INSERT INTO customers VALUES (1, 'Asha Verma', 'Pune', 'retail');
INSERT INTO customers VALUES (2, 'Rohan Iyer', 'Bengaluru', 'retail');
INSERT INTO customers VALUES (3, 'Meera Nair', 'Kochi', 'wholesale');
INSERT INTO customers VALUES (4, 'Kabir Shah', 'Mumbai', 'retail');
INSERT INTO customers VALUES (5, 'Ananya Rao', 'Hyderabad', 'wholesale');
INSERT INTO customers VALUES (6, 'Vikram Bose', 'Kolkata', 'retail');
INSERT INTO customers VALUES (7, 'Sana Qureshi', 'Delhi', 'retail');
INSERT INTO customers VALUES (8, 'Dev Menon', 'Chennai', 'wholesale');
INSERT INTO customers VALUES (9, 'Priya Kulkarni', 'Pune', 'retail');
INSERT INTO customers VALUES (10, 'Arjun Pillai', 'Bengaluru', 'retail');
INSERT INTO products VALUES (1, 'Notebook A5', 'stationery', 120.00);
INSERT INTO products VALUES (2, 'Gel Pen (pack of 5)', 'stationery', 99.50);
INSERT INTO products VALUES (3, 'Desk Lamp', 'electronics', 899.00);
INSERT INTO products VALUES (4, 'USB-C Cable 1m', 'electronics', 349.00);
INSERT INTO products VALUES (5, 'Water Bottle 750ml', 'lifestyle', 499.00);
INSERT INTO products VALUES (6, 'Backpack 20L', 'lifestyle', 1499.00);
INSERT INTO products VALUES (7, 'Sticky Notes', 'stationery', 60.00);
INSERT INTO products VALUES (8, 'Wireless Mouse', 'electronics', 749.00);
INSERT INTO products VALUES (9, 'Travel Mug', 'lifestyle', 650.00);
INSERT INTO products VALUES (10, 'Keyboard Compact', 'electronics', 1299.00);
INSERT INTO orders VALUES (1, 1, '2026-01-24', 'completed');
INSERT INTO orders VALUES (2, 4, '2026-01-08', 'completed');
INSERT INTO orders VALUES (3, 2, '2026-01-22', 'cancelled');
INSERT INTO orders VALUES (4, 2, '2026-01-19', 'completed');
INSERT INTO orders VALUES (5, 1, '2026-01-01', 'completed');
INSERT INTO orders VALUES (6, 4, '2026-01-08', 'cancelled');
INSERT INTO orders VALUES (7, 10, '2026-01-01', 'cancelled');
INSERT INTO orders VALUES (8, 4, '2026-01-23', 'cancelled');
INSERT INTO orders VALUES (9, 7, '2026-01-08', 'completed');
INSERT INTO orders VALUES (10, 10, '2026-01-09', 'returned');
INSERT INTO orders VALUES (11, 7, '2026-02-11', 'completed');
INSERT INTO orders VALUES (12, 3, '2026-02-07', 'completed');
INSERT INTO orders VALUES (13, 2, '2026-02-03', 'completed');
INSERT INTO orders VALUES (14, 2, '2026-02-12', 'completed');
INSERT INTO orders VALUES (15, 10, '2026-02-09', 'cancelled');
INSERT INTO orders VALUES (16, 8, '2026-02-18', 'completed');
INSERT INTO orders VALUES (17, 7, '2026-02-03', 'cancelled');
INSERT INTO orders VALUES (18, 5, '2026-02-27', 'returned');
INSERT INTO orders VALUES (19, 6, '2026-02-19', 'completed');
INSERT INTO orders VALUES (20, 2, '2026-02-02', 'completed');
INSERT INTO orders VALUES (21, 5, '2026-02-03', 'completed');
INSERT INTO orders VALUES (22, 7, '2026-03-09', 'completed');
INSERT INTO orders VALUES (23, 6, '2026-03-06', 'completed');
INSERT INTO orders VALUES (24, 6, '2026-03-07', 'completed');
INSERT INTO orders VALUES (25, 2, '2026-03-20', 'completed');
INSERT INTO orders VALUES (26, 9, '2026-03-24', 'returned');
INSERT INTO orders VALUES (27, 3, '2026-03-15', 'completed');
INSERT INTO orders VALUES (28, 5, '2026-03-30', 'cancelled');
INSERT INTO orders VALUES (29, 4, '2026-03-22', 'completed');
INSERT INTO orders VALUES (30, 1, '2026-03-08', 'completed');
INSERT INTO orders VALUES (31, 6, '2026-03-13', 'completed');
INSERT INTO orders VALUES (32, 4, '2026-04-30', 'returned');
INSERT INTO orders VALUES (33, 6, '2026-04-07', 'completed');
INSERT INTO orders VALUES (34, 7, '2026-04-29', 'completed');
INSERT INTO orders VALUES (35, 3, '2026-04-09', 'completed');
INSERT INTO orders VALUES (36, 4, '2026-04-24', 'cancelled');
INSERT INTO orders VALUES (37, 9, '2026-04-09', 'cancelled');
INSERT INTO orders VALUES (38, 7, '2026-04-29', 'returned');
INSERT INTO orders VALUES (39, 7, '2026-04-12', 'completed');
INSERT INTO orders VALUES (40, 3, '2026-04-17', 'completed');
INSERT INTO orders VALUES (41, 2, '2026-04-25', 'completed');
INSERT INTO order_items VALUES (1, 1, 3, 2, 899.00);
INSERT INTO order_items VALUES (2, 2, 10, 1, 1299.00);
INSERT INTO order_items VALUES (3, 2, 7, 4, 60.00);
INSERT INTO order_items VALUES (4, 2, 10, 4, 1299.00);
INSERT INTO order_items VALUES (5, 2, 9, 3, 650.00);
INSERT INTO order_items VALUES (6, 3, 2, 5, 99.50);
INSERT INTO order_items VALUES (7, 4, 6, 1, 1499.00);
INSERT INTO order_items VALUES (8, 4, 5, 4, 499.00);
INSERT INTO order_items VALUES (9, 4, 3, 4, 899.00);
INSERT INTO order_items VALUES (10, 5, 5, 5, 499.00);
INSERT INTO order_items VALUES (11, 6, 9, 1, 650.00);
INSERT INTO order_items VALUES (12, 6, 5, 5, 499.00);
INSERT INTO order_items VALUES (13, 7, 3, 3, 899.00);
INSERT INTO order_items VALUES (14, 7, 3, 5, 899.00);
INSERT INTO order_items VALUES (15, 8, 10, 3, 1299.00);
INSERT INTO order_items VALUES (16, 9, 1, 1, 120.00);
INSERT INTO order_items VALUES (17, 9, 6, 3, 1499.00);
INSERT INTO order_items VALUES (18, 9, 4, 1, 349.00);
INSERT INTO order_items VALUES (19, 9, 4, 5, 349.00);
INSERT INTO order_items VALUES (20, 10, 2, 4, 99.50);
INSERT INTO order_items VALUES (21, 11, 9, 2, 650.00);
INSERT INTO order_items VALUES (22, 12, 8, 5, 749.00);
INSERT INTO order_items VALUES (23, 12, 3, 3, 899.00);
INSERT INTO order_items VALUES (24, 13, 4, 5, 349.00);
INSERT INTO order_items VALUES (25, 13, 4, 3, 349.00);
INSERT INTO order_items VALUES (26, 13, 7, 3, 60.00);
INSERT INTO order_items VALUES (27, 13, 8, 5, 749.00);
INSERT INTO order_items VALUES (28, 14, 2, 2, 99.50);
INSERT INTO order_items VALUES (29, 14, 4, 1, 349.00);
INSERT INTO order_items VALUES (30, 14, 6, 1, 1499.00);
INSERT INTO order_items VALUES (31, 14, 10, 5, 1299.00);
INSERT INTO order_items VALUES (32, 15, 10, 2, 1299.00);
INSERT INTO order_items VALUES (33, 15, 1, 1, 120.00);
INSERT INTO order_items VALUES (34, 16, 4, 1, 349.00);
INSERT INTO order_items VALUES (35, 17, 6, 1, 1499.00);
INSERT INTO order_items VALUES (36, 18, 5, 4, 499.00);
INSERT INTO order_items VALUES (37, 18, 4, 5, 349.00);
INSERT INTO order_items VALUES (38, 19, 10, 5, 1299.00);
INSERT INTO order_items VALUES (39, 19, 8, 2, 749.00);
INSERT INTO order_items VALUES (40, 20, 7, 2, 60.00);
INSERT INTO order_items VALUES (41, 20, 2, 1, 99.50);
INSERT INTO order_items VALUES (42, 20, 7, 3, 60.00);
INSERT INTO order_items VALUES (43, 20, 7, 4, 60.00);
INSERT INTO order_items VALUES (44, 21, 1, 1, 120.00);
INSERT INTO order_items VALUES (45, 21, 1, 4, 120.00);
INSERT INTO order_items VALUES (46, 21, 6, 1, 1499.00);
INSERT INTO order_items VALUES (47, 21, 4, 2, 349.00);
INSERT INTO order_items VALUES (48, 22, 9, 4, 650.00);
INSERT INTO order_items VALUES (49, 22, 3, 4, 899.00);
INSERT INTO order_items VALUES (50, 23, 5, 4, 499.00);
INSERT INTO order_items VALUES (51, 23, 4, 1, 349.00);
INSERT INTO order_items VALUES (52, 24, 9, 1, 650.00);
INSERT INTO order_items VALUES (53, 24, 1, 5, 120.00);
INSERT INTO order_items VALUES (54, 24, 1, 1, 120.00);
INSERT INTO order_items VALUES (55, 24, 4, 2, 349.00);
INSERT INTO order_items VALUES (56, 25, 8, 4, 749.00);
INSERT INTO order_items VALUES (57, 25, 4, 4, 349.00);
INSERT INTO order_items VALUES (58, 25, 1, 2, 120.00);
INSERT INTO order_items VALUES (59, 25, 7, 1, 60.00);
INSERT INTO order_items VALUES (60, 26, 5, 4, 499.00);
INSERT INTO order_items VALUES (61, 26, 5, 4, 499.00);
INSERT INTO order_items VALUES (62, 26, 9, 4, 650.00);
INSERT INTO order_items VALUES (63, 26, 3, 2, 899.00);
INSERT INTO order_items VALUES (64, 27, 4, 1, 349.00);
INSERT INTO order_items VALUES (65, 27, 10, 5, 1299.00);
INSERT INTO order_items VALUES (66, 27, 1, 3, 120.00);
INSERT INTO order_items VALUES (67, 28, 1, 5, 120.00);
INSERT INTO order_items VALUES (68, 29, 9, 5, 650.00);
INSERT INTO order_items VALUES (69, 29, 3, 1, 899.00);
INSERT INTO order_items VALUES (70, 29, 9, 1, 650.00);
INSERT INTO order_items VALUES (71, 29, 3, 1, 899.00);
INSERT INTO order_items VALUES (72, 30, 4, 4, 349.00);
INSERT INTO order_items VALUES (73, 31, 10, 2, 1299.00);
INSERT INTO order_items VALUES (74, 32, 10, 1, 1299.00);
INSERT INTO order_items VALUES (75, 33, 10, 5, 1299.00);
INSERT INTO order_items VALUES (76, 33, 9, 3, 650.00);
INSERT INTO order_items VALUES (77, 33, 5, 2, 499.00);
INSERT INTO order_items VALUES (78, 33, 6, 2, 1499.00);
INSERT INTO order_items VALUES (79, 34, 7, 2, 60.00);
INSERT INTO order_items VALUES (80, 34, 5, 4, 499.00);
INSERT INTO order_items VALUES (81, 34, 6, 1, 1499.00);
INSERT INTO order_items VALUES (82, 35, 8, 5, 749.00);
INSERT INTO order_items VALUES (83, 36, 2, 5, 99.50);
INSERT INTO order_items VALUES (84, 37, 9, 3, 650.00);
INSERT INTO order_items VALUES (85, 37, 3, 3, 899.00);
INSERT INTO order_items VALUES (86, 38, 4, 3, 349.00);
INSERT INTO order_items VALUES (87, 39, 3, 4, 899.00);
INSERT INTO order_items VALUES (88, 39, 9, 3, 650.00);
INSERT INTO order_items VALUES (89, 39, 10, 5, 1299.00);
INSERT INTO order_items VALUES (90, 40, 9, 3, 650.00);
INSERT INTO order_items VALUES (91, 41, 3, 3, 899.00);
