-- =====================================================================
-- Clothing store - relational schema (Oracle)
-- Import in SQL Developer Data Modeler: File > Import > DDL File
-- Inheritance Order -> OnlineOrder / StoreOrder mapped as one table
-- per class (ORDERS + ONLINE_ORDER + STORE_ORDER, shared primary key).
-- =====================================================================

CREATE TABLE customer (
    customer_id     NUMBER(10)      NOT NULL,
    fname           VARCHAR2(50)    NOT NULL,
    lname           VARCHAR2(50)    NOT NULL,
    email           VARCHAR2(100)   NOT NULL,
    phone           VARCHAR2(30),
    address         VARCHAR2(200),
    CONSTRAINT customer_pk PRIMARY KEY (customer_id),
    CONSTRAINT customer_email_uq UNIQUE (email)
);

CREATE TABLE store (
    store_id        NUMBER(10)      NOT NULL,
    name            VARCHAR2(100)   NOT NULL,
    address         VARCHAR2(200)   NOT NULL,
    city            VARCHAR2(100)   NOT NULL,
    CONSTRAINT store_pk PRIMARY KEY (store_id)
);

CREATE TABLE employee (
    employee_id     NUMBER(10)      NOT NULL,
    fname           VARCHAR2(50)    NOT NULL,
    lname           VARCHAR2(50)    NOT NULL,
    job_role        VARCHAR2(50)    NOT NULL,
    hire_date       DATE            NOT NULL,
    store_id        NUMBER(10)      NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY (employee_id)
);

CREATE TABLE category (
    category_id     NUMBER(10)      NOT NULL,
    name            VARCHAR2(100)   NOT NULL,
    gender          VARCHAR2(10),
    CONSTRAINT category_pk PRIMARY KEY (category_id),
    CONSTRAINT category_gender_ck CHECK (gender IN ('WOMEN', 'MEN', 'KIDS', 'UNISEX'))
);

CREATE TABLE supplier (
    supplier_id     NUMBER(10)      NOT NULL,
    name            VARCHAR2(100)   NOT NULL,
    contact_person  VARCHAR2(100),
    email           VARCHAR2(100),
    country         VARCHAR2(50),
    CONSTRAINT supplier_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE product (
    product_id      NUMBER(10)      NOT NULL,
    name            VARCHAR2(100)   NOT NULL,
    brand           VARCHAR2(100),
    material        VARCHAR2(100),
    base_price      NUMBER(10,2)    NOT NULL,
    category_id     NUMBER(10)      NOT NULL,
    supplier_id     NUMBER(10)      NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY (product_id),
    CONSTRAINT product_price_ck CHECK (base_price >= 0)
);

CREATE TABLE product_variant (
    variant_id      NUMBER(10)      NOT NULL,
    sku             VARCHAR2(30)    NOT NULL,
    item_size       VARCHAR2(10)    NOT NULL,
    color           VARCHAR2(30)    NOT NULL,
    product_id      NUMBER(10)      NOT NULL,
    CONSTRAINT product_variant_pk PRIMARY KEY (variant_id),
    CONSTRAINT product_variant_sku_uq UNIQUE (sku),
    CONSTRAINT product_variant_combo_uq UNIQUE (product_id, item_size, color)
);

CREATE TABLE inventory (
    store_id         NUMBER(10)     NOT NULL,
    variant_id       NUMBER(10)     NOT NULL,
    quantity_on_hand NUMBER(6)      DEFAULT 0 NOT NULL,
    reorder_level    NUMBER(6)      DEFAULT 0 NOT NULL,
    CONSTRAINT inventory_pk PRIMARY KEY (store_id, variant_id),
    CONSTRAINT inventory_qty_ck CHECK (quantity_on_hand >= 0 AND reorder_level >= 0)
);

-- Superclass Order (ORDER is a reserved word -> ORDERS)
CREATE TABLE orders (
    order_id        NUMBER(10)      NOT NULL,
    order_date      DATE            NOT NULL,
    status          VARCHAR2(20)    NOT NULL,
    order_type      VARCHAR2(10)    NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY (order_id),
    CONSTRAINT orders_type_ck CHECK (order_type IN ('ONLINE', 'STORE')),
    CONSTRAINT orders_status_ck CHECK (status IN ('OPEN', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'RETURNED'))
);

-- Subclass OnlineOrder (customer mandatory)
CREATE TABLE online_order (
    order_id         NUMBER(10)     NOT NULL,
    customer_id      NUMBER(10)     NOT NULL,
    shipping_address VARCHAR2(200)  NOT NULL,
    shipping_cost    NUMBER(8,2)    DEFAULT 0 NOT NULL,
    tracking_number  VARCHAR2(50),
    CONSTRAINT online_order_pk PRIMARY KEY (order_id)
);

-- Subclass StoreOrder (customer optional = walk-in)
CREATE TABLE store_order (
    order_id        NUMBER(10)      NOT NULL,
    customer_id     NUMBER(10),
    store_id        NUMBER(10)      NOT NULL,
    employee_id     NUMBER(10)      NOT NULL,
    payment_method  VARCHAR2(20)    NOT NULL,
    CONSTRAINT store_order_pk PRIMARY KEY (order_id),
    CONSTRAINT store_order_pay_ck CHECK (payment_method IN ('CASH', 'CARD', 'TWINT', 'VOUCHER'))
);

CREATE TABLE order_item (
    order_id        NUMBER(10)      NOT NULL,
    variant_id      NUMBER(10)      NOT NULL,
    quantity        NUMBER(4)       NOT NULL,
    unit_price      NUMBER(10,2)    NOT NULL,
    CONSTRAINT order_item_pk PRIMARY KEY (order_id, variant_id),
    CONSTRAINT order_item_qty_ck CHECK (quantity > 0),
    CONSTRAINT order_item_price_ck CHECK (unit_price >= 0)
);

-- Invoice only for online orders; UNIQUE(order_id) = 0..1 invoice per order
CREATE TABLE invoice (
    invoice_id      NUMBER(10)      NOT NULL,
    invoice_number  VARCHAR2(20)    NOT NULL,
    invoice_date    DATE            NOT NULL,
    due_date        DATE            NOT NULL,
    net_amount      NUMBER(10,2)    NOT NULL,
    vat_rate        NUMBER(4,2)     NOT NULL,
    total_amount    NUMBER(10,2)    NOT NULL,
    payment_status  VARCHAR2(20)    DEFAULT 'UNPAID' NOT NULL,
    order_id        NUMBER(10)      NOT NULL,
    CONSTRAINT invoice_pk PRIMARY KEY (invoice_id),
    CONSTRAINT invoice_number_uq UNIQUE (invoice_number),
    CONSTRAINT invoice_order_uq UNIQUE (order_id),
    CONSTRAINT invoice_dates_ck CHECK (due_date >= invoice_date),
    CONSTRAINT invoice_status_ck CHECK (payment_status IN ('UNPAID', 'PAID', 'OVERDUE', 'CANCELLED'))
);

-- =====================================================================
-- Foreign keys
-- =====================================================================

ALTER TABLE employee
    ADD CONSTRAINT employee_store_fk FOREIGN KEY (store_id) REFERENCES store (store_id);

ALTER TABLE product
    ADD CONSTRAINT product_category_fk FOREIGN KEY (category_id) REFERENCES category (category_id);

ALTER TABLE product
    ADD CONSTRAINT product_supplier_fk FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id);

ALTER TABLE product_variant
    ADD CONSTRAINT product_variant_product_fk FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE CASCADE;

ALTER TABLE inventory
    ADD CONSTRAINT inventory_store_fk FOREIGN KEY (store_id) REFERENCES store (store_id);

ALTER TABLE inventory
    ADD CONSTRAINT inventory_variant_fk FOREIGN KEY (variant_id) REFERENCES product_variant (variant_id);

ALTER TABLE online_order
    ADD CONSTRAINT online_order_orders_fk FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE;

ALTER TABLE online_order
    ADD CONSTRAINT online_order_customer_fk FOREIGN KEY (customer_id) REFERENCES customer (customer_id);

ALTER TABLE store_order
    ADD CONSTRAINT store_order_orders_fk FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE;

ALTER TABLE store_order
    ADD CONSTRAINT store_order_customer_fk FOREIGN KEY (customer_id) REFERENCES customer (customer_id);

ALTER TABLE store_order
    ADD CONSTRAINT store_order_store_fk FOREIGN KEY (store_id) REFERENCES store (store_id);

ALTER TABLE store_order
    ADD CONSTRAINT store_order_employee_fk FOREIGN KEY (employee_id) REFERENCES employee (employee_id);

ALTER TABLE order_item
    ADD CONSTRAINT order_item_orders_fk FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE;

ALTER TABLE order_item
    ADD CONSTRAINT order_item_variant_fk FOREIGN KEY (variant_id) REFERENCES product_variant (variant_id);

ALTER TABLE invoice
    ADD CONSTRAINT invoice_online_order_fk FOREIGN KEY (order_id) REFERENCES online_order (order_id);
