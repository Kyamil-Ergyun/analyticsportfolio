-----------------------------------------------------------------------------------------------
-- 					INFORMATION SCHEMA -- METADATA CHECKS & DATA SEARCH
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
-- 							SYSTEM INFORMATION FOR COLUMNS:
-----------------------------------------------------------------------------------------------

-- This query is used to explore the column-level metadata within the database.
-- By querying the `information_schema.COLUMNS`, you can retrieve details about 
-- columns in all tables across specific schemas (`dwh_staging`, `dwh_dev`, `dwh_prod`).
-- This is particularly useful when investigating unknown or unfamiliar tables


SELECT 
    *
FROM 
	information_schema.COLUMNS
WHERE 
    1=1
    AND table_schema IN ('dwh_staging', 'dwh_dev', 'dwh_prod') -- Targeted schemas
--  AND column_name IN ('specific_column_name')                -- Uncomment for exact matches
    AND column_name ILIKE '%ABCDEF%'                           -- Search for partial matches
--  AND table_name = 'specific_table_name'                     -- Filter by specific table name
ORDER BY 
    table_schema DESC, table_name, ordinal_position            -- Organize results for readability
;

-----------------------------------------------------------------------------------------------
-- 								SYSTEM INFORMATION FOR COLUMNS:
-----------------------------------------------------------------------------------------------
-- SYSTEM INFORMATION FOR TABLES:
-- This query retrieves metadata about tables from the `information_schema.TABLES` view.
-- It is useful when you need to explore database tables, especially in situations
-- where the table names or their exact locations are not directly known.

SELECT 
    *
FROM information_schema.TABLES
WHERE 
    1=1
--  AND table_schema = 'dwh_dev'                              -- Uncomment to target specific schema
--  AND table_name IN ('specific_table_name')                 -- Uncomment for specific table searches
    AND table_name ILIKE '%ABCDEF%'                           -- Search for partial matches
ORDER BY 
    table_schema DESC, table_name                             -- Organize results for clarity
;






