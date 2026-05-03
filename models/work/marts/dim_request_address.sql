{{ config(materialized='table') }}

SELECT DISTINCT
  ROW_NUMBER() OVER() AS request_address_key,
  incident_address AS request_address,
  city,
  street_name,
  cross_street_1 AS cross_street_one,
  cross_street_2 AS cross_street_two,
  intersection_street_1 AS intersect_street_one,
  intersection_street_2 AS intersect_street_two,
  borough,
  SAFE_CAST(bbl AS INT64) AS block_lot,
  SAFE_CAST(police_precinct AS INT64) AS police_precinct,
  SAFE_CAST(council_district AS INT64) AS council_district,
  landmark,
  address_type,
  location_type AS facility_type,
  park_facility_name AS park_facility_type,
  park_borough,
  incident_zip AS address_description
FROM {{ ref('stg_311') }}