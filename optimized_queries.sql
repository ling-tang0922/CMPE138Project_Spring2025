-- Optimized Query #1 by Ling Tang, using the with clause
-- Selecting the Number of Trips Associated from Each Route
-- Sorting from the route with the most amount of trips to the least, take only top 20 

WITH route_trip_counts AS (
  SELECT 
    t.route_id,
    COUNT(*) AS num_trips
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

-- Optimized Query #3 by Min
-- Routes with the Most Stop Appearances, top 20
SELECT 
  r.route_short_name,
  r.route_long_name,
  COUNT(*) AS total_stops
FROM 
  `bigquery-public-data.san_francisco_transit_muni.stop_times` AS st
JOIN 
  `bigquery-public-data.san_francisco_transit_muni.trips` AS t
  ON st.trip_id = CAST(t.trip_id AS INT64)    
JOIN 
  `bigquery-public-data.san_francisco_transit_muni.routes` AS r
  ON t.route_id = r.route_id     
GROUP BY 
  r.route_short_name,
  r.route_long_name
ORDER BY 
  total_stops DESC
LIMIT 20;

-- Optimized Query #4 by Min
-- Routes with Longest Average Trip Duration, top 20
WITH trip_durations AS (
  SELECT
    t.route_id,
    TIME_DIFF(
      TIME(MAX(st.arrival_time)),
      TIME(MIN(st.departure_time)),
      MINUTE
    ) AS trip_duration
  FROM bigquery-public-data.san_francisco_transit_muni.stop_times st
  JOIN bigquery-public-data.san_francisco_transit_muni.trips t
    ON CAST(st.trip_id AS STRING) = CAST(t.trip_id AS STRING)
  GROUP BY t.trip_id, t.route_id
),
route_avg_duration AS (
  SELECT
    route_id,
    AVG(trip_duration) AS avg_trip_duration
  FROM trip_durations
  GROUP BY route_id
)
SELECT
  r.route_short_name,
  r.route_long_name,
  rad.avg_trip_duration
FROM route_avg_duration rad
JOIN bigquery-public-data.san_francisco_transit_muni.routes r
  ON CAST(rad.route_id AS STRING) = r.route_id
ORDER BY rad.avg_trip_duration DESC
LIMIT 20;

-- Optimized Query #5 by Sean Tran
-- Query: Display the number of stop visits associated with each stop.
-- Sorting from the stop with the most visits to the least, taking only the top 20.

WITH stop_visit_counts AS (
  SELECT
    st.stop_id,
    COUNT(st.stop_id) AS stop_visits
  FROM bigquery-public-data.san_francisco_transit_muni.stop_times st
  GROUP BY st.stop_id
)
SELECT
  s.stop_name,
  svc.stop_visits
FROM stop_visit_counts svc
JOIN bigquery-public-data.san_francisco_transit_muni.stops s
  ON CAST(svc.stop_id AS STRING) = s.stop_id
ORDER BY svc.stop_visits DESC
LIMIT 20;

-- Optimized Query #6 by Sean Tran
