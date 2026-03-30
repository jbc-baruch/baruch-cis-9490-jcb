-- Fact table for 311 DOT service requests

WITH service_requests AS (
    SELECT
        request_id,
        created_date,
        closed_date,
        agency,
        agency_name,
        complaint_type,
        descriptor,
        status,
        incident_zip,
        borough,
        incident_address,
        street_name,
        cross_street_1,
        cross_street_2,
        latitude,
        longitude,
        location_type,
        address_type,
        facility_type,
        method_of_submission,
        resolution_description,
        resolution_action_updated_date
    FROM {{ ref('stg_nyc_311_dot') }}
    WHERE request_id IS NOT NULL
),

fact_311_requests AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['request_id']) }} AS request_key,
        s.request_id,

        s.created_date,
        s.closed_date,

        d.date_key AS created_date_key,
        l.location_key,

        s.agency,
        s.agency_name,
        s.complaint_type,
        s.descriptor,
        s.status,

        s.incident_address,
        s.street_name,
        s.cross_street_1,
        s.cross_street_2,

        s.latitude,
        s.longitude,

        s.location_type,
        s.address_type,
        s.facility_type,
        s.method_of_submission,

        s.resolution_description,
        s.resolution_action_updated_date

    FROM service_requests s

    LEFT JOIN {{ ref('dim_date') }} d
        ON CAST(s.created_date AS DATE) = d.full_date

    LEFT JOIN {{ ref('dim_location') }} l
        ON s.borough = l.borough
       AND s.incident_zip = l.zip_code
)

SELECT *
FROM fact_311_requests