 -- Query #1 made by Ling Tang
 -- Objective: Display the number of trips associated with each route. 
 -- Taking only the top 20, sort from the route with the most trips to the least. 
 
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
-- Find distinct vehicles served each route on December 11th 2021.

SELECT
  v.route_id,
  COUNT(DISTINCT v.vehicle_id) AS vehicles_today
FROM
  `bigquery-public-data.san_francisco_transit_muni.stop_monitoring`   s
JOIN
  `bigquery-public-data.san_francisco_transit_muni.vehicle_monitoring` v
  ON v.vehicle_id = s.vehicle_id
WHERE
  s.trip_date = '2021-12-11'
GROUP BY
  v.route_id
ORDER BY
  vehicles_today DESC
LIMIT 20;
 
 -- Query #3 made by Min
 -- Find routes with the most stop appearances in the top 20.
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
 
 -- Query #4 made by Min
 -- Find routes with the longest average trip duration, in the top 20.
SELECT 
  r.route_short_name,
  r.route_long_name,
  avg_durations.avg_trip_duration
FROM (
  SELECT 
    trip_durations.route_id,
    AVG(trip_durations.trip_duration) AS avg_trip_duration
  FROM (
    SELECT 
      t.route_id,
      TIMESTAMP_DIFF(
        TIMESTAMP(CONCAT('2020-01-01 ', MAX(st.arrival_time))),
        TIMESTAMP(CONCAT('2020-01-01 ', MIN(st.departure_time))),
        MINUTE
      ) AS trip_duration
    FROM `bigquery-public-data.san_francisco_transit_muni.stop_times` st
    INNER JOIN `bigquery-public-data.san_francisco_transit_muni.trips` t
      ON CAST(st.trip_id AS STRING) = CAST(t.trip_id AS STRING)
    GROUP BY t.trip_id, t.route_id
  ) AS trip_durations
  GROUP BY trip_durations.route_id
) AS avg_durations
INNER JOIN `bigquery-public-data.san_francisco_transit_muni.routes` r
  ON CAST(avg_durations.route_id AS STRING) = r.route_id
ORDER BY avg_durations.avg_trip_duration DESC
LIMIT 20;

 -- Query #5 made by Sean Tran
 -- Display the number of stop visits associated with each stop.
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
 -- Display which routes are the busiest with the most trips and the direction of each trip.
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
