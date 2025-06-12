-- key difference between permanent tables and transient or temporary tables.

-- 1 Permanent tables can have a retention period of up to 90 days if you're in the enterprise edition.
-- Transient and temporary tables cannot. Their retention periods have to be between zero and one day inclusive.
-- This is useful if you want to make sure you'll save on storage costs for tables that don't matter much.



-- 2 Permanent tables have a fail-safe period of seven days.
-- Transient and temporary tables have a fail-safe period of zero days.
-- None of this is configurable.
-- What this means is that after your retention period is over for a permanent table, there's still hope of recovering historical data by working with the Snowflake team. But for transient and temporary tables, that's not the case. Abandon hope all you who enter transient or temporary tables hoping for fail-safe to rescue you.


-- how then are transient and temporary tables different? They both have the same possible retention periods and neither have fail-safe periods. The answer is that temporary tables only persist as long as your session lasts. Transient tables last until they're dropped. So you could think of transient tables as being partway between permanent and temporary tables. They're like permanent tables in that they persist, and they're like temporary tables in that you don't get much of a retention period with them and you get no fail-safe protection.


---> drop truck_dev if not dropped previously
DROP TABLE TASTY_BYTES.RAW_POS.TRUCK_DEV;

---> create a transient table
CREATE TRANSIENT TABLE TASTY_BYTES.RAW_POS.TRUCK_TRANSIENT
    CLONE TASTY_BYTES.RAW_POS.TRUCK;

---> create a temporary table
CREATE TEMPORARY TABLE TASTY_BYTES.RAW_POS.TRUCK_TEMPORARY
    CLONE TASTY_BYTES.RAW_POS.TRUCK;

---> show tables that start with the word TRUCK
SHOW TABLES LIKE 'TRUCK%';

---> attempt (successfully) to set the data retention time to 90 days for the standard table
ALTER TABLE TASTY_BYTES.RAW_POS.TRUCK SET DATA_RETENTION_TIME_IN_DAYS = 90;

---> attempt (unsuccessfully) to set the data retention time to 90 days for the transient table
ALTER TABLE TASTY_BYTES.RAW_POS.TRUCK_TRANSIENT SET DATA_RETENTION_TIME_IN_DAYS = 90;

---> attempt (unsuccessfully) to set the data retention time to 90 days for the temporary table
ALTER TABLE TASTY_BYTES.RAW_POS.TRUCK_TEMPORARY SET DATA_RETENTION_TIME_IN_DAYS = 90;

SHOW TABLES LIKE 'TRUCK%';

---> attempt (successfully) to set the data retention time to 0 days for the transient table
ALTER TABLE TASTY_BYTES.RAW_POS.TRUCK_TRANSIENT SET DATA_RETENTION_TIME_IN_DAYS = 0;

---> attempt (successfully) to set the data retention time to 0 days for the temporary table
ALTER TABLE TASTY_BYTES.RAW_POS.TRUCK_TEMPORARY SET DATA_RETENTION_TIME_IN_DAYS = 0;

SHOW TABLES LIKE 'TRUCK%';
