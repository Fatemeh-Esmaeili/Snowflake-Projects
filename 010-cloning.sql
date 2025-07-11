
-- cloning is zero copy and Snowflake tracks subsequent changes.
-- how to clone tables, schemas, and databases.
-- how to combine time travel and cloning.
-- how to use the information schema to check out the clone group ID and the active bytes columns in the table storage metrics view.
-- how to check out the bytes column in the table view.



---> create a clone of the truck table
CREATE OR REPLACE TABLE tasty_bytes.raw_pos.truck_clone
    CLONE tasty_bytes.raw_pos.truck;

/* look at metadata for the truck and truck_clone tables from the table_storage_metrics view in the information_schema */
SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

/* look at metadata for the truck and truck_clone tables from the tables view in the information_schema */
SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

---> insert the truck table into the clone (thus doubling the clone’s size!)
INSERT INTO tasty_bytes.raw_pos.truck_clone
SELECT * FROM tasty_bytes.raw_pos.truck;

/* look at metadata for the truck and truck_clone tables from the tables view in the information_schema */
SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

---> now use the tables view to look at metadata for the truck and truck_clone tables again
SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

---> clone a schema
CREATE OR REPLACE SCHEMA tasty_bytes.raw_pos_clone
CLONE tasty_bytes.raw_pos;

---> clone a database
CREATE OR REPLACE DATABASE tasty_bytes_clone
CLONE tasty_bytes;

---> clone a table based on an offset (so the table as it was at a certain interval in the past)
CREATE OR REPLACE TABLE tasty_bytes.raw_pos.truck_clone_time_travel
    CLONE tasty_bytes.raw_pos.truck AT(OFFSET => -60*10);

SELECT * FROM tasty_bytes.raw_pos.truck_clone_time_travel;


-- Example

CREATE OR REPLACE DATABASE tasty_bytes_clone;

CREATE OR REPLACE TABLE tasty_bytes.raw_pos.truck_clone
    CLONE tasty_bytes.raw_pos.truck;


SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE (TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK')
AND TABLE_CATALOG = 'TASTY_BYTES';
    
