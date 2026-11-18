# Normalisation check

> DRAFT – owner: Christian Lehmann. Check every table against 1NF, 2NF, 3NF and justify deliberate exceptions.

## Per table

| Table | 1NF | 2NF | 3NF | Notes |
|---|---|---|---|---|
| cs_customer | | | | `address` stored as one field (no analyses by city needed?) |
| cs_store | | | | |
| cs_employee | | | | |
| cs_category | | | | |
| cs_supplier | | | | |
| cs_product | | | | |
| cs_product_variant | | | | |
| cs_inventory | | | | composite PK (store_id, variant_id) – check partial dependencies |
| cs_orders | | | | |
| cs_online_order | | | | |
| cs_store_order | | | | |
| cs_order_item | | | | composite PK (order_id, variant_id); `unit_price` depends on the full key |
| cs_invoice | | | | see open points |

## Open points – decide and justify

1. **`cs_invoice.net_amount` / `cs_invoice.total_amount`** can be derived from `cs_order_item` and `vat_rate`.
   Options: remove them, or keep them deliberately (an invoice is a legal document; its amounts must not change once issued).
2. **`cs_orders.order_type`** duplicates the information given by the subtype tables. It is a discriminator for the supertype/subtype mapping; justify in one sentence.
3. **`cs_order_item.unit_price`** vs. `cs_product.base_price`: not redundant, it records the price at the time of sale.
