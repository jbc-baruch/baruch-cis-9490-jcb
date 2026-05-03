{{ config(materialized='table') }}

SELECT DISTINCT
  ROW_NUMBER() OVER() AS request_status_key,
  status AS resolution_status,
  resolution_description AS resolution_details
FROM {{ ref('stg_311') }}