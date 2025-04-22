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
 
 -- Query #2
 
 -- Query #3
 
 -- Query #4
 
 -- Query #5 made by Sean Tran
 -- Query: Display the number of stop visits associated with each stop.
 -- Sorting from the stop with the most visits to the least, taking only the top 20.

WITH stop_visit_counts AS (
  SELECT
    st.stop_id,
    COUNT(st.stop_id) AS stop_visits
  FROM `bigquery-public-data.san_francisco_transit_muni.stop_times` st
  GROUP BY st.stop_id
)
SELECT
  s.stop_name,
  svc.stop_visits
FROM stop_visit_counts svc
JOIN `bigquery-public-data.san_francisco_transit_muni.stops` s
  ON CAST(svc.stop_id AS STRING) = s.stop_id
ORDER BY svc.stop_visits DESC
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
