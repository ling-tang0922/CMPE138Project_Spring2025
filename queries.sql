-- Query #1
-- Selecting the Number of Trips Associated from Each Route
-- Sorting from the route with the most amount of trips to the least, take only top 20 
SELECT
  r.route_short_name,
  r.route_long_name,
  COUNT(t.trip_id) AS num_trips

FROM `bigquery-public-data.san_francisco_transit_muni.trips` t
JOIN `bigquery-public-data.san_francisco_transit_muni.routes` r

ON t.route_id = r.route_id
GROUP BY r.route_short_name, r.route_long_name
ORDER BY num_trips DESC
LIMIT 20;

-- Query #2

-- Query #3

-- Query #4

-- Query #5

-- Query #6
