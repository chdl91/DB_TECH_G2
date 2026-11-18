-- =====================================================================
-- Clothing store - customer and order data (Oracle / FreeSQL)
-- Owner: Noé Brönnimann
-- Run with "Run Script" after 02_data_master.sql
-- (references store, employee and variant IDs from that file).
--
-- STARTER DATA: a small, consistent set of example rows so everyone sees
-- the pattern. Extend it with more customers and orders.
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
--   - unit_price = price at the time of sale (may differ from base_price)
--   - invoice: net_amount = sum(quantity * unit_price) + shipping_cost,
--              total_amount = net_amount * (1 + vat_rate/100), rounded to 0.01
--              due_date = invoice_date + 30 days
--
-- Data must contain (needed by the queries):
--   [x] customers who ordered BOTH online and in a store: 1, 5
--   [x] walk-in store orders (customer_id NULL): 5004, 5011
--   [x] online orders WITHOUT invoice: 5007 (cancelled), 5009 (open)
--   [x] UNPAID invoice with due_date in the past: 9003 (due 2026-11-09)
--   [x] CANCELLED order: 5007
--   [x] orders in several months: Sep, Oct, Nov 2026
--   [x] customers with clearly different total spending (2 = highest)
--   [x] customer without any order: 6
--   [x] never-sold variants 1014, 1015 are NOT ordered
-- =====================================================================

-- ---------------------------------------------------------------------
-- cs_customer
-- ---------------------------------------------------------------------
INSERT INTO cs_customer (customer_id, fname, lname, email, phone, address) VALUES (1, 'Laura', 'Fischer', 'laura.fischer@example.ch', '+41 79 111 22 33', 'Seefeldstrasse 5, 8008 Zürich');
INSERT INTO cs_customer (customer_id, fname, lname, email, phone, address) VALUES (2, 'Marco', 'Bianchi', 'marco.bianchi@example.ch', '+41 78 222 33 44', 'Via Nassa 10, 6900 Lugano');
INSERT INTO cs_customer (customer_id, fname, lname, email, phone, address) VALUES (3, 'Elena', 'Huber',   'elena.huber@example.ch',   '+41 76 333 44 55', 'Steinenvorstadt 3, 4051 Basel');
INSERT INTO cs_customer (customer_id, fname, lname, email, phone, address) VALUES (4, 'David', 'Brunner', 'david.brunner@example.ch', '+41 79 444 55 66', 'Rue du Rhône 20, 1204 Genève');
INSERT INTO cs_customer (customer_id, fname, lname, email, phone, address) VALUES (5, 'Nina',  'Graf',    'nina.graf@example.ch',     NULL,               'Kramgasse 7, 3011 Bern');
INSERT INTO cs_customer (customer_id, fname, lname, email, phone, address) VALUES (6, 'Tim',   'Moser',   'tim.moser@example.ch',     '+41 77 666 77 88', NULL);

-- ---------------------------------------------------------------------
-- Orders. Each order = 1 row in cs_orders + 1 row in the matching
-- subtype table + >= 1 row in cs_order_item.
-- ---------------------------------------------------------------------

-- 5001 · online · Laura · delivered, invoiced and paid
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5001, DATE '2026-09-05', 'DELIVERED', 'ONLINE');
INSERT INTO cs_online_order (order_id, customer_id, shipping_address, shipping_cost, tracking_number) VALUES (5001, 1, 'Seefeldstrasse 5, 8008 Zürich', 7.90, 'CH-TRK-5001');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5001, 1001, 1, 149.00);
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5001, 1006, 2,  24.90);

-- 5002 · store Zürich · Laura (registered customer) · card
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5002, DATE '2026-09-12', 'PAID', 'STORE');
INSERT INTO cs_store_order (order_id, customer_id, store_id, employee_id, payment_method) VALUES (5002, 1, 1, 101, 'CARD');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5002, 1004, 1, 89.90);

-- 5003 · online · Marco · free shipping
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5003, DATE '2026-09-20', 'DELIVERED', 'ONLINE');
INSERT INTO cs_online_order (order_id, customer_id, shipping_address, shipping_cost, tracking_number) VALUES (5003, 2, 'Via Nassa 10, 6900 Lugano', 0, 'CH-TRK-5003');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5003, 1013, 1, 249.00);
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5003, 1011, 1, 119.00);

-- 5004 · store Basel · walk-in customer (customer_id NULL) · cash
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5004, DATE '2026-09-28', 'PAID', 'STORE');
INSERT INTO cs_store_order (order_id, customer_id, store_id, employee_id, payment_method) VALUES (5004, NULL, 2, 104, 'CASH');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5004, 1008, 3, 24.90);

-- 5005 · store Basel · Elena · TWINT
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5005, DATE '2026-10-03', 'PAID', 'STORE');
INSERT INTO cs_store_order (order_id, customer_id, store_id, employee_id, payment_method) VALUES (5005, 3, 2, 103, 'TWINT');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5005, 1005, 1, 89.90);
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5005, 1009, 1, 39.90);

-- 5006 · online · David · shipped, invoice UNPAID and past due
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5006, DATE '2026-10-10', 'SHIPPED', 'ONLINE');
INSERT INTO cs_online_order (order_id, customer_id, shipping_address, shipping_cost, tracking_number) VALUES (5006, 4, 'Rue du Rhône 20, 1204 Genève', 7.90, 'CH-TRK-5006');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5006, 1002, 1, 149.00);

-- 5007 · online · Marco · CANCELLED, no invoice, no tracking number
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5007, DATE '2026-10-15', 'CANCELLED', 'ONLINE');
INSERT INTO cs_online_order (order_id, customer_id, shipping_address, shipping_cost, tracking_number) VALUES (5007, 2, 'Via Nassa 10, 6900 Lugano', 7.90, NULL);
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5007, 1003, 1, 149.00);

-- 5008 · store Bern · Nina · card
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5008, DATE '2026-10-22', 'PAID', 'STORE');
INSERT INTO cs_store_order (order_id, customer_id, store_id, employee_id, payment_method) VALUES (5008, 5, 3, 105, 'CARD');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5008, 1012, 1, 119.00);
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5008, 1010, 1,  39.90);

-- 5009 · online · Nina · OPEN, not yet invoiced
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5009, DATE '2026-11-02', 'OPEN', 'ONLINE');
INSERT INTO cs_online_order (order_id, customer_id, shipping_address, shipping_cost, tracking_number) VALUES (5009, 5, 'Kramgasse 7, 3011 Bern', 7.90, NULL);
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5009, 1007, 2, 24.90);

-- 5010 · online · Marco · sale price (unit_price 79.90 < base_price 89.90)
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5010, DATE '2026-11-05', 'DELIVERED', 'ONLINE');
INSERT INTO cs_online_order (order_id, customer_id, shipping_address, shipping_cost, tracking_number) VALUES (5010, 2, 'Via Nassa 10, 6900 Lugano', 7.90, 'CH-TRK-5010');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5010, 1004, 2, 79.90);

-- 5011 · store Zürich · walk-in customer · voucher
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5011, DATE '2026-11-08', 'PAID', 'STORE');
INSERT INTO cs_store_order (order_id, customer_id, store_id, employee_id, payment_method) VALUES (5011, NULL, 1, 102, 'VOUCHER');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5011, 1006, 1, 24.90);

-- 5012 · online · Laura · shipped, invoice UNPAID but not yet due
INSERT INTO cs_orders (order_id, order_date, status, order_type) VALUES (5012, DATE '2026-11-12', 'SHIPPED', 'ONLINE');
INSERT INTO cs_online_order (order_id, customer_id, shipping_address, shipping_cost, tracking_number) VALUES (5012, 1, 'Seefeldstrasse 5, 8008 Zürich', 7.90, 'CH-TRK-5012');
INSERT INTO cs_order_item (order_id, variant_id, quantity, unit_price) VALUES (5012, 1009, 1, 39.90);

-- ---------------------------------------------------------------------
-- cs_invoice (only online orders, max. 1 per order; VAT 8.1 %)
-- ---------------------------------------------------------------------
INSERT INTO cs_invoice (invoice_id, invoice_number, invoice_date, due_date, net_amount, vat_rate, total_amount, payment_status, order_id)
  VALUES (9001, 'INV-2026-0001', DATE '2026-09-05', DATE '2026-10-05', 206.70, 8.10, 223.44, 'PAID',   5001);
INSERT INTO cs_invoice (invoice_id, invoice_number, invoice_date, due_date, net_amount, vat_rate, total_amount, payment_status, order_id)
  VALUES (9002, 'INV-2026-0002', DATE '2026-09-20', DATE '2026-10-20', 368.00, 8.10, 397.81, 'PAID',   5003);
INSERT INTO cs_invoice (invoice_id, invoice_number, invoice_date, due_date, net_amount, vat_rate, total_amount, payment_status, order_id)
  VALUES (9003, 'INV-2026-0003', DATE '2026-10-10', DATE '2026-11-09', 156.90, 8.10, 169.61, 'UNPAID', 5006);
INSERT INTO cs_invoice (invoice_id, invoice_number, invoice_date, due_date, net_amount, vat_rate, total_amount, payment_status, order_id)
  VALUES (9004, 'INV-2026-0004', DATE '2026-11-05', DATE '2026-12-05', 167.70, 8.10, 181.28, 'PAID',   5010);
INSERT INTO cs_invoice (invoice_id, invoice_number, invoice_date, due_date, net_amount, vat_rate, total_amount, payment_status, order_id)
  VALUES (9005, 'INV-2026-0005', DATE '2026-11-12', DATE '2026-12-12', 47.80, 8.10, 51.67, 'UNPAID', 5012);

COMMIT;
