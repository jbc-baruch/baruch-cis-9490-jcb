{{ config(materialized='table') }}

SELECT DISTINCT
  ROW_NUMBER() OVER() AS date_time_key,
  dt AS full_date_time,
  EXTRACT(YEAR FROM dt) AS year,
  EXTRACT(MONTH FROM dt) AS month,
  FORMAT_DATE('%B', DATE(dt)) AS month_name,
  EXTRACT(DAY FROM dt) AS day_of_month,
  EXTRACT(QUARTER FROM dt) AS quarter
FROM (
  SELECT SAFE_CAST(created_date AS DATETIME) AS dt
  FROM {{ ref('stg_311') }}
  WHERE SAFE_CAST(created_date AS DATETIME) IS NOT NULL

  UNION DISTINCT

  SELECT SAFE_CAST(occur_date AS DATETIME) AS dt
  FROM {{ ref('stg_shooting_incident') }}
  WHERE SAFE_CAST(occur_date AS DATETIME) IS NOT NULL
)