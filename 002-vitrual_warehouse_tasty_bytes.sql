---> what menu items does the Freezing Point brand sell?
SELECT
   menu_item_name
FROM tasty_bytes_sample_data.raw_pos.menu
WHERE truck_brand_name = 'Freezing Point';

---> what is the profit on Mango Sticky Rice?
SELECT
   menu_item_name,
   (sale_price_usd - cost_of_goods_usd) AS profit_usd
FROM tasty_bytes_sample_data.raw_pos.menu
WHERE 1=1
AND truck_brand_name = 'Freezing Point'
AND menu_item_name = 'Mango Sticky Rice';

CREATE WAREHOUSE warehouse_Fatemeh1;
CREATE WAREHOUSE warehouse_Fatemeh2;

SHOW WAREHOUSES;

USE WAREHOUSE warehouse_Fatemeh1;

---Compute power & credit consumption of different warehouse sizes


--- Scaling Virtual Warehouses

--- Part 1 *** Scaling Vertically *** Part 1

--- How to resize a warehouse

---> set warehouse size to medium
ALTER WAREHOUSE warehouse_Fatemeh2 SET warehouse_size=MEDIUM;

USE WAREHOUSE warehouse_Fatemeh2;

SELECT
    menu_item_name,
   (sale_price_usd - cost_of_goods_usd) AS profit_usd
FROM tasty_bytes_sample_data.raw_pos.menu
ORDER BY 2 DESC;

---> set warehouse size to xsmall
ALTER WAREHOUSE WAREHOUSE_FATEMEH2 SET warehouse_size=XSMALL;

---> drop warehouse
DROP WAREHOUSE WAREHOUSE_FATEMEH1;

SHOW WAREHOUSES;


--- Part 2 *** Scaling Horizontally *** Part 2


---> create a multi-cluster warehouse (max clusters = 3)
CREATE WAREHOUSE Wh_Es1 MAX_CLUSTER_COUNT = 3;

SHOW WAREHOUSES;

---> set the auto_suspend and auto_resume parameters
ALTER WAREHOUSE warehouse_FATEMEH2 SET AUTO_SUSPEND = 180 AUTO_RESUME = FALSE;


---> set the warehouse to the suspend mode
ALTER WAREHOUSE wh_es1 SUSPEND;
SHOW WAREHOUSES;


CREATE WAREHOUSE warehouse_two;
USE WAREHOUSE warehouse_two;
SHOW WAREHOUSES;


DROP WAREHOUSE warehouse_two;

ALTER WAREHOUSE warehouse_one SET warehouse_size = SMALL;
SHOW WAREHOUSES;

ALTER WAREHOUSE warehouse_one SET auto_suspend = 120;
SHOW WAREHOUSES;
