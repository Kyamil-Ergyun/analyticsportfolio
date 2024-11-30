/* 
 * Author: Anonymized
 * Date: 30.10.2024
 * Description: An anonymized SQL script derived from an evaluation query.
 * Data Sources:
 *
 *  - dwh_dev.dim_table_1                         -- DWH Dimension Table 1
 *  - dwh_raw.python_imported_data            -- Raw Data Table 1
 *
 * Comments retained to preserve query logic.
 */

WITH cte_dim_data AS (
SELECT 
    dim_data.dimension_id                              -- Dimension ID
    ,dim_data.dimension_name                           -- Short Name
    ,dim_data.dimension_type                           -- Type
    ,dim_data.dimension_name_2                         -- Name 2
    ,dim_data.dimension_category                       -- Category
    ,dim_data.dimension_code                           -- Code
    ,dim_data.dimension_start_date                     -- Start Date
    ,dim_data.dimension_end_date                       -- End Date
    ,dim_data.dimensions_tatus                         -- Status
FROM 
    dwh.dim_table_1 AS dim_data
WHERE 
    1=1
    AND dim_data.actual = TRUE
    AND dim_data.mev_ist_parent = FALSE
    AND dim_data.call_type ILIKE '%TYPE%'
ORDER BY 
    dim_data.start_date ASC
),
cte_dim_and_imported_data AS (
SELECT 
    cte_dim_data.dimension_id                              -- Dimension ID  --->> For every dimension_id there are several facts
    ,cte_dim_data.dimension_name                           -- Short Name
    ,cte_dim_data.dimension_type                           -- Type
    ,cte_dim_data.dimension_name_2                         -- Name 2
    ,cte_dim_data.dimension_category                       -- Category
    ,cte_dim_data.dimension_code                           -- Code
    ,cte_dim_data.dimension_start_date                     -- Start Date
    ,cte_dim_data.dimension_end_date                       -- End Date
    ,cte_dim_data.dimensions_tatus                         -- Status
    ,raw_data.metric_value_1                               -- Fact
    ,raw_data.metric_value_2                               -- Fact
    ,raw_data.metric_value_3                               -- Fact
    ,raw_data.metric_value_4                               -- Fact
    ,raw_data.flag_1                                       -- Flag   
    --- ...................
    --- ...................
    --- ...................
    --- ...................
FROM 
    cte_dim_data AS cte_dim_data 
LEFT JOIN 
    dwh_raw.python_imported_data AS raw_data
    ON raw_data.dimension_id = cte_dim_data.dimension_id
),
cte_aggregation AS (
SELECT 
    ,aggregated_data.dimension_id                             -- Dimension ID --->> For every dimension_id there are is ONLY ONE fact
    ,aggregated_data.dimension_name                           -- Short Name
    ,aggregated_data.dimension_type                           -- Type
    ,aggregated_data.dimension_name_2                         -- Name 2
    ,aggregated_data.dimension_category                       -- Category
    ,aggregated_data.dimension_code                           -- Code
    ,aggregated_data.dimension_start_date                     -- Start Date
    ,aggregated_data.dimension_end_date                       -- End Date
    ,aggregated_data.dimensions_tatus                         -- Status
    ,MAX(aggregated_data.metric_value_1) AS max_metric_value_1
    ,MAX(aggregated_data.metric_value_2) AS max_metric_value_2
    ,STRING_AGG(aggregated_data.flag_1::VARCHAR, ', ') AS aggregated_flag
    --- ...................
    --- ...................
    --- ...................
    --- ...................
FROM 
    cte_dim_and_imported_data AS aggregated_data
GROUP BY 
    aggregated_data.dimension_id, aggregated_data.data_id
)
CREATE TABLE target_schema.target_table AS
SELECT 
  *
FROM 
    cte_aggregation
ORDER BY 
    cte_aggregation.dimension_id ASC;
