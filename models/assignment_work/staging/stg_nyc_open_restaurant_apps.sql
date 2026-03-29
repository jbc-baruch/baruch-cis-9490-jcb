SELECT
    LENGTH(CAST(zip AS STRING)) AS zip_length,
    zip,
    COUNT(*) AS count
 FROM {{ source('raw', 'source_nyc_open_restaurant_apps') }}
WHERE zip IS NOT NULL
  AND LENGTH(CAST(zip AS STRING)) != 5
GROUP BY zip_length, zip
ORDER BY count DESC