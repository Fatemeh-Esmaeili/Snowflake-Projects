-- Role-Based Access Control, RBAC, in Snowflake, which is a system that lets you control access to particular Snowflake objects by granting privileges to roles and then assigning those roles to users.

-- securable objects, privileges, roles, and users

-- securable object: these are the entities, those roles with the right privileges can manipulate in some way. A warehouse is a securable object. We gave Tasty DE the ability to create this object.

-- Security Admin: only has a handful of privileges. But these are powerful. They let the security admin set account level security policies like a password policy


-- User Admin: privileges are even more simple but also powerful. The User Admin can create roles and create users.

-- Sys Admin: is primarily able to create databases and warehouses.

-- Public: is primarily able to run queries.

-- account Admin role has access to the Security Admin role, and the security admin role has access to the User Admin role. The account admin role also has access to the Sys Admin role, and all of these roles have access to the public role, so they can all run queries.


USE ROLE accountadmin;


---> create a role
CREATE ROLE tasty_de;

---> see what privileges this new role has
SHOW GRANTS TO ROLE tasty_de;

---> see what privileges an auto-generated role has
SHOW GRANTS TO ROLE accountadmin;

---> grant a role to a specific user
-- GRANT ROLE tasty_de TO USER [username];
GRANT ROLE tasty_de TO USER FATEMEHES;

---> use a role
USE ROLE tasty_de;

---> try creating a warehouse with this new role
CREATE WAREHOUSE tasty_de_test;

USE ROLE accountadmin;

---> grant the create warehouse privilege to the tasty_de role
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE tasty_de;

---> show all of the privileges the tasty_de role has
SHOW GRANTS TO ROLE tasty_de;

USE ROLE tasty_de;

---> test to see whether tasty_de can create a warehouse
-- Give SQL access control error
CREATE WAREHOUSE tasty_de_test;


-- To fix that error, use role accountadmin
USE ROLE accountadmin;

-- Then giving previliage to tasty_de
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE tasty_de;

---> show that this role has the create warehouse privilage
SHOW GRANTS TO ROLE tasty_de;

USE ROLE tasty_de;

-- now, the role tasty_de has the privilage to make warehouses
CREATE WAREHOUSE tasty_de_test;



---> learn more about the privileges each of the following auto-generated roles has
SHOW GRANTS TO ROLE orgadmin;

SHOW GRANTS TO ROLE accountadmin;

SHOW GRANTS TO ROLE securityadmin;

SHOW GRANTS TO ROLE useradmin;

SHOW GRANTS TO ROLE sysadmin;

SHOW GRANTS TO ROLE public;


-- Example

CREATE ROLE tasty_role;

SHOW GRANTS TO ROLE tasty_role;

GRANT CREATE DATABASE ON ACCOUNT TO ROLE tasty_role;

SHOW GRANTS TO ROLE tasty_role;

-- See your name
SELECT CURRENT_USER;

GRANT ROLE tasty_role TO USER FATEMEHES;

USE ROLE tasty_role;

CREATE WAREHOUSE tasty_test_wh;

USE ROLE accountadmin;

SHOW GRANTS TO USER FATEMEHES;

SHOW GRANTS TO ROLE useradmin;
