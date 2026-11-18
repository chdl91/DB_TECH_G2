# Normalisation check

> DRAFT – owner: Christian Lehmann. Check every table against 1NF, 2NF, 3NF and justify deliberate exceptions.

## Per table

| Table | 1NF | 2NF | 3NF | Notes |
|---|---|---|---|---|
| customer | | | | `address` stored as one field (no analyses by city needed?) |
| store | | | | |
| employee | | | | |
| category | | | | |
| supplier | | | | |
| product | | | | |
| product_variant | | | | |
| inventory | | | | composite PK (store_id, variant_id) – check partial dependencies |
| orders | | | | |
| online_order | | | | |
| store_order | | | | |
| order_item | | | | composite PK (order_id, variant_id); `unit_price` depends on the full key |
| invoice | | | | see open points |

## Open points – decide and justify

1. **`invoice.net_amount` / `invoice.total_amount`** can be derived from `order_item` and `vat_rate`.
   Options: remove them, or keep them deliberately (an invoice is a legal document; its amounts must not change once issued).
2. **`orders.order_type`** duplicates the information given by the subtype tables. It is a discriminator for the supertype/subtype mapping; justify in one sentence.
3. **`order_item.unit_price`** vs. `product.base_price`: not redundant, it records the price at the time of sale.
