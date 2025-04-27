 -- Query #1 made by Ling Tang
 -- Objective: Display the number of trips associated with each route. 
 -- Taking only the top 20, sort from the route with the most amount of trips to the least. 
 
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
 
-- Query #2 made by Ling Tang
-- Find the vehicles and their route that stopped at 7th St & Market St.
-- Show the vehicles' next stop after the current stop.

SELECT
 v.vehicle_id,
 v.route_long_name,
 -- s.stop_name
 v.next_stop_name

FROM `bigquery-public-data.san_francisco_transit_muni.vehicle_monitoring` v
JOIN `bigquery-public-data.san_francisco_transit_muni.stop_monitoring` s

ON v.vehicle_id = s.vehicle_id
WHERE s.stop_name = '7th St & Market St'
GROUP BY v.vehicle_id, v.route_long_name, v.next_stop_name
 
 -- Query #3 made by Min
 -- Routes with the Most Stop Appearances, top 20
 SELECT 
  r.route_short_name,
  r.route_long_name,
  COUNT(st.stop_id) AS total_stops
FROM `bigquery-public-data.san_francisco_transit_muni.stop_times` st
JOIN `bigquery-public-data.san_francisco_transit_muni.trips` t
  ON CAST(st.trip_id AS STRING) = CAST(t.trip_id AS STRING)
JOIN `bigquery-public-data.san_francisco_transit_muni.routes` r
  ON CAST(t.route_id AS STRING) = CAST(r.route_id AS STRING)
GROUP BY 
  r.route_short_name,
  r.route_long_name
ORDER BY 
  total_stops DESC
LIMIT 20;
 
 -- Query #4
 
 -- Query #5 made by Sean Tran
 -- Query: Display the number of stop visits associated with each stop.
 -- Sorting from the stop with the most visits to the least, taking only the top 20.

WITH stop_counts AS (
  SELECT
    CAST(st.stop_id AS STRING) AS stop_id,  -- Cast to STRING to match the stops table
    COUNT(st.trip_id) AS num_trips
  FROM 
    `bigquery-public-data.san_francisco_transit_muni.stop_times` st
  GROUP BY 
    st.stop_id
)
SELECT
  s.stop_name,
  sc.num_trips
FROM
  stop_counts sc
JOIN 
  `bigquery-public-data.san_francisco_transit_muni.stops` s
ON
  sc.stop_id = s.stop_id
ORDER BY
  sc.num_trips DESC
LIMIT 20;

 -- Query #6 made by Sean Tran
 -- Query: Display which routes are the busiest with most trips and the direction of each trip
WITH route_direction_counts AS (
  SELECT 
    route_id,
    direction,
    COUNT(trip_id) AS num_trips
  FROM `bigquery-public-data.san_francisco_transit_muni.trips`
  WHERE direction IS NOT NULL
  GROUP BY route_id, direction
)
SELECT 
  r.route_short_name,
  r.route_long_name,
  rd.direction,
  rd.num_trips
FROM route_direction_counts rd
JOIN `bigquery-public-data.san_francisco_transit_muni.routes` r
  ON rd.route_id = r.route_id
ORDER BY rd.num_trips DESC
LIMIT 10;
