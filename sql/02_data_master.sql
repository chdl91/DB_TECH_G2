-- =====================================================================
-- Clothing store - master data (Oracle / FreeSQL)
-- Owner: Peter Zweifel
-- Run with "Run Script" after 01_ddl.sql, before 03_data_orders.sql.
--
-- STARTER DATA: a small, consistent set of example rows so everyone sees
-- the pattern. Extend it (more stores, products, variants, stock), but
-- keep the IDs below stable - 03_data_orders.sql references them.
--
-- ID ranges (agreed with Noé, who references store, employee, variant):
--   store_id      1 - 9
--   employee_id   101 - 199
--   category_id   10 - 49
--   supplier_id   50 - 99
--   product_id    201 - 499
--   variant_id    1001 - 1999
--
-- Data must contain (needed by the queries):
--   [x] at least 3 stores, each with >= 1 employee
--   [x] categories for several genders (WOMEN, MEN, KIDS, UNISEX)
--   [x] several products per category with different base_price
--         (category 10 and 12 have 2 products each)
--   [x] products with several variants (size/color)
--   [x] variants that are NEVER ordered: 1014, 1015 (product 207)
--   [x] inventory rows where quantity_on_hand <= reorder_level
--         (1002, 1007, 1013 in store 1; 1005 in store 2; 1010 in store 3)
--
-- Conventions:
--   - dates as DATE 'YYYY-MM-DD'
--   - SKU = <product code>-<product_id>-<size>-<color code>
--   - all names and brands are fictional
-- =====================================================================

-- ---------------------------------------------------------------------
-- cs_store
-- ---------------------------------------------------------------------
INSERT INTO cs_store (store_id, name, address, city) VALUES (1, 'Threadline Zürich', 'Bahnhofstrasse 21', 'Zürich');
INSERT INTO cs_store (store_id, name, address, city) VALUES (2, 'Threadline Basel', 'Freie Strasse 48', 'Basel');
INSERT INTO cs_store (store_id, name, address, city) VALUES (3, 'Threadline Bern', 'Marktgasse 12', 'Bern');

-- ---------------------------------------------------------------------
-- cs_employee (every store has >= 1 employee - not enforced by the DDL)
-- ---------------------------------------------------------------------
INSERT INTO cs_employee (employee_id, fname, lname, job_role, hire_date, store_id) VALUES (101, 'Anna',  'Meier',     'Store Manager',   DATE '2021-03-01', 1);
INSERT INTO cs_employee (employee_id, fname, lname, job_role, hire_date, store_id) VALUES (102, 'Luca',  'Rossi',     'Sales Associate', DATE '2023-08-15', 1);
INSERT INTO cs_employee (employee_id, fname, lname, job_role, hire_date, store_id) VALUES (103, 'Sara',  'Keller',    'Store Manager',   DATE '2020-05-01', 2);
INSERT INTO cs_employee (employee_id, fname, lname, job_role, hire_date, store_id) VALUES (104, 'Jonas', 'Weber',     'Sales Associate', DATE '2024-02-01', 2);
INSERT INTO cs_employee (employee_id, fname, lname, job_role, hire_date, store_id) VALUES (105, 'Mia',   'Schneider', 'Store Manager',   DATE '2022-09-01', 3);

-- ---------------------------------------------------------------------
-- cs_category (gender: WOMEN, MEN, KIDS, UNISEX)
-- ---------------------------------------------------------------------
INSERT INTO cs_category (category_id, name, gender) VALUES (10, 'Jackets & Coats', 'WOMEN');
INSERT INTO cs_category (category_id, name, gender) VALUES (11, 'Jeans',           'MEN');
INSERT INTO cs_category (category_id, name, gender) VALUES (12, 'T-Shirts',        'UNISEX');
INSERT INTO cs_category (category_id, name, gender) VALUES (13, 'Hoodies',         'KIDS');
INSERT INTO cs_category (category_id, name, gender) VALUES (14, 'Dresses',         'WOMEN');

-- ---------------------------------------------------------------------
-- cs_supplier
-- ---------------------------------------------------------------------
INSERT INTO cs_supplier (supplier_id, name, contact_person, email, country) VALUES (50, 'Textil Nord GmbH', 'Klaus Berger',   'orders@textilnord.example',  'Germany');
INSERT INTO cs_supplier (supplier_id, name, contact_person, email, country) VALUES (51, 'Lana Tessile SRL', 'Giulia Conti',   'sales@lanatessile.example',  'Italy');
INSERT INTO cs_supplier (supplier_id, name, contact_person, email, country) VALUES (52, 'EcoCotton Lda',    'Rui Almeida',    'info@ecocotton.example',     'Portugal');

-- ---------------------------------------------------------------------
-- cs_product (base_price = current list price in CHF)
-- ---------------------------------------------------------------------
INSERT INTO cs_product (product_id, name, brand, material, base_price, category_id, supplier_id) VALUES (201, 'Rain Jacket',  'Alpwerk',   'Polyester', 149.00, 10, 50);
INSERT INTO cs_product (product_id, name, brand, material, base_price, category_id, supplier_id) VALUES (202, 'Slim Jeans',   'Nordfaden', 'Denim',      89.90, 11, 50);
INSERT INTO cs_product (product_id, name, brand, material, base_price, category_id, supplier_id) VALUES (203, 'Basic Tee',    'Urbanknit', 'Cotton',     24.90, 12, 52);
INSERT INTO cs_product (product_id, name, brand, material, base_price, category_id, supplier_id) VALUES (204, 'Kids Hoodie',  'Urbanknit', 'Cotton',     39.90, 13, 52);
INSERT INTO cs_product (product_id, name, brand, material, base_price, category_id, supplier_id) VALUES (205, 'Summer Dress', 'Lana',      'Linen',     119.00, 14, 51);
INSERT INTO cs_product (product_id, name, brand, material, base_price, category_id, supplier_id) VALUES (206, 'Wool Coat',    'Lana',      'Wool',      249.00, 10, 51);
INSERT INTO cs_product (product_id, name, brand, material, base_price, category_id, supplier_id) VALUES (207, 'Graphic Tee',  'Urbanknit', 'Cotton',     29.90, 12, 52);

-- ---------------------------------------------------------------------
-- cs_product_variant (one row per size/color combination of a product)
-- ---------------------------------------------------------------------
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1001, 'RJ-201-S-NAV',   'S',   'Navy',  201);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1002, 'RJ-201-M-NAV',   'M',   'Navy',  201);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1003, 'RJ-201-L-BLK',   'L',   'Black', 201);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1004, 'SJ-202-32-BLU',  '32',  'Blue',  202);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1005, 'SJ-202-34-BLU',  '34',  'Blue',  202);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1006, 'BT-203-S-WHT',   'S',   'White', 203);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1007, 'BT-203-M-WHT',   'M',   'White', 203);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1008, 'BT-203-M-BLK',   'M',   'Black', 203);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1009, 'KH-204-128-GRY', '128', 'Grey',  204);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1010, 'KH-204-140-GRY', '140', 'Grey',  204);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1011, 'SD-205-S-RED',   'S',   'Red',   205);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1012, 'SD-205-M-RED',   'M',   'Red',   205);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1013, 'WC-206-M-CML',   'M',   'Camel', 206);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1014, 'GT-207-M-BLK',   'M',   'Black', 207);
INSERT INTO cs_product_variant (variant_id, sku, item_size, color, product_id) VALUES (1015, 'GT-207-L-BLK',   'L',   'Black', 207);

-- ---------------------------------------------------------------------
-- cs_inventory (stock per store and variant; M:N store <-> variant)
-- ---------------------------------------------------------------------
-- Store 1 Zürich
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (1, 1001,  8,  3);
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (1, 1002,  2,  3);  -- below reorder level
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (1, 1004, 10,  4);
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (1, 1006, 25, 10);
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (1, 1007,  6, 10);  -- below reorder level
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (1, 1013,  1,  2);  -- below reorder level
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (1, 1014, 12,  5);
-- Store 2 Basel
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (2, 1003,  5,  2);
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (2, 1005,  3,  4);  -- below reorder level
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (2, 1008, 15,  5);
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (2, 1009,  7,  3);
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (2, 1011,  4,  2);
-- Store 3 Bern
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (3, 1002,  6,  3);
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (3, 1010,  0,  2);  -- out of stock
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (3, 1012,  9,  3);
INSERT INTO cs_inventory (store_id, variant_id, quantity_on_hand, reorder_level) VALUES (3, 1015, 10,  5);

COMMIT;
