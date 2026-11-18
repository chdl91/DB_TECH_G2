-- =====================================================================
-- Clothing store - drop all tables (Oracle / FreeSQL)
-- Run with "Run Script" before rebuilding the schema.
-- Order: child tables first. CASCADE CONSTRAINTS also removes FKs.
-- On a fresh schema each line returns ORA-00942 (table does not exist);
-- that is expected and harmless.
-- Owner: Tobias Seiler
-- =====================================================================

DROP TABLE invoice         CASCADE CONSTRAINTS;
DROP TABLE order_item      CASCADE CONSTRAINTS;
DROP TABLE store_order     CASCADE CONSTRAINTS;
DROP TABLE online_order    CASCADE CONSTRAINTS;
DROP TABLE orders          CASCADE CONSTRAINTS;
DROP TABLE inventory       CASCADE CONSTRAINTS;
DROP TABLE product_variant CASCADE CONSTRAINTS;
DROP TABLE product         CASCADE CONSTRAINTS;
DROP TABLE supplier        CASCADE CONSTRAINTS;
DROP TABLE category        CASCADE CONSTRAINTS;
DROP TABLE employee        CASCADE CONSTRAINTS;
DROP TABLE store           CASCADE CONSTRAINTS;
DROP TABLE customer        CASCADE CONSTRAINTS;
