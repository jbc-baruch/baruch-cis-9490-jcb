SELECT
    LENGTH(CAST(zip AS STRING)) AS zip_length,
    zip
FROM {{ source('raw', 'source_nyc_open_restaurant_apps') }}
WHERE objectid IS NOT NULL