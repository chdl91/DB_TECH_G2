# DB_TECH_G2 – Clothing Store Database

Database Technology HS26 – group project.

**Group members:** Christian Lehmann, Peter Zweifel, Noé Brönnimann, Tobias Seiler

**Database system:** Oracle Database via FreeSQL (https://freesql.com)

**Deadlines:** submission Wed 25 Nov 2026 (end of day) · presentation Mon 30 Nov 2026 (onsite, all members)

---

## How to recreate the database

1. Sign in to FreeSQL and open the Worksheet.
2. Run each file below with **Run Script** (not "Run"), in this order, and check *Script Output* for errors:

| Step | File | Content |
|---|---|---|
| 0 | `sql/00_drop.sql` | Drops all tables (only needed when rebuilding; errors on the first run are expected) |
| 1 | `sql/01_ddl.sql` | Creates the 13 tables, constraints and foreign keys |
| 2 | `sql/02_data_master.sql` | Stores, employees, categories, suppliers, products, variants, inventory |
| 3 | `sql/03_data_orders.sql` | Customers, orders, online/store orders, order items, invoices |
| 4 | `sql/queries/*.sql` | The project queries, one file per group member |

3. Check: `SELECT table_name FROM user_tables WHERE table_name LIKE 'CS\_%' ESCAPE '\' ORDER BY table_name;` returns 13 tables.

## Repository structure

```
sql/00_drop.sql            Tobias
sql/01_ddl.sql             Christian (changes only via pull request)
sql/02_data_master.sql     Peter
sql/03_data_orders.sql     Noé
sql/queries/<name>.sql     each member, 2+ queries
docs/                      project description, ERD, relational schema, normalisation
results/                   query results from FreeSQL (screenshot or CSV per query)
```

## Working rules

- **All project tables use the prefix `cs_`** (e.g. `cs_customer`, `cs_orders`). Our FreeSQL schema also holds the class tables (SaleCo: `CUSTOMER`, `PRODUCT`, `INVOICE`, `VENDOR`, `LINE`, `PRACTICE_*`), and three of them would otherwise clash with ours. Never drop or change tables without the `cs_` prefix. `00_drop.sql` only drops `cs_` tables.
- **The scripts are the single source of truth.** Never change tables directly in FreeSQL without updating the script.
- **Edit only your own files.** That avoids merge conflicts.
- **Changes to `01_ddl.sql` go through a pull request reviewed by Christian**, because the ERD and relational schema must be updated as well (ERD, schema, tables and queries must describe the same design).
- After pulling a DDL or data change: run `00_drop` → `01_ddl` → `02` → `03` again in your own schema.
- Dates in INSERTs: always use `DATE 'YYYY-MM-DD'` literals.

## Work split

| Member | Main part | Queries |
|---|---|---|
| Christian Lehmann | Logical ERD, relational schema, normalisation, Moodle topic entry, schema owner | INTERSECT (both channels); revenue per channel and month |
| Peter Zweifel | Master data (`02_data_master.sql`) | Stock at/below reorder level; products never sold |
| Noé Brönnimann | Order data (`03_data_orders.sql`) | Overdue unpaid invoices; customers above average spending |
| Tobias Seiler | Drop script, rebuild test, results, README, submission | Top 3 products; most expensive product per category |

## Schedule

| Date | Task | Who |
|---|---|---|
| Wed 18 Nov | DDL runs in FreeSQL; query questions confirmed | Christian, all |
| Thu 19 Nov | ERD + schema final, DDL frozen, Moodle entry; ID ranges agreed | Christian, Peter, Noé |
| Thu 19 – Sat 21 Nov | Master data → order data; drop script, README | Peter → Noé, Tobias |
| Sun 22 – Mon 23 Nov | Write and run queries | All |
| Tue 24 Nov | Full rebuild from scratch, all queries, consistency check | Tobias, Christian |
| Wed 25 Nov | Buffer, submission on Moodle | Tobias |
| 26 – 29 Nov | Slides, rehearsal | All |
