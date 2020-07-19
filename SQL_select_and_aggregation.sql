-- loadflights.sql

DROP TABLE IF EXISTS airlines;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS planes;
DROP TABLE IF EXISTS weather;

CREATE TABLE airlines (
  carrier varchar(2) PRIMARY KEY,
  name varchar(30) NOT NULL
  );
  
LOAD DATA INFILE '/Users/Marek/Development/flights/airlines.csv' 
INTO TABLE airlines 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE airports (
  faa char(3),
  name varchar(100),
  lat double precision,
  lon double precision,
  alt integer,
  tz integer,
  dst char(1)
  );
  
LOAD DATA INFILE '/Users/Marek/Development/airports.csv' 
INTO TABLE airports
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE flights (
year integer,
month integer,
day integer,
dep_time integer,
dep_delay integer,
arr_time integer,
arr_delay integer,
carrier char(2),
tailnum char(6),
flight integer,
origin char(3),
dest char(3),
air_time integer,
distance integer,
hour integer,
minute integer
);

LOAD DATA INFILE '/Users/Marek/Development/flights.csv' 
INTO TABLE flights
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(year, month, day, @dep_time, @dep_delay, @arr_time, @arr_delay,
 @carrier, @tailnum, @flight, origin, dest, @air_time, @distance, @hour, @minute)
SET
dep_time = nullif(@dep_time,''),
dep_delay = nullif(@dep_delay,''),
arr_time = nullif(@arr_time,''),
arr_delay = nullif(@arr_delay,''),
carrier = nullif(@carrier,''),
tailnum = nullif(@tailnum,''),
flight = nullif(@flight,''),
air_time = nullif(@air_time,''),
distance = nullif(@distance,''),
hour = dep_time / 100,
minute = dep_time % 100
;

CREATE TABLE planes (
tailnum char(6),
year integer,
type varchar(50),
manufacturer varchar(50),
model varchar(50),
engines integer,
seats integer,
speed integer,
engine varchar(50)
);

LOAD DATA INFILE '/Users/Marek/Development/planes.csv' 
INTO TABLE planes
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(tailnum, @year, type, manufacturer, model, engines, seats, @speed, engine)
SET
year = nullif(@year,''),
speed = nullif(@speed,'')
;

CREATE TABLE weather (
origin char(3),
year integer,
month integer,
day integer,
hour integer,
temp double precision,
dewp double precision,
humid double precision,
wind_dir integer,
wind_speed double precision,
wind_gust double precision,
precip double precision,
pressure double precision,
visib double precision
);

LOAD DATA INFILE '/Users/Marek/Development/weather.csv' 
INTO TABLE weather
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(origin, @year, @month, @day, @hour, @temp, @dewp, @humid, @wind_dir,
@wind_speed, @wind_gust, @precip, @pressure, @visib)
SET
year = nullif(@year,''),
month = nullif(@month,''),
day = nullif(@day,''),
hour = nullif(@hour,''),
temp = nullif(@temp,''),
dewp = nullif(@dewp,''),
humid = nullif(@humid,''),
wind_dir = FORMAT(@wind_dir, 0),
wind_speed = nullif(@wind_speed,''),
wind_gust = nullif(@wind_gust,''),
precip = nullif(@precip,''),
pressure = nullif(@pressure,''),
visib = FORMAT(@visib,0)
;

SET SQL_SAFE_UPDATES = 0;
UPDATE planes SET engine = SUBSTRING(engine, 1, CHAR_LENGTH(engine)-1);

SELECT 'airlines', COUNT(*) FROM airlines
  UNION
SELECT 'airports', COUNT(*) FROM airports
  UNION
SELECT 'flights', COUNT(*) FROM flights
  UNION
SELECT 'planes', COUNT(*) FROM planes
  UNION
SELECT 'weather', COUNT(*) FROM weather;


-- 1. The script below will display a table with destination airport abreviation and a furthest distance number.

SELECT
 'Destination Airport',
MAX(distance) AS 'Furthest Distance'
FROM flights;

-- 2. The script below will display different number of engines and most number of seats for each number of engines.

SELECT  
engines AS 'Number of Engines',
MAX(seats) AS 'Most Number of Seats'
FROM planes
GROUP BY engines;

--  3. Show the total number of flights.

SELECT 
COUNT(*) AS 'Total Number of Flights'
FROM flights;

-- 4. Show the total number of flights by airline (carrier).

SELECT carrier, 
COUNT(*) AS 'Total Number of Flights'
FROM flights
GROUP BY carrier 
ORDER BY COUNT(*);

-- 5. Show all of the airlines, ordered by number of flights in descending order.

SELECT 
COUNT(*)AS 'Number of Flights',
carrier
FROM flights
GROUP BY carrier
ORDER BY COUNT(*) DESC;
  
-- 6. Show only the top 5 airlines, by number of flights, ordered by number of flights in descending order

SELECT flight, 
COUNT(*) AS 'Total Number of Flights'
FROM flights
GROUP BY carrier 
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 7. Show only the top 5 airlines, by number of flights of distance 1,000 miles or greater, ordered by number of
-- flights in descending order.

SELECT flight,
COUNT(*) AS 'Total Number of Flights with Distance Over 1000 Miles'
FROM flights
WHERE distance > 1000
Group BY carrier
Order BY COUNT(*) DESC
LIMIT 5;

-- Create a question that (a) uses data from the flights database, and (b) requires aggregation to answer it, and
-- write down both the question, and the query that answers the question.

-- 8. Show top 10 airlines with most air time ordered by tail number in descending order.

SELECT tailnum AS 'Tail Number',
air_time AS 'Air Time'
FROM flights
GROUP BY air_time DESC 
LIMIT 10;






