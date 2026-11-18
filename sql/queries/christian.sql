-- =====================================================================
-- Queries - Christian Lehmann
-- Run each query with "Run" in FreeSQL; save the result in results/
-- (screenshot or CSV, named e.g. christian_q1.png).
-- =====================================================================

-- ---------------------------------------------------------------------
-- Q1 · Author: Christian Lehmann
-- Question: Which customers have bought both online and in a store?
-- Technique: Set operation (INTERSECT on cs_online_order / cs_store_order), join to cs_customer
-- Result / explanation: (fill in after running)
-- ---------------------------------------------------------------------
-- SELECT ...


-- ---------------------------------------------------------------------
-- Q2 · Author: Christian Lehmann
-- Question: What is the revenue per sales channel (ONLINE / STORE) and month, excluding cancelled orders?
-- Technique: JOIN cs_orders - cs_order_item, filtering, GROUP BY order_type and month, SUM
-- Result / explanation: (fill in after running)
-- ---------------------------------------------------------------------
-- SELECT ...
