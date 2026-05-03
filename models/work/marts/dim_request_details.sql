{{ config(materialized='table') }}

SELECT DISTINCT
  ROW_NUMBER() OVER() AS details_key,
  complaint_type AS request_descriptor,
  descriptor AS request_descriptor_two,
  open_data_channel_type AS submission_channel
FROM {{ ref('stg_311') }}