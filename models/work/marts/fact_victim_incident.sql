{{ config(materialized='table') }}

SELECT
  ROW_NUMBER() OVER() AS victim_incident_key,
  SAFE_CAST(i.incident_key AS INT64) AS incident_id,
  SAFE_CAST(v.victim_id AS INT64) AS victim_id,

  vd.victim_details_key,

  dt.date_time_key AS ocurr_datetime_key,
  sa.incident_address_key,

  SAFE_CAST(i.latitude AS FLOAT64) AS incident_latitude,
  SAFE_CAST(i.longitude AS FLOAT64) AS incident_longitude

FROM {{ ref('stg_shooting_incident') }} i

LEFT JOIN {{ ref('stg_shooting_victims') }} v
  ON i.incident_key = v.incident_key

LEFT JOIN {{ ref('dim_victim_details') }} vd
  ON v.victim_age_group = vd.age_group
  AND v.victim_sex = vd.gender
  AND v.victim_race = vd.race

LEFT JOIN {{ ref('dim_datetime') }} dt
  ON SAFE_CAST(i.occur_date AS DATETIME) = dt.full_date_time

LEFT JOIN {{ ref('dim_shooting_address') }} sa
  ON i.boro = sa.incident_borough