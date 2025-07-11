-- A standard VIEW save the query itself, making it easy to run again and again.

-- A materialized VIEW saves the results of running a query and automatically updates
-- the results when the table or tables that view is based on update.


-- !!! UNDROP VIEW does not work here for views. you need to create the view again.
/*--
. harmonized view creation
--*/

---> create the orders_v view – note the “CREATE VIEW view_name AS SELECT” syntax

-- CREATE MATERIALIZED VIEW tasty_bytes.harmonized.orders_v
--! you can't create materialized view with join in it

CREATE VIEW tasty_bytes.harmonized.orders_v
    AS
SELECT
    oh.order_id,
    oh.truck_id,
    oh.order_ts,
    od.order_detail_id,
    od.line_number,
    m.truck_brand_name,
    m.menu_type,
    t.primary_city,
    t.region,
    t.country,
    t.franchise_flag,
    t.franchise_id,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name,
    l.location_id,
    cl.customer_id,
    cl.first_name,
    cl.last_name,
    cl.e_mail,
    cl.phone_number,
    cl.children_count,
    cl.gender,
    cl.marital_status,
    od.menu_item_id,
    m.menu_item_name,
    od.quantity,
    od.unit_price,
    od.price,
    oh.order_amount,
    oh.order_tax_amount,
    oh.order_discount_amount,
    oh.order_total
FROM tasty_bytes.raw_pos.order_detail od
JOIN tasty_bytes.raw_pos.order_header oh
    ON od.order_id = oh.order_id
JOIN tasty_bytes.raw_pos.truck t
    ON oh.truck_id = t.truck_id
JOIN tasty_bytes.raw_pos.menu m
    ON od.menu_item_id = m.menu_item_id
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id
JOIN tasty_bytes.raw_pos.location l
    ON oh.location_id = l.location_id
LEFT JOIN tasty_bytes.raw_customer.customer_loyalty cl
    ON oh.customer_id = cl.customer_id;

SELECT COUNT(*) FROM tasty_bytes.harmonized.orders_v;

CREATE VIEW tasty_bytes.harmonized.brand_names
    AS
SELECT truck_brand_name
FROM tasty_bytes.raw_pos.menu;

SHOW VIEWS;

---> drop a view
DROP VIEW tasty_bytes.harmonized.brand_names;

SHOW VIEWS;

---> see metadata about a view
DESCRIBE VIEW tasty_bytes.harmonized.orders_v;

---> create a materialized view
CREATE MATERIALIZED VIEW tasty_bytes.harmonized.brand_names_materialized
    AS
SELECT DISTINCT truck_brand_name
FROM tasty_bytes.raw_pos.menu;

SELECT * FROM tasty_bytes.harmonized.brand_names_materialized;

SHOW VIEWS;

SHOW MATERIALIZED VIEWS;


---> see metadata about the materialized view we just made
DESCRIBE VIEW tasty_bytes.harmonized.brand_names_materialized;

DESCRIBE MATERIALIZED VIEW tasty_bytes.harmonized.brand_names_materialized;

---> drop the materialized view
DROP MATERIALIZED VIEW tasty_bytes.harmonized.brand_names_materialized;




/*--
. Example
--*/
CREATE OR REPLACE VIEW tasty_bytes.raw_pos.truck_franchise
    AS
SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck  t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;


SELECT *
FROM tasty_bytes.raw_pos.truck_franchise
WHERE 1=1 AND
franchisee_first_name = 'Sara' AND
franchisee_last_name ='Nicholson';



DESCRIBE VIEW tasty_bytes.raw_pos.truck_franchise;


DROP VIEW tasty_bytes.raw_pos.truck_franchise;

CREATE MATERIALIZED VIEW tasty_bytes.raw_pos.truck_franchise_materialized
    AS
SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;


CREATE MATERIALIZED VIEW tasty_bytes.raw_pos.nissan
    AS
SELECT
    t.*
FROM tasty_bytes.raw_pos.truck t
WHERE make = 'Nissan';

SELECT COUNT(*) FROM tasty_bytes.raw_pos.nissan;


DROP MATERIALIZED VIEW tasty_bytes.raw_pos.nissan;
