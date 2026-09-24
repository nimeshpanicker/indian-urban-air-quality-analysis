
CREATE TABLE aqi_health_data (
    city VARCHAR(50),
    aqi INTEGER,
    pm25 NUMERIC(10,3),
    pm10 NUMERIC(10,3),
    no2 NUMERIC(10,3),
    co NUMERIC(10,3),
    so2 NUMERIC(10,3),
    o3 NUMERIC(10,3),
    temperature_c NUMERIC(10,3),
    humidity_pct NUMERIC(10,3),
    wind_speed_kmh NUMERIC(10,3),
    rainfall_mm NUMERIC(10,3),
    pressure_hpa NUMERIC(10,3),
    vehicle_count INTEGER,
    industrial_activity_index NUMERIC(10,3),
    health_impact_score INTEGER
);


SELECT COUNT(*) AS total_rows
FROM aqi_health_data;
SELECT *
FROM aqi_health_data
LIMIT 10;

--1. Dataset row count

SELECT
    COUNT(*) AS total_records
FROM aqi_health_data;

--2. Number of cities

SELECT
    COUNT(DISTINCT city) AS total_cities
FROM aqi_health_data;

--3. Overall AQI summary

SELECT
    ROUND(AVG(aqi), 2) AS avg_aqi,
    MIN(aqi) AS min_aqi,
    MAX(aqi) AS max_aqi,
    ROUND(STDDEV(aqi), 2) AS aqi_stddev
FROM aqi_health_data;

--4. AQI category distribution

SELECT
    CASE
        WHEN aqi BETWEEN 0 AND 50 THEN 'Good'
        WHEN aqi BETWEEN 51 AND 100 THEN 'Satisfactory'
        WHEN aqi BETWEEN 101 AND 200 THEN 'Moderate'
        WHEN aqi BETWEEN 201 AND 300 THEN 'Poor'
        WHEN aqi BETWEEN 301 AND 400 THEN 'Very Poor'
        WHEN aqi BETWEEN 401 AND 500 THEN 'Severe'
        ELSE 'Outside AQI Range'
    END AS aqi_category,
    COUNT(*) AS records,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_records
FROM aqi_health_data
GROUP BY aqi_category
ORDER BY MIN(aqi);

--5. Average AQI by city

SELECT
    city,
    ROUND(AVG(aqi), 2) AS avg_aqi,
    COUNT(*) AS records
FROM aqi_health_data
GROUP BY city
ORDER BY avg_aqi DESC;

--6. Top 10 cities by average AQI

SELECT
    city,
    ROUND(AVG(aqi), 2) AS avg_aqi
FROM aqi_health_data
GROUP BY city
ORDER BY avg_aqi DESC
LIMIT 10;

--7. Bottom 10 cities by average AQI

SELECT
    city,
    ROUND(AVG(aqi), 2) AS avg_aqi
FROM aqi_health_data
GROUP BY city
ORDER BY avg_aqi ASC
LIMIT 10;

--8. Severe AQI observations by city

SELECT
    city,
    COUNT(*) AS severe_records,
    ROUND(100.0 * COUNT(*) /
          SUM(COUNT(*)) OVER (), 2) AS pct_of_all_severe_records
FROM aqi_health_data
WHERE aqi >= 401
GROUP BY city
ORDER BY severe_records DESC;

--9. High-risk AQI records by city
SELECT
    city,
    COUNT(*) AS high_risk_records,
    ROUND(AVG(aqi), 2) AS avg_high_risk_aqi
FROM aqi_health_data
WHERE aqi >= 301
GROUP BY city
ORDER BY high_risk_records DESC;

--10. Share of high-risk observations

SELECT
    COUNT(*) FILTER (WHERE aqi >= 301) AS high_risk_records,
    COUNT(*) AS total_records,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE aqi >= 301)
        / NULLIF(COUNT(*), 0), 2
    ) AS high_risk_pct
FROM aqi_health_data;

--11. Average PM2.5 by city

SELECT
    city,
    ROUND(AVG(pm25), 2) AS avg_pm25
FROM aqi_health_data
GROUP BY city
ORDER BY avg_pm25 DESC;

--12. Average PM10 by city

SELECT
    city,
    ROUND(AVG(pm10), 2) AS avg_pm10
FROM aqi_health_data
GROUP BY city
ORDER BY avg_pm10 DESC;

--13. Average NO2 by city

SELECT
    city,
    ROUND(AVG(no2), 2) AS avg_no2
FROM aqi_health_data
GROUP BY city
ORDER BY avg_no2 DESC;

--14. Average CO by city

SELECT
    city,
    ROUND(AVG(co), 2) AS avg_co
FROM aqi_health_data
GROUP BY city
ORDER BY avg_co DESC;

--15. Average SO2 and O3 by city

SELECT
    city,
    ROUND(AVG(so2), 2) AS avg_so2,
    ROUND(AVG(o3), 2) AS avg_o3
FROM aqi_health_data
GROUP BY city
ORDER BY avg_so2 DESC;

--16. Overall pollutant profile

SELECT
    ROUND(AVG(pm25), 2) AS avg_pm25,
    ROUND(AVG(pm10), 2) AS avg_pm10,
    ROUND(AVG(no2), 2) AS avg_no2,
    ROUND(AVG(co), 2) AS avg_co,
    ROUND(AVG(so2), 2) AS avg_so2,
    ROUND(AVG(o3), 2) AS avg_o3
FROM aqi_health_data;

--17. AQI and pollutant correlations

SELECT
    ROUND(CORR(aqi, pm25)::numeric, 3) AS corr_aqi_pm25,
    ROUND(CORR(aqi, pm10)::numeric, 3) AS corr_aqi_pm10,
    ROUND(CORR(aqi, no2)::numeric, 3) AS corr_aqi_no2,
    ROUND(CORR(aqi, co)::numeric, 3) AS corr_aqi_co,
    ROUND(CORR(aqi, so2)::numeric, 3) AS corr_aqi_so2,
    ROUND(CORR(aqi, o3)::numeric, 3) AS corr_aqi_o3
FROM aqi_health_data;

--18. Vehicle count vs AQI correlation

SELECT
    ROUND(CORR(vehicle_count, aqi)::numeric, 3)
        AS corr_vehicle_count_aqi
FROM aqi_health_data;

--19. Industrial activity vs AQI correlation

SELECT
    ROUND(CORR(industrial_activity_index, aqi)::numeric, 3)
        AS corr_industrial_activity_aqi
FROM aqi_health_data;

--20. Weather variables vs AQI correlation

SELECT
    ROUND(CORR(temperature_c, aqi)::numeric, 3)
        AS corr_temperature_aqi,
    ROUND(CORR(humidity_pct, aqi)::numeric, 3)
        AS corr_humidity_aqi,
    ROUND(CORR(wind_speed_kmh, aqi)::numeric, 3)
        AS corr_wind_speed_aqi,
    ROUND(CORR(rainfall_mm, aqi)::numeric, 3)
        AS corr_rainfall_aqi,
    ROUND(CORR(pressure_hpa, aqi)::numeric, 3)
        AS corr_pressure_aqi
FROM aqi_health_data;

--21. Cities with highest average vehicle count

SELECT
    city,
    ROUND(AVG(vehicle_count), 0) AS avg_vehicle_count,
    ROUND(AVG(aqi), 2) AS avg_aqi
FROM aqi_health_data
GROUP BY city
ORDER BY avg_vehicle_count DESC
LIMIT 10;

--22. Cities with highest industrial activity

SELECT
    city,
    ROUND(AVG(industrial_activity_index), 2) AS avg_industrial_activity,
    ROUND(AVG(aqi), 2) AS avg_aqi
FROM aqi_health_data
GROUP BY city
ORDER BY avg_industrial_activity DESC
LIMIT 10;

--23. Top 10 highest-AQI observations

SELECT
    city,
    aqi,
    ROUND(pm25, 2) AS pm25,
    ROUND(pm10, 2) AS pm10,
    ROUND(no2, 2) AS no2,
    vehicle_count,
    ROUND(industrial_activity_index, 2) AS industrial_activity_index
FROM aqi_health_data
ORDER BY aqi DESC
LIMIT 10;

--24. City AQI variability

SELECT
    city,
    ROUND(AVG(aqi), 2) AS avg_aqi,
    ROUND(STDDEV(aqi), 2) AS aqi_stddev,
    MIN(aqi) AS min_aqi,
    MAX(aqi) AS max_aqi
FROM aqi_health_data
GROUP BY city
ORDER BY aqi_stddev DESC;

--25. Cities above the overall average AQI

WITH overall AS (
    SELECT AVG(aqi) AS avg_aqi
    FROM aqi_health_data
)
SELECT
    d.city,
    ROUND(AVG(d.aqi), 2) AS city_avg_aqi
FROM aqi_health_data d
CROSS JOIN overall o
GROUP BY d.city, o.avg_aqi
HAVING AVG(d.aqi) > o.avg_aqi
ORDER BY city_avg_aqi DESC;

--26. City pollutant and AQI profile

SELECT
    city,
    ROUND(AVG(aqi), 2) AS avg_aqi,
    ROUND(AVG(pm25), 2) AS avg_pm25,
    ROUND(AVG(pm10), 2) AS avg_pm10,
    ROUND(AVG(no2), 2) AS avg_no2,
    ROUND(AVG(co), 2) AS avg_co,
    ROUND(AVG(so2), 2) AS avg_so2,
    ROUND(AVG(o3), 2) AS avg_o3
FROM aqi_health_data
GROUP BY city
ORDER BY avg_aqi DESC;

--27. Health impact score distribution

SELECT
    health_impact_score,
    COUNT(*) AS records,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2
    ) AS pct_of_records
FROM aqi_health_data
GROUP BY health_impact_score
ORDER BY health_impact_score;

--28. Health impact score by city

SELECT
    city,
    ROUND(AVG(health_impact_score), 2) AS avg_health_impact_score,
    ROUND(AVG(aqi), 2) AS avg_aqi
FROM aqi_health_data
GROUP BY city
ORDER BY avg_health_impact_score DESC, avg_aqi DESC;

--29. Create a reusable city summary table

DROP TABLE IF EXISTS city_aqi_summary;
CREATE TABLE city_aqi_summary AS
SELECT
    city,
    COUNT(*) AS records,
    ROUND(AVG(aqi), 2) AS avg_aqi,
    ROUND(STDDEV(aqi), 2) AS aqi_stddev,
    ROUND(AVG(pm25), 2) AS avg_pm25,
    ROUND(AVG(pm10), 2) AS avg_pm10,
    ROUND(AVG(no2), 2) AS avg_no2,
    ROUND(AVG(co), 2) AS avg_co,
    ROUND(AVG(so2), 2) AS avg_so2,
    ROUND(AVG(o3), 2) AS avg_o3,
    ROUND(AVG(vehicle_count), 0) AS avg_vehicle_count,
    ROUND(AVG(industrial_activity_index), 2) AS avg_industrial_activity,
    ROUND(AVG(health_impact_score), 2) AS avg_health_impact_score
FROM aqi_health_data
GROUP BY city;
SELECT *
FROM city_aqi_summary
ORDER BY avg_aqi DESC;

--30. Create an AQI category summary table

DROP TABLE IF EXISTS aqi_category_summary;
CREATE TABLE aqi_category_summary AS
SELECT
    CASE
        WHEN aqi BETWEEN 0 AND 50 THEN 'Good'
        WHEN aqi BETWEEN 51 AND 100 THEN 'Satisfactory'
        WHEN aqi BETWEEN 101 AND 200 THEN 'Moderate'
        WHEN aqi BETWEEN 201 AND 300 THEN 'Poor'
        WHEN aqi BETWEEN 301 AND 400 THEN 'Very Poor'
        WHEN aqi BETWEEN 401 AND 500 THEN 'Severe'
        ELSE 'Outside AQI Range'
    END AS aqi_category,
    COUNT(*) AS records,
    ROUND(AVG(aqi), 2) AS avg_aqi,
    ROUND(AVG(pm25), 2) AS avg_pm25,
    ROUND(AVG(pm10), 2) AS avg_pm10,
    ROUND(AVG(no2), 2) AS avg_no2,
    ROUND(AVG(health_impact_score), 2) AS avg_health_impact_score
FROM aqi_health_data
GROUP BY aqi_category;
SELECT *
FROM aqi_category_summary
ORDER BY CASE aqi_category
    WHEN 'Good' THEN 1
    WHEN 'Satisfactory' THEN 2
    WHEN 'Moderate' THEN 3
    WHEN 'Poor' THEN 4
    WHEN 'Very Poor' THEN 5
    WHEN 'Severe' THEN 6
    ELSE 7
END;
