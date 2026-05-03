{{ config(materialized='table') }}

SELECT
  ROW_NUMBER() OVER() AS request_key,
  SAFE_CAST(unique_key AS INT64) AS request_id,

  d.details_key AS request_details_key,
  s.request_status_key,

  dt.date_time_key AS created_datetime_key,
  dt.date_time_key AS updated_datetime_key,
  dt.date_time_key AS closed_datetime_key,

  a.request_address_key,

  SAFE_CAST(latitude AS FLOAT64) AS request_latitude,
  SAFE_CAST(longitude AS FLOAT64) AS request_longitude

FROM {{ ref('stg_311') }} r

LEFT JOIN {{ ref('dim_request_details') }} d
  ON r.complaint_type = d.request_descriptor
  AND r.descriptor = d.request_descriptor_two

LEFT JOIN {{ ref('dim_request_resolution') }} s
  ON r.status = s.resolution_status

LEFT JOIN {{ ref('dim_datetime') }} dt
  ON SAFE_CAST(r.created_date AS DATETIME) = dt.full_date_time

LEFT JOIN {{ ref('dim_request_address') }} a
  ON r.incident_address = a.request_address