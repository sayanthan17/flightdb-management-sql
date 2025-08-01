USE FlightDatabase;

-- 1. Find the total number of flights in the database:
SELECT COUNT(*) AS TotalFlights FROM Flights;

-- 2. Retrieve the list of airlines along with the count of flights for each:
SELECT AIRLINE, COUNT(*) AS FlightCount
FROM Flights
GROUP BY AIRLINE;

-- 3. Get the top 10 airports with the highest number of departures.
SELECT ORIGIN_AIRPORT, COUNT(*) AS DepartureCount
FROM Flights
GROUP BY ORIGIN_AIRPORT
ORDER BY DepartureCount DESC
LIMIT 10;

-- 4. Find the average departure delay and delay components for each airline:
SELECT 
    AIRLINE,
    AVG(DEPARTURE_DELAY) AS AvgDepartureDelay,
    AVG(AIR_SYSTEM_DELAY) AS AvgAirSystemDelay,
    AVG(SECURITY_DELAY) AS AvgSecurityDelay,
    AVG(AIRLINE_DELAY) AS AvgAirlineDelay,
    AVG(LATE_AIRCRAFT_DELAY) AS AvgLateAircraftDelay,
    AVG(WEATHER_DELAY) AS AvgWeatherDelay
FROM Flights
GROUP BY AIRLINE;

-- 5. Identify the flights with the longest elapsed time.
SELECT *
FROM Flights
ORDER BY ELAPSED_TIME DESC
LIMIT 10;

-- 6. Find the average arrival delay for each day of the week.
SELECT DAY_OF_WEEK, AVG(ARRIVAL_DELAY) AS AvgArrivalDelay
FROM Flights
GROUP BY DAY_OF_WEEK;

-- 7. Get the total number of cancelled and diverted flights for each airline.
SELECT AIRLINE, 
       SUM(CANCELLED = 1) AS CancelledFlights,
       SUM(DIVERTED = 1) AS DivertedFlights
FROM Flights
GROUP BY AIRLINE;

-- 8. Identify flights with a departure delay greater than 60 minutes.
SELECT *
FROM Flights
WHERE DEPARTURE_DELAY > 60;

-- 9. Find the flights with the highest air time.
SELECT *
FROM Flights
ORDER BY AIR_TIME DESC
LIMIT 10;

-- 10. Identify airlines that operate in San Francisco
SELECT DISTINCT A.AIRLINE
FROM Flights F
JOIN Airports O ON F.ORIGIN_AIRPORT = O.IATA_CODE
JOIN Airlines A ON F.AIRLINE = A.IATA_CODE
WHERE O.CITY = 'San Francisco';

-- 11. Top 5 airports with the highest average departure delay.
SELECT O.AIRPORT, AVG(F.DEPARTURE_DELAY) AS AvgDepartureDelay
FROM Flights F
JOIN Airports O ON F.ORIGIN_AIRPORT = O.IATA_CODE
GROUP BY O.AIRPORT
ORDER BY AvgDepartureDelay DESC
LIMIT 5;

-- 12. Average arrival delay for flights with a departure delay greater than 30 minutes:
SELECT AVG(ARRIVAL_DELAY) AS AvgArrivalDelay
FROM Flights
WHERE DEPARTURE_DELAY > 30;

-- 13. Airports with the highest and lowest average taxi-out time.
SELECT 
    AIRPORT,
    MAX(CASE WHEN RnkDesc = 1 THEN AvgTaxiOutTime END) AS MaxAvgTaxiOutTime,
    MAX(CASE WHEN RnkAsc = 1 THEN AvgTaxiOutTime END) AS MinAvgTaxiOutTime
FROM (
    SELECT 
        AIRPORT, 
        AVG(TAXI_OUT) AS AvgTaxiOutTime,
        ROW_NUMBER() OVER (ORDER BY AVG(TAXI_OUT) DESC) AS RnkDesc,
        ROW_NUMBER() OVER (ORDER BY AVG(TAXI_OUT) ASC) AS RnkAsc
    FROM Flights
    JOIN Airports ON Flights.ORIGIN_AIRPORT = Airports.IATA_CODE
    GROUP BY AIRPORT
) AS Subquery
WHERE RnkDesc = 1 OR RnkAsc = 1
GROUP BY AIRPORT;

-- 14. Airlines with the least variability in arrival delays (lowest standard deviation).
SELECT AIRLINE, STDDEV(ARRIVAL_DELAY) AS ArrivalDelayVariability
FROM Flights
GROUP BY AIRLINE
ORDER BY ArrivalDelayVariability ASC
LIMIT 5;

-- 15. Identify the busiest day of the week in terms of the total number of flights.
SELECT DAY_OF_WEEK, COUNT(*) AS TotalFlights
FROM Flights
GROUP BY DAY_OF_WEEK
ORDER BY TotalFlights DESC
LIMIT 1;

-- 16. Find the average distance covered by flights departing from each city.
SELECT O.CITY, AVG(F.DISTANCE) AS AvgDistance
FROM Flights F
JOIN Airports O ON F.ORIGIN_AIRPORT = O.IATA_CODE
GROUP BY O.CITY
ORDER BY AvgDistance DESC;

-- 17. Airlines with the highest percentage of on-time arrivals (arrival delay <= 0).
SELECT AIRLINE, COUNT(*) AS OnTimeArrivals
FROM Flights
WHERE ARRIVAL_DELAY <= 0
GROUP BY AIRLINE
ORDER BY OnTimeArrivals DESC;

-- 18. Find the average departure delay during different times of the day:
SELECT 
    CASE 
        WHEN SCHEDULED_DEPARTURE BETWEEN 0 AND 599 THEN 'Late Night'
        WHEN SCHEDULED_DEPARTURE BETWEEN 600 AND 1159 THEN 'Morning'
        WHEN SCHEDULED_DEPARTURE BETWEEN 1200 AND 1759 THEN 'Afternoon'
        WHEN SCHEDULED_DEPARTURE BETWEEN 1800 AND 2359 THEN 'Evening'
    END AS DepartureTimeSlot,
    AVG(DEPARTURE_DELAY) AS AvgDepartureDelay
FROM Flights
GROUP BY DepartureTimeSlot
ORDER BY DepartureTimeSlot;

-- 19. Identify the airports with the longest average taxi-in time.
SELECT AIRPORT, AVG(TAXI_IN) AS AvgTaxiInTime
FROM Flights
JOIN Airports ON Flights.DESTINATION_AIRPORT = Airports.IATA_CODE
GROUP BY AIRPORT
ORDER BY AvgTaxiInTime DESC
LIMIT 5;

-- 20. Airports with the most diverse set of airlines.
SELECT 
    O.AIRPORT AS OriginAirport,
    COUNT(DISTINCT F.AIRLINE) AS UniqueAirlines
FROM Flights F
JOIN Airports O ON F.ORIGIN_AIRPORT = O.IATA_CODE
GROUP BY O.AIRPORT
ORDER BY UniqueAirlines DESC
LIMIT 5;

-- 21. Airports with the highest average delay due to weather.
SELECT 
    O.AIRPORT AS OriginAirport,
    AVG(F.WEATHER_DELAY) AS AvgWeatherDelay
FROM Flights F
JOIN Airports O ON F.ORIGIN_AIRPORT = O.IATA_CODE
GROUP BY O.AIRPORT


ORDER BY AvgWeatherDelay DESC
LIMIT 5;
```
