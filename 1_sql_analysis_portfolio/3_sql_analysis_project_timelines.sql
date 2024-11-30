/* 
 * Author: Kyamil Ergyun
 * Date: 04.10.2024 / Time: 14:54:44
 * Ticket: Link
 * Title: Ad Hoc Data Analysis Query
 * 
 * Data Sources:
 *  - data_warehouse.fact_project AS fct
 *  - data_warehouse.dim_details AS dim_details
 *  - data_warehouse.dim_dates AS dim_dates
 * 
 * Description:
 * This query is part of an analysis to evaluate key performance
 * indicators and project timelines. It calculates various comparisons and
 * aggregates data for reporting purposes.
 * 
 * Changelog:
 * - Initial version for analysis
 * - Code review
 */

WITH cte_events_1 AS ( ------------------ Event Type 1 Details ----------------------
SELECT
    conv.ref_id AS project_ref
    , MIN(conv.start_timestamp) AS earliest_start_date
    , MAX(conv.end_timestamp) AS latest_end_date
FROM 
    data_warehouse.dim_conversations AS conv
WHERE 
    1=1
GROUP BY 
    conv.ref_id
),
cte_events_2 AS ( ------------------  Event Type 2 Details ---------------------- 
SELECT
    UNNEST(string_to_array(event.ref_id, ', ')) AS project_ref
    , event.event_id AS event_id
    , event.start_timestamp AS start_timestamp
FROM 
    data_warehouse.dim_events AS event
WHERE 
    1=1
    AND event.is_parent = FALSE
ORDER BY 
    event.event_id
)
-------------------------------------------------------------------------------------------------------------
----------------------------------------------- MAIN QUERY -------------------------------------------------
SELECT 
    fct.ref_id AS project_reference
    , dim_details.entity_name AS organization
    , dim_details.program AS program
    , dim_details.category AS project_category
    , dim_details.region_code AS state
    , dim_dates.creation_date AS creation_timestamp
    , cte_events_1.earliest_start_date AS first_conversation_start
    , cte_events_1.latest_end_date AS last_conversation_end
    , cte_events_2.start_timestamp AS milestone_start_timestamp
    , EXTRACT (DAY FROM 
                (events.start_timestamp - conv.earliest_start_date)
                ) AS days_difference_milestone_conversation_start
    , dim_dates.first_submission_date AS digital_submission_date
    , dim_dates.first_approval_date AS preliminary_approval_timestamp
    , EXTRACT (DAY FROM 
                (dim_dates.first_approval_date - dim_dates.first_submission_date)
                ) AS days_difference_submission_approval
    , dim_milestones.planned_start_timestamp AS planned_period
    , dim_dates.final_approval_date AS final_approval_timestamp
    , EXTRACT (DAY FROM 
                (dim_locations.construction_start_date - dim_dates.final_approval_date)
                ) AS days_difference_final_approval_to_construction
    , dim_locations.construction_start_date AS project_start_date
    , dim_milestones.planned_construction_start AS planned_construction_start
    , EXTRACT (DAY FROM
                (dim_milestones.planned_construction_start - dim_locations.construction_start_date)
                ) AS days_difference_construction_start_planned_start
    , dim_locations.completion_date AS completion_timestamp
    , dim_milestones.planned_completion_date AS planned_completion_timestamp
    , dim_milestones.profile_duration_end + INTERVAL '30 days' AS completion_plus_30_days
    , EXTRACT (DAY FROM
                (dim_milestones.planned_completion_date - dim_locations.construction_start_date)
                ) AS days_difference_start_to_completion
    , EXTRACT (DAY FROM
                (dim_locations.completion_date - dim_locations.construction_start_date)
                ) AS days_difference_actual_start_to_completion
    , EXTRACT (YEAR FROM dim_locations.completion_date) AS completion_year
FROM 
    data_warehouse.fact_projects AS fct
INNER JOIN 
    data_warehouse.dim_details AS dim_details
    ON fct.fk_dim_details = details.pk_dim_details
INNER JOIN 
    data_warehouse.dim_dates AS dim_dates
    ON fct.fk_dim_dates = dim_dates.pk_dim_dates
LEFT JOIN
    data_warehouse.dim_locations AS dim_locations
    ON fct.fk_dim_locations = dim_locations.pk_dim_locations
LEFT JOIN 
    data_warehouse.dim_milestones AS dim_milestones
    ON fct.fk_dim_milestones = dim_milestones.pk_dim_milestones
LEFT JOIN
    cte_events_1 AS cte_events_1
    ON fct.ref_id = conv.project_ref
LEFT JOIN
    cte_events_2 AS cte_events_2
    ON fct.ref_id = cte_events_2.project_ref AND cte_events_2.project_ref != 'Pending'
WHERE 
    1=1
    AND fct.ref_id != 'Pending'
    AND dim_details.category != 'Consultation';
