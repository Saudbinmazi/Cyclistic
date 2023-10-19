/* Merging all tables in one single table for easy exploration and analysis */

DROP TABLE IF EXISTS tripdata
CREATE TABLE tripdata
( [ride_id] nvarchar(100)
 ,[rideable_type] nvarchar(100)
 ,[started_at] datetime2
 ,[ended_at] datetime2
 ,[start_station_name] nvarchar(100)
 ,[start_station_id]nvarchar(100)
 ,[end_station_name] nvarchar(100)
 ,[end_station_id] nvarchar(100)
 ,[start_lat] float
 ,[start_lng] float
 ,[end_lat] float
 ,[end_lng] float
 ,[member_casual] nvarchar(100) )

 INSERT INTO tripdata
	SELECT * FROM tripdata_202208
	UNION ALL
	SELECT * FROM tripdata_202209
	UNION ALL
	SELECT * FROM tripdata_202210
	UNION ALL
	SELECT * FROM tripdata_202211
	UNION ALL
	SELECT * FROM tripdata_202212
	UNION ALL
	SELECT * FROM tripdata_202301
	UNION ALL
	SELECT * FROM tripdata_202302
	UNION ALL
	SELECT * FROM tripdata_202303
	UNION ALL
	SELECT * FROM tripdata_202304
	UNION ALL
	SELECT * FROM tripdata_202305
	UNION ALL
	SELECT * FROM tripdata_202306
	UNION ALL
	SELECT * FROM tripdata_202307


/* EXPLORING DATA */

SELECT * 
	FROM tripdata

/* Checking for null values */

SELECT 
	COUNT(*) - COUNT(ride_id) ride_id
   ,COUNT(*) - COUNT(rideable_type) rideable_type
   ,COUNT(*) - COUNT(started_at) started_at
   ,COUNT(*) - COUNT(ended_at) ended_at
   ,COUNT(*) - COUNT(start_station_name) start_station_name
   ,COUNT(*) - COUNT(start_station_id) start_station_id
   ,COUNT(*) - COUNT(end_station_name) end_station_name
   ,COUNT(*) - COUNT(end_station_id) end_station_id
   ,COUNT(*) - COUNT(start_lat) start_lat
   ,COUNT(*) - COUNT(start_lng) start_lng
   ,COUNT(*) - COUNT(end_lat) end_lat
   ,COUNT(*) - COUNT(end_lng) end_lng
   ,COUNT(*) - COUNT(member_casual) member_casual
	FROM tripdata

/* Checking for duplicate rows */

SELECT COUNT(DISTINCT ride_id) - COUNT( ride_id) Duplicate_rows 
	FROM tripdata

/* Rideable type bikes */

SELECT rideable_type
	  ,COUNT(rideable_type) Rideable_types 
	FROM tripdata
	GROUP BY rideable_type


/* Month of trip */

SELECT *
	   ,DATENAME(month, started_at) month_of_trip 
	FROM clean_tripdata

/* Weekday of start of trip */

SELECT *
	   ,DATENAME(weekday, started_at) month_of_trip 
	FROM clean_tripdata


/* Lenght of trip in minutes */

SELECT  started_at
	   ,ended_at
	   ,DATEDIFF(minute, started_at, ended_at)  Trip_Lenght_in_minutes
	FROM tripdata
 
 /* Length of trip less than 1 minute */

SELECT  started_at
	   ,ended_at
	   ,DATEDIFF(minute, started_at, ended_at)  Trip_Lenght_in_minutes
	FROM tripdata
	WHERE DATEDIFF(minute, started_at, ended_at) <= 1

 /* Length of trip greater than 1440 minutes that is 1 day */

SELECT  started_at
	   ,ended_at
	   ,DATEDIFF(minute, started_at, ended_at)  Trip_Lenght_in_minutes
	FROM tripdata
	WHERE DATEDIFF(minute, started_at, ended_at) >= 1440

/* No. of trips */

SELECT  member_casual
	   ,COUNT(member_casual) No_of_trips
	FROM tripdata
	GROUP BY member_casual