# snowpark DataFrames

# 1- Snowflake provides DataFrame APIs called Snowpark DataFrames that you can use to do
# transformations in Python, Java, and Scala.

# 2- Python Worksheets come pre-installed with Snowpark so they're an easy way to
# start learning Snowpark DataFrames.

# 3- you can load a table as a Snowpark DataFrame using session.table or session.sql.

# 4- session.sql lets you run more than just select commands. For example, you can create a table.

# 5- Snowpark DataFrames are lazily executed, so no computation happens
# until you call.collect.show or something similar.

# 6- the DataFrame filter method combined with col lets you pull specific columns.

# 7- the DataFrame select method, combined with an expression, lets you pull specific rows.

# 8- Snowpark DataFrame support method chaining.

# 9- Save a Snowpark DataFrame as a table in a database and schema with the right.save_as_table method.


# 3- load a table as a Snowpark DataFrame using session.table
import snowflake.snowpark as snowpark

# make sure to define main when you’re working in a Python worksheet
def main(session: snowpark.Session):

    # load your table as a dataframe
    df_table = session.table("TASTY_BYTES.RAW_POS.MENU")

    # execute the operations. (Remember, Snowpark DataFrames are evaluated lazily.)
    df_table.show()
    return df_table

# ----------------
# 3- load data using a query through session.sql instead of through session.table
import snowflake.snowpark as snowpark

def main(session: snowpark.Session):

    df_table2 = session.sql("SELECT * FROM TASTY_BYTES.RAW_POS.MENU LIMIT 5")
    df_table2.show()
    return df_table2

# ----------------
# 4- session.sql lets you run more than just select commands. For example, you can create a table.
# you can run other commands through session.sql – even things like CREATE

import snowflake.snowpark as snowpark

def main(session: snowpark.Session):

    df_table = session.sql("SELECT * FROM TASTY_BYTES.RAW_POS.MENU")
    session.sql("""
    CREATE OR REPLACE TABLE TEST_DATABASE.TEST_SCHEMA.EMPTY_TABLE (
    col1 varchar,
    col2 varchar
    )""").collect()

    df_table.show()
    return df_table


# ----------------
# 6- the DataFrame filter method combined with col lets you pull specific columns.
# filter rows
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
    df_table = session.table("TASTY_BYTES.RAW_POS.MENU")
    df_table = df_table.filter(col("TRUCK_BRAND_NAME") == "Freezing Point")

    df_table.show()
    return df_table


# ----------
# 7- the DataFrame select method, combined with an expression, lets you pull specific rows.
# select columns

import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
    df_table = session.table("TASTY_BYTES.RAW_POS.MENU")
    df_table = df_table.select(col("MENU_ITEM_NAME"), col("ITEM_CATEGORY"))

    df_table.show()
    return df_table


# ----------
# 8- Snowpark DataFrame support method chaining.
# filter and select at the same time (chaining)
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
    df_table = session.table("TASTY_BYTES.RAW_POS.MENU")
    df_table = df_table.filter(
        col("TRUCK_BRAND_NAME") == "Freezing Point"
    ).select(
        col("MENU_ITEM_NAME"),
        col("ITEM_CATEGORY"))

    df_table.show()
    return df_table

# ------
# 9- Save a Snowpark DataFrame as a table in a database and schema with the right.save_as_table method.
# save your dataframe as a table!

import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
    df_table = session.table("TASTY_BYTES.RAW_POS.MENU")
    df_table = df_table.filter(
        col("TRUCK_BRAND_NAME") == "Freezing Point"
    ).select(
        col("MENU_ITEM_NAME"),
        col("ITEM_CATEGORY"))

    df_table.write.save_as_table("TEST_DATABASE.TEST_SCHEMA.FREEZING_POINT_ITEMS", mode="append")

    df_table.show()
    return df_table

# Examples 1 ----------

import snowflake.snowpark as snowpark
def main(session: snowpark.Session):

    df_table = session.table("TASTY_BYTES.RAW_POS.MENU")
    df_table.show()
    return df_table;

# Examples 2 ----------
import snowflake.snowpark as snowpark

def main(session: snowpark.Session):

    df_table = session.sql("SELECT * FROM TASTY_BYTES.RAW_POS.MENU LIMIT 10")
    df_table.show()
    return df_table;

# Examples 3 ----------
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
    df_table = session.table("TASTY_BYTES.RAW_POS.MENU")
    df_table = df_table.filter(col("TRUCK_BRAND_NAME") == "The Mac Shack")

    df_table.show()
    return df_table

# Examples 4 ----------
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
    df_table = session.table("TASTY_BYTES.RAW_POS.MENU")
    df_table = df_table.filter(col("TRUCK_BRAND_NAME") == "The Mac Shack").select(
        col("MENU_ITEM_NAME"),
        col("ITEM_CATEGORY"),
        col("TRUCK_BRAND_NAME")
    )

    df_table.write.save_as_table("TEST_DATABASE.TEST_SCHEMA.Mac_Shack", mode="append")
    df_table.show()
    return df_table
