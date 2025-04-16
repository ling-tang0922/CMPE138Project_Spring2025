-- Query #1 optimized made by Ling Tang
-- Objective: Display the number of trips associated with each route. 
-- Taking only the top 20, sort from the route with the most amount of trips to the least. 

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

-- Query #2

-- Query #3

-- Query #4

-- Query #5

-- Query #6
