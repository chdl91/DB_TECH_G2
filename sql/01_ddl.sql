-- =====================================================================
-- Clothing store - relational schema (Oracle)
-- Import in SQL Developer Data Modeler: File > Import > DDL File
-- Inheritance Order -> OnlineOrder / StoreOrder mapped as one table
-- per class (CS_ORDERS + CS_ONLINE_ORDER + CS_STORE_ORDER, shared primary key).
-- All tables use the prefix cs_ so they can coexist with the class
-- tables (SaleCo: CUSTOMER, PRODUCT, INVOICE, ...) in the same schema.
-- =====================================================================

CREATE TABLE cs_customer (
    customer_id     NUMBER(10)      NOT NULL,
    fname           VARCHAR2(50)    NOT NULL,
    lname           VARCHAR2(50)    NOT NULL,
    email           VARCHAR2(100)   NOT NULL,
    phone           VARCHAR2(30),
    address         VARCHAR2(200),
    CONSTRAINT cs_customer_pk PRIMARY KEY (customer_id),
    CONSTRAINT cs_customer_email_uq UNIQUE (email)
);

CREATE TABLE cs_store (
    store_id        NUMBER(10)      NOT NULL,
    name            VARCHAR2(100)   NOT NULL,
    address         VARCHAR2(200)   NOT NULL,
    city            VARCHAR2(100)   NOT NULL,
    CONSTRAINT cs_store_pk PRIMARY KEY (store_id)
);

CREATE TABLE cs_employee (
    employee_id     NUMBER(10)      NOT NULL,
    fname           VARCHAR2(50)    NOT NULL,
    lname           VARCHAR2(50)    NOT NULL,
    job_role        VARCHAR2(50)    NOT NULL,
    hire_date       DATE            NOT NULL,
    store_id        NUMBER(10)      NOT NULL,
    CONSTRAINT cs_employee_pk PRIMARY KEY (employee_id)
);

CREATE TABLE cs_category (
    category_id     NUMBER(10)      NOT NULL,
    name            VARCHAR2(100)   NOT NULL,
    gender          VARCHAR2(10),
    CONSTRAINT cs_category_pk PRIMARY KEY (category_id),
    CONSTRAINT cs_category_gender_ck CHECK (gender IN ('WOMEN', 'MEN', 'KIDS', 'UNISEX'))
);

CREATE TABLE cs_supplier (
    supplier_id     NUMBER(10)      NOT NULL,
    name            VARCHAR2(100)   NOT NULL,
    contact_person  VARCHAR2(100),
    email           VARCHAR2(100),
    country         VARCHAR2(50),
    CONSTRAINT cs_supplier_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE cs_product (
    product_id      NUMBER(10)      NOT NULL,
    name            VARCHAR2(100)   NOT NULL,
    brand           VARCHAR2(100),
    material        VARCHAR2(100),
    base_price      NUMBER(10,2)    NOT NULL,
    category_id     NUMBER(10)      NOT NULL,
    supplier_id     NUMBER(10)      NOT NULL,
    CONSTRAINT cs_product_pk PRIMARY KEY (product_id),
    CONSTRAINT cs_product_price_ck CHECK (base_price >= 0)
);

CREATE TABLE cs_product_variant (
    variant_id      NUMBER(10)      NOT NULL,
    sku             VARCHAR2(30)    NOT NULL,
    item_size       VARCHAR2(10)    NOT NULL,
    color           VARCHAR2(30)    NOT NULL,
    product_id      NUMBER(10)      NOT NULL,
    CONSTRAINT cs_product_variant_pk PRIMARY KEY (variant_id),
    CONSTRAINT cs_product_variant_sku_uq UNIQUE (sku),
    CONSTRAINT cs_product_variant_combo_uq UNIQUE (product_id, item_size, color)
);

CREATE TABLE cs_inventory (
    store_id         NUMBER(10)     NOT NULL,
    variant_id       NUMBER(10)     NOT NULL,
    quantity_on_hand NUMBER(6)      DEFAULT 0 NOT NULL,
    reorder_level    NUMBER(6)      DEFAULT 0 NOT NULL,
    CONSTRAINT cs_inventory_pk PRIMARY KEY (store_id, variant_id),
    CONSTRAINT cs_inventory_qty_ck CHECK (quantity_on_hand >= 0 AND reorder_level >= 0)
);

-- Superclass Order (ORDER is a reserved word -> CS_ORDERS)
CREATE TABLE cs_orders (
    order_id        NUMBER(10)      NOT NULL,
    order_date      DATE            NOT NULL,
    status          VARCHAR2(20)    NOT NULL,
    order_type      VARCHAR2(10)    NOT NULL,
    CONSTRAINT cs_orders_pk PRIMARY KEY (order_id),
    CONSTRAINT cs_orders_type_ck CHECK (order_type IN ('ONLINE', 'STORE')),
    CONSTRAINT cs_orders_status_ck CHECK (status IN ('OPEN', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'RETURNED'))
);

-- Subclass OnlineOrder (customer mandatory)
CREATE TABLE cs_online_order (
    order_id         NUMBER(10)     NOT NULL,
    customer_id      NUMBER(10)     NOT NULL,
    shipping_address VARCHAR2(200)  NOT NULL,
    shipping_cost    NUMBER(8,2)    DEFAULT 0 NOT NULL,
    tracking_number  VARCHAR2(50),
    CONSTRAINT cs_online_order_pk PRIMARY KEY (order_id)
);

-- Subclass StoreOrder (customer optional = walk-in)
CREATE TABLE cs_store_order (
    order_id        NUMBER(10)      NOT NULL,
    customer_id     NUMBER(10),
    store_id        NUMBER(10)      NOT NULL,
    employee_id     NUMBER(10)      NOT NULL,
    payment_method  VARCHAR2(20)    NOT NULL,
    CONSTRAINT cs_store_order_pk PRIMARY KEY (order_id),
    CONSTRAINT cs_store_order_pay_ck CHECK (payment_method IN ('CASH', 'CARD', 'TWINT', 'VOUCHER'))
);

CREATE TABLE cs_order_item (
    order_id        NUMBER(10)      NOT NULL,
    variant_id      NUMBER(10)      NOT NULL,
    quantity        NUMBER(4)       NOT NULL,
    unit_price      NUMBER(10,2)    NOT NULL,
    CONSTRAINT cs_order_item_pk PRIMARY KEY (order_id, variant_id),
    CONSTRAINT cs_order_item_qty_ck CHECK (quantity > 0),
    CONSTRAINT cs_order_item_price_ck CHECK (unit_price >= 0)
);

-- Invoice only for online orders; UNIQUE(order_id) = 0..1 invoice per order
CREATE TABLE cs_invoice (
    invoice_id      NUMBER(10)      NOT NULL,
    invoice_number  VARCHAR2(20)    NOT NULL,
    invoice_date    DATE            NOT NULL,
    due_date        DATE            NOT NULL,
    net_amount      NUMBER(10,2)    NOT NULL,
    vat_rate        NUMBER(4,2)     NOT NULL,
    total_amount    NUMBER(10,2)    NOT NULL,
    payment_status  VARCHAR2(20)    DEFAULT 'UNPAID' NOT NULL,
    order_id        NUMBER(10)      NOT NULL,
    CONSTRAINT cs_invoice_pk PRIMARY KEY (invoice_id),
    CONSTRAINT cs_invoice_number_uq UNIQUE (invoice_number),
    CONSTRAINT cs_invoice_order_uq UNIQUE (order_id),
    CONSTRAINT cs_invoice_dates_ck CHECK (due_date >= invoice_date),
    CONSTRAINT cs_invoice_status_ck CHECK (payment_status IN ('UNPAID', 'PAID', 'OVERDUE', 'CANCELLED'))
);

-- =====================================================================
-- Foreign keys
-- =====================================================================

ALTER TABLE cs_employee
    ADD CONSTRAINT cs_employee_store_fk FOREIGN KEY (store_id) REFERENCES cs_store (store_id);

ALTER TABLE cs_product
    ADD CONSTRAINT cs_product_category_fk FOREIGN KEY (category_id) REFERENCES cs_category (category_id);

ALTER TABLE cs_product
    ADD CONSTRAINT cs_product_supplier_fk FOREIGN KEY (supplier_id) REFERENCES cs_supplier (supplier_id);

ALTER TABLE cs_product_variant
    ADD CONSTRAINT cs_product_variant_product_fk FOREIGN KEY (product_id) REFERENCES cs_product (product_id) ON DELETE CASCADE;

ALTER TABLE cs_inventory
    ADD CONSTRAINT cs_inventory_store_fk FOREIGN KEY (store_id) REFERENCES cs_store (store_id);

ALTER TABLE cs_inventory
    ADD CONSTRAINT cs_inventory_variant_fk FOREIGN KEY (variant_id) REFERENCES cs_product_variant (variant_id);

ALTER TABLE cs_online_order
    ADD CONSTRAINT cs_online_order_orders_fk FOREIGN KEY (order_id) REFERENCES cs_orders (order_id) ON DELETE CASCADE;

ALTER TABLE cs_online_order
    ADD CONSTRAINT cs_online_order_customer_fk FOREIGN KEY (customer_id) REFERENCES cs_customer (customer_id);

ALTER TABLE cs_store_order
    ADD CONSTRAINT cs_store_order_orders_fk FOREIGN KEY (order_id) REFERENCES cs_orders (order_id) ON DELETE CASCADE;

ALTER TABLE cs_store_order
    ADD CONSTRAINT cs_store_order_customer_fk FOREIGN KEY (customer_id) REFERENCES cs_customer (customer_id);

ALTER TABLE cs_store_order
    ADD CONSTRAINT cs_store_order_store_fk FOREIGN KEY (store_id) REFERENCES cs_store (store_id);

ALTER TABLE cs_store_order
    ADD CONSTRAINT cs_store_order_employee_fk FOREIGN KEY (employee_id) REFERENCES cs_employee (employee_id);

ALTER TABLE cs_order_item
    ADD CONSTRAINT cs_order_item_orders_fk FOREIGN KEY (order_id) REFERENCES cs_orders (order_id) ON DELETE CASCADE;

ALTER TABLE cs_order_item
    ADD CONSTRAINT cs_order_item_variant_fk FOREIGN KEY (variant_id) REFERENCES cs_product_variant (variant_id);

ALTER TABLE cs_invoice
    ADD CONSTRAINT cs_invoice_online_order_fk FOREIGN KEY (order_id) REFERENCES cs_online_order (order_id);
