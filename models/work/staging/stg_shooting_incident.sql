{{ config(materialized='table') }}

SELECT
  *
FROM `caral-485802.gr_proj_raw_data.nyc_shooting_incidents`