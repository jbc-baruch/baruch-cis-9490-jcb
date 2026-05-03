{{ config(materialized='table') }}

SELECT DISTINCT
  ROW_NUMBER() OVER() AS incident_address_key,
  boro AS incident_borough,
  SAFE_CAST(precinct AS INT64) AS incident_precinct,
  SAFE_CAST(jurisdiction_code AS INT64) AS jurisdiction_code,
  loc_of_occur_desc AS incident_address_type,
  location_desc AS incident_address_desc,
  loc_classfctn_desc AS incident_in_out
FROM {{ ref('stg_shooting_incident') }}