-- =====================================================================
-- Clothing store - drop all tables (Oracle / FreeSQL)
-- Run with "Run Script" before rebuilding the schema.
-- Order: child tables first. CASCADE CONSTRAINTS also removes FKs.
-- Drops ONLY the project tables (prefix cs_). The class tables
-- (CUSTOMER, PRODUCT, INVOICE, VENDOR, LINE, PRACTICE_*) are not touched.
-- On a fresh schema each line returns ORA-00942 (table does not exist);
-- that is expected and harmless.
-- Owner: Tobias Seiler
-- =====================================================================

DROP TABLE cs_invoice         CASCADE CONSTRAINTS;
DROP TABLE cs_order_item      CASCADE CONSTRAINTS;
DROP TABLE cs_store_order     CASCADE CONSTRAINTS;
DROP TABLE cs_online_order    CASCADE CONSTRAINTS;
DROP TABLE cs_orders          CASCADE CONSTRAINTS;
DROP TABLE cs_inventory       CASCADE CONSTRAINTS;
DROP TABLE cs_product_variant CASCADE CONSTRAINTS;
DROP TABLE cs_product         CASCADE CONSTRAINTS;
DROP TABLE cs_supplier        CASCADE CONSTRAINTS;
DROP TABLE cs_category        CASCADE CONSTRAINTS;
DROP TABLE cs_employee        CASCADE CONSTRAINTS;
DROP TABLE cs_store           CASCADE CONSTRAINTS;
DROP TABLE cs_customer        CASCADE CONSTRAINTS;
