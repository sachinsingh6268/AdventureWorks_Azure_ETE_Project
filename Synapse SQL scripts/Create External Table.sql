-- first create the database master key 
CREATE MASTER KEY ENCRYPTION BY PASSWORD ='Sachin@987654321'


-- create database credentials
CREATE DATABASE SCOPED CREDENTIAL db_cred_sachin
WITH IDENTITY = 'Managed Identity'


-- create external data source for the containers to access the files inside
-- It's like mounting this location to a name so that we don't need to write the whole location again & again
-- we will also need to provide the credentials created above so that data lake can authenticate
CREATE EXTERNAL DATA SOURCE source_silver 
WITH 
(
    LOCATION = 'https://synapsehandsonstorage.dfs.core.windows.net/silver',
    CREDENTIAL = db_cred_sachin
)  

CREATE EXTERNAL DATA SOURCE destination_gold 
WITH 
(
    LOCATION = 'https://synapsehandsonstorage.dfs.core.windows.net/gold',
    CREDENTIAL = db_cred_sachin
)  

-- Define the external file format
-- particular location might have muliple file formats, so will specify which file format we need to read on the defined external data source
CREATE EXTERNAL FILE FORMAT csv_format
WITH 
(
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 2,
        USE_TYPE_DEFAULT = TRUE
    )
)


--------------------------------------------
-- CREATE EXTERNAL TABLE "external_sales"
CREATE EXTERNAL TABLE gold.external_sales
WITH
(
LOCATION = 'external_sales',
DATA_SOURCE = destination_gold,
FILE_FORMAT = csv_format
) AS 
SELECT * FROM gold.sales


select * from gold.external_sales