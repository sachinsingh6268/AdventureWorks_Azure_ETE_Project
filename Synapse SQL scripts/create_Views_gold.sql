CREATE VIEW gold.sales AS 
SELECT * 
FROM OPENROWSET(
    BULK 'abfss://silver@synapsehandsonstorage.dfs.core.windows.net/',
    FORMAT = 'csv',
    FIRST_ROW = 1,
    PARSER_VERSION = '2.0'
) AS sales_2017

