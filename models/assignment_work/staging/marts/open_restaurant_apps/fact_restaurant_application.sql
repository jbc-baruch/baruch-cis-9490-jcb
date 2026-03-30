-- Fact table for open restaurant applications

WITH restaurant_applications AS (
    SELECT
        objectid,
        time_of_submission,
        borough,
        zip,
        restaurant_name,
        building_number,
        street,
        business_address,
        seating_interest_sidewalk,
        approved_for_sidewalk_seating,
        approved_for_roadway_seating,
        sidewalk_dimensions_length,
        sidewalk_dimensions_width,
        sidewalk_dimensions_area,
        latitude,
        longitude,
        qualify_alcohol,
        sla_serial_number,
        sla_license_type,
        landmark_district_or_building,
        healthcompliance_terms
    FROM {{ ref('stg_nyc_open_restaurant_apps') }}
    WHERE objectid IS NOT NULL
),

fact_restaurant_application AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['a.objectid']) }} AS application_key,
        a.objectid,
        a.time_of_submission AS application_submitted,
        d.date_key AS submission_date_key,
        l.location_key,
        r.restaurant_key,
        s.seating_type_key,
        a.business_address,
        a.street,
        a.building_number,
        a.latitude,
        a.longitude,
        CAST(a.sidewalk_dimensions_length AS INT64) AS sidewalk_length_ft,
        CAST(a.sidewalk_dimensions_width AS INT64) AS sidewalk_width_ft,
        CAST(a.sidewalk_dimensions_area AS INT64) AS sidewalk_area_sqft,
        CASE
            WHEN LOWER(CAST(a.qualify_alcohol AS STRING)) IN ('yes', 'y', 'true') THEN TRUE
            ELSE FALSE
        END AS qualify_alcohol,
        CASE
            WHEN LOWER(CAST(a.landmark_district_or_building AS STRING)) IN ('yes', 'y', 'true') THEN TRUE
            ELSE FALSE
        END AS is_landmark_location,
        CASE
            WHEN LOWER(CAST(a.healthcompliance_terms AS STRING)) IN ('yes', 'y', 'true') THEN TRUE
            ELSE FALSE
        END AS health_compliance_terms_accepted,
        a.sla_serial_number,
        a.sla_license_type
    FROM restaurant_applications a
    LEFT JOIN {{ ref('dim_date') }} d
        ON CAST(a.time_of_submission AS DATE) = d.full_date
    LEFT JOIN {{ ref('dim_location') }} l
        ON a.borough = l.borough
       AND a.zip = l.zip_code
    LEFT JOIN {{ ref('dim_restaurant') }} r
        ON a.restaurant_name = r.restaurant_name
    LEFT JOIN {{ ref('dim_seating_type') }} s
        ON a.seating_interest_sidewalk = s.seating_interest
       AND CASE
               WHEN LOWER(CAST(a.approved_for_sidewalk_seating AS STRING)) IN ('yes', 'y', 'true') THEN TRUE
               ELSE FALSE
           END = s.approved_for_sidewalk
       AND CASE
               WHEN LOWER(CAST(a.approved_for_roadway_seating AS STRING)) IN ('yes', 'y', 'true') THEN TRUE
               ELSE FALSE
           END = s.approved_for_roadway
)

SELECT *
FROM fact_restaurant_application