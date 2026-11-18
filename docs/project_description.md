# Project description – Clothing Store Database

> DRAFT – owner: Christian Lehmann. Review, adjust, then enter the topic on Moodle.

## Scenario

A clothing retailer sells through several physical stores and an online shop. The database supports sales in both channels, stock management per store, the product range with sizes and colours, suppliers, and invoicing of online orders.

## Purpose

- Record online and in-store orders with their items and prices at the time of sale
- Track stock per product variant and store, including reorder levels
- Manage the product range (categories, products, variants) and suppliers
- Issue and track invoices for online orders
- Support analyses such as revenue per channel, best-selling products and overdue invoices

## Business rules

**Stores and employees**
- A store employs at least one employee; each employee works in exactly one store.

**Products**
- Each product belongs to exactly one category and is supplied by exactly one supplier. A category or supplier can have many products, or none yet.
- A product exists in one or more variants (size and colour). A variant belongs to exactly one product; each size/colour combination exists only once per product. Each variant has a unique SKU.
- Deleting a product deletes its variants (composition).

**Inventory**
- A store can hold stock of many variants, and a variant can be stocked in many stores (M:N, resolved by CS_INVENTORY with quantity on hand and reorder level).

**Orders**
- An order is either an online order or a store order (complete, disjoint specialisation).
- An online order is always placed by a registered customer; a customer can place zero or more online orders.
- A store order is processed in exactly one store by exactly one employee. The customer is optional (walk-in customers are not registered).
- An order contains one or more order items; a variant can appear in many orders (M:N, resolved by CS_ORDER_ITEM). The unit price is stored per item because prices can change after the sale.

**Invoices**
- Only online orders are invoiced. An online order has at most one invoice; each invoice belongs to exactly one online order.

## Rules not enforced by constraints (notes for the ERD)

- A store must have at least one employee.
- An order must have at least one order item.
- `cs_orders.order_type` must match the subtype table (ONLINE ↔ CS_ONLINE_ORDER, STORE ↔ CS_STORE_ORDER).
- Store orders do not use the statuses SHIPPED / DELIVERED.

These would require triggers and are kept consistent through the data loading scripts.
