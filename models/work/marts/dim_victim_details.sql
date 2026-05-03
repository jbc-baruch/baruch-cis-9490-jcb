{{ config(materialized='table') }}

SELECT DISTINCT
  ROW_NUMBER() OVER() AS victim_details_key,
  victim_age_group AS age_group,
  victim_sex AS gender,
  victim_race AS race,
  stat_murder_flg AS murder_flag
FROM {{ ref('stg_shooting_victims') }}