/*
 * Topic: Projekt Analysis 2023
 * Author: Colleague and & Kyamil Ergyun
 * Ticket: Link
 * Query Date: 18.11.2024
 * Changelog:
 * ++ Replaced dim.call_type to IN ('TYPE_X', 'TYPE_Y')
 * ++ SQL Standart formatting
 */

SELECT
    fact.project_id AS "Project Identifier"
    ,'Handler-X' AS "Project Handler"
    ,dim.state_code AS "State Code"
    ,dim.call_type AS "Project Type"
    ,DATE(dim.application_timestamp) AS "Application Date"
    ,dim.category_type AS "Category Type"
    ,dim.progress_metric AS "Progress"
    ,dim.entity_name AS "Entity Name"
    ,dim.electoral_area AS "District Area"
    ,dim.district_names AS "District Names"
    ,CASE
        WHEN dim.status_code IN ('code1', 'code2', 'code3', 'code4') THEN 'Phase-1'
        WHEN dim.status_code = 'code5' THEN 'Phase-2'
        ELSE 'Other Phase'
     END AS "Project Phase"
   ----------------------------------------------------------------------------------
    ,metrics.total_points AS "Total Points"
    ,metrics.metric_1 AS "Metric 1"
    ,metrics.metric_2 AS "Metric 2"
    ,metrics.metric_3 AS "Metric 3"
    ,metrics.metric_4 AS "Metric 4"
    ,metrics.percentage_metric AS "Percentage Metric"
   ----------------------------------------------------------------------------------
    ,asset.connection_total AS "Total Connections"
    ,asset.connection_type_1 AS "Type 1 Connections"
    ,asset.connection_type_2 AS "Type 2 Connections"
    ,asset.connection_combined AS "Combined Connections"
   ----------------------------------------------------------------------------------
    ,CASE
        WHEN fact.co_amount_euro IS NULL THEN 'Not Applicable'
        ELSE 'Applicable'
     END AS "Co-Amount Euro Status"
    ,fact.amount_euro_requested AS "Requested Amount Euro"
    ,fact.amount_euro_ratio / 100::NUMERIC AS "Amount Euro Ratio"
    ,fact.project_cost AS "Project Cost"
    ,fact.investment_summary AS "Investment Summary"
FROM 
    fact_table AS fact
INNER JOIN 
    dimension_data AS dim
    ON fact.fk_dim = dim.pk_dim
LEFT JOIN 
    metrics_data AS metrics
    ON fact.project_id = metrics.project_id AND metrics.actual IS TRUE  -------- most actual data from the dimensional table
LEFT JOIN 
    asset_data AS asset
    ON fact.project_id = asset.project_id AND asset.actual IS TRUE      -------- most actual data from the dimensional table
WHERE 
    1=1
    AND dim.call_type IN ('TYPE_X', 'TYPE_Y')
ORDER BY 
    fact.project_id ASC
;
