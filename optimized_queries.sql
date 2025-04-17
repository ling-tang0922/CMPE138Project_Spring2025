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

-- Optimized Query #5 by Sean Tran
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

-- Optimized Query #6 by Sean Tran
