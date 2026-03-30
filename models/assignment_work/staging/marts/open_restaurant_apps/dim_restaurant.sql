-- Restaurant dimension for open restaurant seating applications
WITH restaurants AS (
   SELECT DISTINCT
       restaurant_name,
       legal_business_name,
       doing_business_as_dba,
       food_service_establishment,
       business_address AS restaurant_business_address,
       latitude,
       longitude
   FROM {{ ref('stg_nyc_open_restaurant_apps') }}
   WHERE restaurant_name IS NOT NULL
),
restaurant_dimension AS (
   SELECT
       {{ dbt_utils.generate_surrogate_key([
           'restaurant_name',
           'legal_business_name',
           'doing_business_as_dba',
           'food_service_establishment',
           'restaurant_business_address',
           'latitude',
           'longitude'
       ]) }} AS restaurant_key,

       restaurant_name,
       legal_business_name,
       doing_business_as_dba,
       food_service_establishment,
       restaurant_business_address,
       latitude,
       longitude

   FROM restaurants
)

SELECT * FROM restaurant_dimension