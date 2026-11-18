-- =====================================================================
-- Clothing store - customer and order data (Oracle / FreeSQL)
-- Owner: Noé Brönnimann
-- Run after 02_data_master.sql (references store, employee, variant IDs).
--
-- ID ranges:
--   customer_id   1 - 999
--   order_id      5001 - 5999   (same ID in cs_orders AND cs_online_order/cs_store_order)
--   invoice_id    9001 - 9999
--
-- Insert order: cs_customer -> cs_orders -> cs_online_order / cs_store_order
--               -> cs_order_item -> cs_invoice
--
-- Rules not enforced by constraints (keep the data consistent manually):
--   - cs_orders.order_type = 'ONLINE' only with a row in cs_online_order,
--     'STORE' only with a row in cs_store_order
--   - every order has >= 1 row in cs_order_item
--   - invoices only for online orders (FK enforces this)
--   - store orders: no SHIPPED / DELIVERED status
--
-- Data must contain (needed by the queries):
--   [ ] >= 1 customer who ordered BOTH online and in a store
--   [ ] >= 1 walk-in store order (customer_id NULL)
--   [ ] >= 1 online order WITHOUT invoice (0..1 relationship)
--   [ ] >= 1 UNPAID invoice with due_date in the past
--   [ ] >= 1 CANCELLED order
--   [ ] orders in at least 2 different months
--   [ ] customers with clearly different total spending
--   [ ] do NOT order the "never sold" variant(s) from Peter
-- =====================================================================

-- cs_customer
-- INSERT INTO cs_customer (customer_id, fname, lname, email, phone, address)
--   VALUES (1, '...', '...', '...@example.ch', '...', '...');

-- cs_orders (superclass)
-- INSERT INTO cs_orders (order_id, order_date, status, order_type)
--   VALUES (5001, DATE '2026-09-14', 'DELIVERED', 'ONLINE');

-- cs_online_order
-- INSERT INTO cs_online_order (order_id, customer_id, shipping_address, shipping_cost, tracking_number)
--   VALUES (5001, 1, '...', 7.90, '...');

-- cs_store_order
-- INSERT INTO cs_store_order (order_id, customer_id, store_id, employee_id, payment_method)
--   VALUES (5002, NULL, 1, 101, 'CARD');

-- cs_order_item
-- INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price)
--   VALUES (5001, 1001, 2, 49.90);

-- cs_invoice
-- INSERT INTO cs_invoice (invoice_id, invoice_number, invoice_date, due_date, net_amount,
--                      vat_rate, total_amount, payment_status, order_id)
--   VALUES (9001, 'INV-2026-0001', DATE '2026-09-14', DATE '2026-10-14', 99.80, 8.10, 107.88, 'PAID', 5001);

COMMIT;
