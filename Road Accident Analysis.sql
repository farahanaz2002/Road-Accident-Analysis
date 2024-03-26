SELECT * FROM dbo.road_accident

/*---------------------PRIMATY KPI'S --------------------------------------------------------------*/
/* for casualties in total*/
SELECT SUM(number_of_casualties) AS Casualties FROM dbo.road_accident

/* for current year casualties we can use sum of casualties with respect to year of accident date as 2022*/
SELECT SUM(number_of_casualties) AS CY_Casualties FROM dbo.road_accident
WHERE Year(accident_date)='2022' 

/*for road surface you can use logical operator And with road surface condition*/
SELECT SUM(number_of_casualties) AS CY_Casualties FROM dbo.road_accident
WHERE Year(accident_date)='2022' AND road_surface_conditions='Dry'

/*for total accidents*/
SELECT COUNT(DISTINCT accident_index) AS Accidents FROM dbo.road_accident


/* for current year accidents */
SELECT COUNT(DISTINCT accident_index) AS CY_Accidents FROM dbo.road_accident
WHERE YEAR(accident_date)='2022'

/*for current year casualties -where it is fatal*/
SELECT SUM(number_of_casualties) AS CY_Casualties FROM dbo.road_accident
WHERE Year(accident_date)='2022' AND accident_severity='Fatal'

/*for  casualties -where it is fatal*/
SELECT SUM(number_of_casualties) AS Casualties FROM dbo.road_accident
WHERE   accident_severity='Fatal'

/* for current year  casualties -where it is serious*/
SELECT SUM(number_of_casualties) AS CY_Casualties  FROM dbo.road_accident
WHERE YEAR(accident_date)='2022' AND accident_severity='Serious'

/* for   casualties -where it is serious*/
SELECT SUM(number_of_casualties) AS Casualties  FROM dbo.road_accident
WHERE accident_severity='Serious'

/* for current year  casualties -where it is slight*/
SELECT SUM(number_of_casualties) AS CY_Casualties  FROM dbo.road_accident
WHERE YEAR(accident_date)='2022' AND accident_severity='Slight'

/* for   casualties -where it is slight*/
SELECT SUM(number_of_casualties) AS Casualties  FROM dbo.road_accident
WHERE accident_severity='Slight'


/*for percentage difference ----------------------------*/
/*------SLIGHT----*/
SELECT CAST(SUM(number_of_casualties) AS decimal(10,2))*100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM dbo.road_accident ) AS PCT FROM dbo.road_accident
WHERE accident_severity='Slight'


/*------SERIOUS----*/
SELECT CAST(SUM(number_of_casualties) AS decimal(10,2))*100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM dbo.road_accident ) AS PCT FROM dbo.road_accident
WHERE accident_severity='Serious'

/*----FATAL--------*/
SELECT CAST(SUM(number_of_casualties) AS decimal(10,2))*100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM dbo.road_accident ) AS PCT FROM dbo.road_accident
WHERE accident_severity='Fatal'

/*---------------------SECONDARY KPI'S --------------------------------------------------------------*/

SELECT 
	CASE 
			WHEN vehicle_type IN ('Agricultural vehicle') 
			THEN 'Agricultural'
			WHEN vehicle_type IN ('Car','Taxi/Private hire car')
			THEN 'Cars'
			WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc')
			THEN 'Bike'
			WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under')
			THEN 'Van'
			WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)')
			THEN 'Bus'
			Else 'other'
			End AS Vehicle_group,
		SUM(number_of_casualties) AS CY_Casualties
		FROM dbo.road_accident
		WHERE YEAR(accident_date)='2022'
	GROUP BY 
		CASE 
			WHEN vehicle_type IN ('Agricultural vehicle') 
			THEN 'Agricultural'
			WHEN vehicle_type IN ('Car','Taxi/Private hire car')
			THEN 'Cars'
			WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc')
			THEN 'Bike'
			WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under')
			THEN 'Van'
			WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)')
			THEN 'Bus'
			Else 'other'
			END

/*TOP 10 location by casualties */
SELECT TOP 10 local_authority,SUM(number_of_casualties) as Casualties from dbo.road_accident
group by local_authority
order by Casualties desc


/* for not just current but all years casualties by vehicle_type*/
SELECT 
	CASE 
			WHEN vehicle_type IN ('Agricultural vehicle') 
			THEN 'Agricultural'
			WHEN vehicle_type IN ('Car','Taxi/Private hire car')
			THEN 'Cars'
			WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc')
			THEN 'Bike'
			WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under')
			THEN 'Van'
			WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)')
			THEN 'Bus'
			Else 'other'
			End AS Vehicle_group,
		SUM(number_of_casualties) AS CY_Casualties
		FROM dbo.road_accident
		
	GROUP BY 
		CASE 
			WHEN vehicle_type IN ('Agricultural vehicle') 
			THEN 'Agricultural'
			WHEN vehicle_type IN ('Car','Taxi/Private hire car')
			THEN 'Cars'
			WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc')
			THEN 'Bike'
			WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under')
			THEN 'Van'
			WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)')
			THEN 'Bus'
			Else 'other'
			END

/* current year  vs pervious year monthly trends*/.
SELECT DATENAME(month,accident_date) AS Month_Name, SUM (number_of_casualties) AS CY_Casualties from dbo.road_accident
WHERE YEAR(accident_date)='2022'
GROUP BY  DATENAME(month,accident_date) 
ORDER BY CY_Casualties DESC

/* for pervious year -2021*/
SELECT DATENAME(month,accident_date) AS Month_Name, SUM (number_of_casualties) AS CY_Casualties from dbo.road_accident
WHERE YEAR(accident_date)='2021'
GROUP BY  DATENAME(month,accident_date) 
ORDER BY CY_Casualties DESC

/*Casualties by Road Type*/
SELECT road_type ,SUM(number_of_casualties) AS CY_Casualties FROM dbo.road_accident
WHERE YEAR(accident_date)='2022'
GROUP BY road_type
order by CY_Casualties DESC

/*urban vs rural current year*/
SELECT urban_or_rural_area,CAST(SUM(number_of_casualties) AS DECIMAL(10,2))*100/
(SELECT CAST(SUM(number_of_casualties)AS DECIMAL(10,2))FROM dbo.road_accident
WHERE YEAR(accident_date)='2022')
AS PCT_Casualties from dbo.road_accident
WHERE YEAR(accident_date)='2022'
GROUP BY urban_or_rural_area
ORDER BY PCT_Casualties DESC

SELECT urban_or_rural_area,CAST(SUM(number_of_casualties) AS DECIMAL(10,2))*100/
(SELECT CAST(SUM(number_of_casualties)AS DECIMAL(10,2))FROM dbo.road_accident
)
AS PCT_Casualties from dbo.road_accident
GROUP BY urban_or_rural_area
ORDER BY PCT_Casualties DESC		

/* for light_conditions*/
SELECT  
	CASE 
	WHEN light_conditions IN ('Darkness - lighting unknown','Darkness - lights lit','Darkness - lights unlit'+'Darkness - no lighting')
	THEN 'Dark'
	WHEN light_conditions IN ('Daylight') THEN 'DAY'
	END AS light_condition_group,
	CAST(SUM(number_of_casualties)*100 AS DECIMAL(10,2))/
		(SELECT  
				CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM 
	 dbo.road_accident  WHERE YEAR(accident_date)='2022')FROM dbo.road_accident
	 WHERE YEAR(accident_date)='2022'
GROUP BY 
	CASE 
	WHEN light_conditions IN ('Darkness - lighting unknown','Darkness - lights lit','Darkness - lights unlit'+'Darkness - no lighting')
	THEN 'Dark'
	WHEN light_conditions IN ('Daylight') THEN 'DAY'
	END 


		
		


			