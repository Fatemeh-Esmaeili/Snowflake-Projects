---> see an example of a column with semi-structured (JSON) data
SELECT MENU_ITEM_NAME
    , MENU_ITEM_HEALTH_METRICS_OBJ
FROM tasty_bytes.RAW_POS.MENU;

DESCRIBE TABLE tasty_bytes.RAW_POS.MENU;


---> check out the data type for the menu_item_health_metrics_obj column – It’s a VARIANT
/*--
CREATE TABLE tasty_bytes.raw_pos.menu
(
    menu_id NUMBER(19,0),
    menu_type_id NUMBER(38,0),
    menu_type VARCHAR(16777216),
    truck_brand_name VARCHAR(16777216),
    menu_item_id NUMBER(38,0),
    menu_item_name VARCHAR(16777216),
    item_category VARCHAR(16777216),
    item_subcategory VARCHAR(16777216),
    cost_of_goods_usd NUMBER(38,4),
    sale_price_usd NUMBER(38,4),
    menu_item_health_metrics_obj VARIANT
);
--*/

---> create the test_menu table with just a variant column in it, as a test
CREATE TABLE tasty_bytes.RAW_POS.TEST_MENU (cost_of_goods_variant)
AS SELECT cost_of_goods_usd::VARIANT
FROM tasty_bytes.RAW_POS.MENU;

---> notice that the column is of the VARIANT type
DESCRIBE TABLE tasty_bytes.RAW_POS.TEST_MENU;

---> but the typeof() function reveals the underlying data type
SELECT TYPEOF(cost_of_goods_variant) FROM tasty_bytes.raw_pos.test_menu;

---> Snowflake lets you perform operations based on the underlying data type
SELECT cost_of_goods_variant, cost_of_goods_variant*2.0 FROM tasty_bytes.raw_pos.test_menu;

DROP TABLE tasty_bytes.raw_pos.test_menu;

---> you can use the colon to pull out info from menu_item_health_metrics_obj
SELECT MENU_ITEM_HEALTH_METRICS_OBJ:menu_item_health_metrics FROM tasty_bytes.raw_pos.menu;

---> use typeof() to see the underlying type
SELECT TYPEOF(MENU_ITEM_HEALTH_METRICS_OBJ) FROM tasty_bytes.raw_pos.menu;

SELECT MENU_ITEM_HEALTH_METRICS_OBJ, MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_id'] FROM tasty_bytes.raw_pos.menu;


-- dot notation

SELECT MENU_ITEM_HEALTH_METRICS_OBJ:menu_item_health_metrics
FROM tasty_bytes.raw_pos.menu;


SELECT MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_health_metrics']
FROM tasty_bytes.raw_pos.menu;

--Variatn (with object type)
CREATE TABLE tasty_bytes.raw_pos.test_menu1 (ingredients)
AS SELECT MENU_ITEM_HEALTH_METRICS_OBJ
FROM tasty_bytes.raw_pos.menu;


SELECT * FROM tasty_bytes.raw_pos.test_menu1;

DESCRIBE TABLE tasty_bytes.raw_pos.test_menu1;

SELECT TYPEOF(ingredients) FROM tasty_bytes.raw_pos.test_menu1;



--Variatn (with array type)
CREATE TABLE tasty_bytes.raw_pos.test_menu2 (ingredients)
AS SELECT MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_health_metrics']
FROM tasty_bytes.raw_pos.menu;

SELECT * FROM tasty_bytes.raw_pos.test_menu2;
SELECT TYPEOF(ingredients) FROM tasty_bytes.raw_pos.test_menu2;


--Variatn (with object type)
CREATE TABLE tasty_bytes.raw_pos.test_menu3 (ingredients)
AS SELECT MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_health_metrics'][0]
FROM tasty_bytes.raw_pos.menu;

SELECT * FROM tasty_bytes.raw_pos.test_menu3;
SELECT TYPEOF(ingredients) FROM tasty_bytes.raw_pos.test_menu3;


--Variatn (with array type)
CREATE TABLE tasty_bytes.raw_pos.test_menu4 (ingredients)
AS SELECT MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_health_metrics'][0]['ingredients']
FROM tasty_bytes.raw_pos.menu;

SELECT * FROM tasty_bytes.raw_pos.test_menu4;
SELECT TYPEOF(ingredients) FROM tasty_bytes.raw_pos.test_menu4;


--Variatn (with varchar type)
CREATE TABLE tasty_bytes.raw_pos.test_menu5 (ingredients)
AS SELECT MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_health_metrics'][0]['ingredients'][0]
FROM tasty_bytes.raw_pos.menu;

SELECT * FROM tasty_bytes.raw_pos.test_menu5;
SELECT TYPEOF(ingredients) FROM tasty_bytes.raw_pos.test_menu5;


-- All at once
SELECT MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_health_metrics'][0]['ingredients'][0]
FROM tasty_bytes.raw_pos.menu;


SELECT
    *
FROM tasty_bytes.raw_pos.menu m,
    LATERAL FLATTEN (input => m.menu_item_health_metrics_obj:menu_item_health_metrics);


SELECT
    m.menu_item_name,
    value:"ingredients"[0] AS ingredients
FROM tasty_bytes.raw_pos.menu m,
    LATERAL FLATTEN (input => m.menu_item_health_metrics_obj:menu_item_health_metrics);


-- Creating our View Using Semi-Structured Flattening SQL
CREATE OR REPLACE VIEW tasty_bytes.analytics.menu_v
    AS
SELECT
    m.menu_item_health_metrics_obj:menu_item_id::integer AS menu_item_id,
    value:"is_healthy_flag"::VARCHAR(1) AS is_healthy_flag,
    value:"is_gluten_free_flag"::VARCHAR(1) AS is_gluten_free_flag,
    value:"is_dairy_free_flag"::VARCHAR(1) AS is_dairy_free_flag,
    value:"is_nut_free_flag"::VARCHAR(1) AS is_nut_free_flag
FROM tasty_bytes.raw_pos.menu m,
    LATERAL FLATTEN (input => m.menu_item_health_metrics_obj:menu_item_health_metrics);


SELECT
    *
FROM tasty_bytes.analytics.menu_v;

--Providing Metrics to Executives
SELECT
    COUNT(DISTINCT menu_item_id) AS total_menu_item,
    SUM(CASE WHEN is_healthy_flag = 'Y' THEN 1 ELSE 0 END) AS healthy_item_count,
    SUM(CASE WHEN is_gluten_free_flag = 'Y' THEN 1 ELSE 0 END) AS gluten_free_item_count,
    SUM(CASE WHEN is_dairy_free_flag = 'Y' THEN 1 ELSE 0 END) AS is_dairy_free_item_count,
    SUM(CASE WHEN is_nut_free_flag = 'Y' THEN 1 ELSE 0 END) AS is_nut_free_item_count
FROM tasty_bytes.analytics.menu_v;



/*--
. Example
--*/


SELECT MENU_ITEM_NAME
    , MENU_ITEM_HEALTH_METRICS_OBJ
FROM tasty_bytes.RAW_POS.MENU;

DESCRIBE TABLE tasty_bytes.RAW_POS.MENU;

SELECT TYPEOF(MENU_ITEM_HEALTH_METRICS_OBJ) FROM tasty_bytes.RAW_POS.MENU;


SELECT MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_health_metrics'][0]['ingredients'][0]
FROM tasty_bytes.raw_pos.menu
WHERE MENU_ITEM_NAME = 'Mango Sticky Rice';
