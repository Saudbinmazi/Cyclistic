/* DATA CLEANING */

/* Creating a new table for clean data for further processing */

DROP TABLE IF EXISTS clean_tripdata
CREATE TABLE clean_tripdata

(
 [ride_id] nvarchar(100)
,[rideable_type] nvarchar(100)
,[started_at] datetime2 (0)
,[ended_at] datetime2 (0)
,[start_lat] float
,[start_lng] float
,[end_lat] float
,[end_lng] float
,[member_casual] nvarchar(100)
)

/* Insert values in newly created table */

INSERT INTO clean_tripdata
SELECT [ride_id]
	  ,[rideable_type]
	  ,[started_at]
	  ,[ended_at]
	  ,[start_lat]
	  ,[start_lng]
	  ,[end_lat]
	  ,[end_lng]
	  ,[member_casual]
	FROM tripdata
	WHERE [start_lat] IS NOT NULL AND
		  [start_lng] IS NOT NULL AND
		  [end_lat] IS NOT NULL AND
	      [end_lng] IS NOT NULL AND
	      DATEDIFF(MINUTE, started_at, ended_at) > 1 AND DATEDIFF(MINUTE, started_at, ended_at) < 1440


/* Length of trip */

SELECT *
	  ,DATEDIFF(MINUTE, started_at, ended_at) length_of_trip 
	FROM clean_tripdata
	ORDER BY DATEDIFF(MINUTE, started_at, ended_at) 

ALTER TABLE clean_tripdata
	ADD  [length_of_trip] VARCHAR(10)
		,[month_of_trip] VARCHAR(10)
		,[day_of_week] VARCHAR(10) 
	

UPDATE clean_tripdata 
	SET 
		 [length_of_trip] = DATEDIFF(MINUTE, started_at, ended_at)
		,[month_of_trip] = DATENAME(MONTH, started_at)
		,[day_of_week] =  DATENAME(WEEKDAY, started_at)