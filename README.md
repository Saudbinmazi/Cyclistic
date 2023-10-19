
# Cyclistic | A google case study

![Cyclistic](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/b43f8cbd-3774-4ff1-987e-a969ed8ed545)


In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime. Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.

The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

Data source: [Divvy Data](https://divvybikes-marketing-staging.lyft.net/system-data)





## Business Task
Frame recommendations for marketing strategies to increase annual memberships by using historical available data.

#### Stake Holders
- Director of marketing
- Marketing analytics team
- Executive team

## Data

Data is downloaded from [Divvy Data](https://divvybikes-marketing-staging.lyft.net/system-data) , which is stored in CSV files for a single month and for a complete year 12 files are downloaded.

All files have same column name 
- ride_id
- rideable_type
- started_at
- ended_at
- start_station_name
- start_station_id
- end_station_name
- end_station_id
- start_lat
- start_lng
- end_lat
- end_lng
- member_casual
## Tools used
#### MS SQL server:
SQL is used for Query, data exploration, data cleaning and transformation.

#### Tableau:
Tableau is used for visualization and analysis.
## Data Combining & Exploration

#### Data Combining
12 CSV files are uploaded and combined using [SQL Query](https://github.com/Saudbinmazi/Cyclistic/blob/main/01.%20Cyclistic%20data%20exploration.sql) in a single table named tripdata.

#### Data Exploration
1. How our Table Looks.
```bash
SELECT * FROM tripdata
```
![sql1](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/e71b688d-6330-4584-a87e-0a5ce105e5aa)

2. Checking for null values.

```bash
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
```
![sql2](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/b5d49024-9fd1-43da-aea7-49a53e1e3d8f)

3. Checking for duplicate values using ride_id column as it does not have any null values.
```bash
SELECT COUNT(DISTINCT ride_id) - COUNT( ride_id) Duplicate_rows 
	  FROM tripdata
```
![sql3](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/96e71ea3-94a3-41bb-9357-698683af6f97)

4. Types of Bikes used.
```bash
SELECT rideable_type
	  ,COUNT(rideable_type) Rideable_types 
	FROM tripdata
	GROUP BY rideable_type
```
![sql4](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/36b8b0b4-df8d-46f3-8ca7-efc4f09339f3)

5. Month of trip of rider.
```bash
SELECT * ,DATENAME(month, started_at) month_of_trip 
	FROM tripdata
```
![sql5](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/4f3efe7b-0dec-4a39-9bff-b0f851250e69)

6. Day of the week on which rider used bikes.
```bash

SELECT * ,DATENAME(weekday, started_at) month_of_trip 
	FROM tripdata
```
![sql6](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/80eeddec-b4c1-4d6c-b0be-2ca7148197f4)

7. Length of trip of a rider in minutes.
```bash
SELECT  started_at ,ended_at,DATEDIFF(minute, started_at, ended_at) Trip_Lenght_in_minutes
	FROM tripdata
```
![sql7](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/421b8f7e-a277-4f27-83fe-2efc62d5a80a)

8. Trip length which is less than 1 minute:
 there are total 201,570 rows which have trip length less than 1 minute.
 ```bash
 SELECT started_at
	   ,ended_at
	   ,DATEDIFF(minute, started_at, ended_at)  Trip_Lenght_in_minutes
	FROM tripdata
	WHERE DATEDIFF(minute, started_at, ended_at) <= 1
```
9. Trip length which is greater than a day:
there are total 5,297 rows which have trip length greater than a day.
```bash
SELECT  started_at
	   ,ended_at
	   ,DATEDIFF(minute, started_at, ended_at)  Trip_Lenght_in_minutes
	FROM tripdata
	WHERE DATEDIFF(minute, started_at, ended_at) >= 1440
```
10. Total Number of Trips 
```bash
SELECT  member_casual
	   ,COUNT(member_casual) No_of_trips
	FROM tripdata
	GROUP BY member_casual
```
![sql8](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/86fe9f34-6090-4a95-bdd6-505415a1d6b6)
## Data Cleaning & Transformation

1. Creating a new table for clean data for further processing.

```bash
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
```

2. Adding data in this new table from tripdata table.
```bash
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
```

3. Adding three new columns in our new table for processing and analysis purposes.
```bash
ALTER TABLE clean_tripdata
	ADD  [length_of_trip] VARCHAR(10)
		,[month_of_trip] VARCHAR(10)
		,[day_of_week] VARCHAR(10) 
```

4. Adding data into these three new columns.
```bash
UPDATE clean_tripdata 
	SET 
		 [length_of_trip] = DATEDIFF(MINUTE, started_at, ended_at)
		,[month_of_trip] = DATENAME(MONTH, started_at)
		,[day_of_week] =  DATENAME(WEEKDAY, started_at)
```

5. Our clean data table is now ready for further analysis.
```bash
SELECT * FROM clean_tripdata
```

![sql9](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/f24baf62-2744-4067-a569-6da50c964d93)
## Visualisation & Analysis

#### Insights and Overview of Casual riders data:
![tab1](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/68ecfa01-5f1f-4984-ad97-cef97da7bcfc)


#### Ride Minutes in a year:
Casual Riders' usage increases at the end of spring season and it peaks at the end of summer season, this means from the end of spring season till end of summer is the best time for marketing campaigns for casual riders.
![tab2](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/ce75023b-3105-4461-bb01-7204064ec86c)


#### Total Rides during a week:
Casual Riders' uses bikes more on weekend throughout the year.
![tab3](https://github.com/Saudbinmazi/Cyclistic/assets/141500217/11e0bded-fec1-4c89-a482-a64755e51bf3)


## Recommendations for Marketing
#### Seasonal Membership Discount: 
Offer a discounted annual membership rate for casual riders during the spring and summer seasons. Highlight the potential savings compared to paying per ride.

#### Exclusive Summer Events: 
Host special events, group rides, or themed tours exclusively for annual members during the peak summer season. Make these events memorable and enjoyable to incentivize conversion.

#### Incentivize Early Sign-Ups: 
Offer an additional discount for annual memberships purchased before the end of spring. Create a sense of urgency to encourage quick decisions.

#### Seasonal Challenges and Rewards: 
Organize friendly competitions or challenges during the peak seasons, and offer rewards or recognition for annual members who participate.

#### Early Bird Weekend Access: 
Provide early access to bikes on weekends for annual members, ensuring they have first pick of the best bikes for their rides.

#### Flexible Payment Plans: 
Provide options for monthly or quarterly payments for the annual membership to make it more accessible and less daunting for casual riders.


