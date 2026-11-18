-- =====================================================================
-- Clothing store - master data (Oracle / FreeSQL)
-- Owner: Peter Zweifel
-- Run after 01_ddl.sql, before 03_data_orders.sql.
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
--   [ ] at least 3 stores, each with >= 1 employee
--   [ ] categories for several genders (WOMEN, MEN, KIDS, UNISEX)
--   [ ] several products per category with different base_price
--   [ ] products with several variants (size/color)
--   [ ] at least 1 variant that will NEVER be ordered (tell Noé the ID)
--   [ ] inventory rows where quantity_on_hand <= reorder_level
-- =====================================================================

-- store
-- INSERT INTO store (store_id, name, address, city) VALUES (1, '...', '...', '...');

-- employee
-- INSERT INTO employee (employee_id, fname, lname, job_role, hire_date, store_id)
--   VALUES (101, '...', '...', '...', DATE '2024-03-01', 1);

-- category
-- INSERT INTO category (category_id, name, gender) VALUES (10, '...', 'WOMEN');

-- supplier
-- INSERT INTO supplier (supplier_id, name, contact_person, email, country) VALUES (50, '...', '...', '...', '...');

-- product
-- INSERT INTO product (product_id, name, brand, material, base_price, category_id, supplier_id)
--   VALUES (201, '...', '...', '...', 49.90, 10, 50);

-- product_variant
-- INSERT INTO product_variant (variant_id, sku, item_size, color, product_id)
--   VALUES (1001, '...', 'M', '...', 201);

-- inventory
-- INSERT INTO inventory (store_id, variant_id, quantity_on_hand, reorder_level)
--   VALUES (1, 1001, 12, 5);

COMMIT;
