-- Optimized Query #1 by Ling Tang, using the with clause
-- Selecting the Number of Trips Associated from Each Route
-- Sorting from the route with the most amount of trips to the least, take only top 20 
WITH route_trip_counts AS (
  SELECT 
    t.route_id,
    COUNT(t.trip_id) AS num_trips
  FROM `bigquery-public-data.san_francisco_transit_muni.trips` t
  GROUP BY t.route_id
)
SELECT 
  r.route_short_name,
  r.route_long_name,
  rtc.num_trips
FROM route_trip_counts rtc
JOIN `bigquery-public-data.san_francisco_transit_muni.routes` r
  ON rtc.route_id = r.route_id
ORDER BY rtc.num_trips DESC
LIMIT 20;

-- Optimized Query #2

-- Optimized Query #3

-- Optimized Query #4

-- Optimized Query #5

-- Optimized Query #6
