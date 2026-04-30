SELECT

complaint_type,

borough

 FROM {{ source('raw', 'nyc_311_drug_activity') }}

 LIMIT 10