---The Following analyse referring to accidents_municipal dataset,
---which consist data about accidents that occur in Israel in the last 5 years.

---Relevant Questions:
---1) Which MUNITYPE has the highest number of accidents and injuries?
---2) Which DISTRICT has the highest number of accidents and injuries?
---3) Which DISTRICT has the highest number of dead, sligh and severe injuries? How many pedestrians were involved in the accidents?
---4) What is the age Distribution regarding the injuries?
---5) How many drivers are involved in one accident (In average)?
---6) What is the vehicle type Distribution regarding the accidents?
---7) How many accidents there are in a square kilometer? 
---8) Which top 10 cities have the most number of accidents and injuries?

SELECT *
FROM Israel_Accidents

UPDATE Israel_Accidents
SET DISTRICT = 'יהודה ושומרון'
WHERE CITY = 'יהודה ושומרון'

UPDATE Israel_Accidents
SET DISTRICT = 'מרכז'
WHERE CITY = 'חוף השרון'

UPDATE Israel_Accidents
SET VEHICLE = MOTORCYCLE+TRUCK+BICYCLE+PRIVATE

SELECT *
FROM Israel_Accidents

---1) Which MUNITYPE has the highest number of accidents and injuries?
SELECT MUNITYPE, SUM(INJTOTAL) AS "Sum Of Injuries",
	   CAST(ROUND(SUM(INJTOTAL)*100/SUM(SUM(INJTOTAL)) OVER (),2) AS varchar)+'%' AS "Injuries Percentage",
	   SUM(SUMACCIDEN) AS "Sum Of Accidents",
	   CAST(ROUND(SUM(SUMACCIDEN)*100/SUM(SUM(SUMACCIDEN)) OVER (),2) AS varchar)+'%' AS "Accidents Percentage",
	   ROUND(SUM(INJTOTAL)/SUM(SUMACCIDEN),2) AS "Total_Injuries/Total_Accidents"
FROM Israel_Accidents
GROUP BY MUNITYPE
ORDER BY 2 DESC

------
--Among the Munitypes, eventhough the Cities has the highest number of injuries (250,043) & accidents (186,735),
--probably because of high density and large populations,The relation between them is the lowest.
--Meaning, in each accident that acure in the City, it is the lowest probability for an injury (1.34 rather than 1.67-1.81 in the other Munitypes).
--That outcome can suggests that the accidents that acure in the cities are less fatal then in other munitypes.
------


---2) Which DISTRICT has the highest number of accidents and injuries?
SELECT DISTRICT, SUM(INJTOTAL) AS "Sum Of Injuries" ,
	   CAST(ROUND(SUM(INJTOTAL)*100/SUM(SUM(INJTOTAL)) OVER (),2) AS varchar)+'%' AS "Injuries Percentage",
	   SUM(SUMACCIDEN) AS "Sum Of Accidents",
	   CAST(ROUND(SUM(SUMACCIDEN)*100/SUM(SUM(SUMACCIDEN)) OVER (),2) AS varchar)+'%' AS "Accidents Percentage",
	   ROUND(SUM(INJTOTAL)/SUM(SUMACCIDEN),2) AS "INJTOTAL/SUMACCIDEN"
FROM Israel_Accidents
GROUP BY DISTRICT
ORDER BY 2 DESC

------
---Regarding the different districts in Israel, the Central District has the biggest number of accidents (23.79% of the entire accidents),
---while the North District has the most Injuries (23.65%).
---Reffering to the Injuries/Accidents relation, once there is an accident,
---Tel Aviv District has the lowest probability for injuries (1.19),
---while the North District & Judea and Samaria has the highest probability for injuries (1.79, 1.76 respectively).
------


---3) Which DISTRICT has the highest number of dead, sligh and severe injuries? How many pedestrians were involved in the accidents?
SELECT DISTRICT, SUM(SLIGH_INJ) AS "Sum Of Sligh_Inj", SUM(SEVER_INJ) AS "Sum Of Sever_Inj",
	   SUM(DEAD) AS "Sum Of Dead", SUM(PEDESTRINJ) AS "Sum Of Pedest_Inj"
FROM Israel_Accidents
GROUP BY DISTRICT
ORDER BY 2 DESC

SELECT DISTRICT, CAST(ROUND(SUM(SLIGH_INJ)*100/SUM(INJTOTAL) ,2) AS varchar) + '%'  AS "Sum Of Sligh_Inj",
				 CAST(ROUND(SUM(SEVER_INJ)*100/SUM(INJTOTAL),2) AS varchar) + '%'  AS "Sum Of Sever_Inj",
				 CAST(ROUND(SUM(DEAD)*100/SUM(INJTOTAL),2) AS varchar) + '%'  AS "Sum Of Dead",
	  CAST(ROUND(SUM(PEDESTRINJ)*100/SUM(INJTOTAL),2) AS varchar) + '%'  AS "Sum Of Pedest_Inj"
FROM Israel_Accidents
GROUP BY DISTRICT
ORDER BY 2 DESC

-----
---Regarding the severity of the Injuries, once there is an accident, Judea and Samaria has the highest probability to Sever Injury or Death (6.38% combined).
---Jerusalem and Tel aviv Districts have the most involvement of Pedestrians as part of the Injuries (15.78%, 11.88% respectively).
---That outcome can also refer to the high density and large population in those districts.
-----


---4) What is the age Distribution regarding the injuries?
SELECT DISTRICT, SUM(INJ0_19)+SUM(INJ20_64)+SUM(INJ65_) AS "Num Of INJTOTAL" ,SUM(INJ0_19) AS "INJ0_19", SUM(INJ20_64) AS "INJ20_64", SUM(INJ65_) AS "INJ65_"
FROM Israel_Accidents
GROUP BY DISTRICT
ORDER BY 2 DESC


SELECT DISTRICT, CAST(ROUND(SUM(INJ0_19)/(SUM(INJ0_19)+SUM(INJ20_64)+SUM(INJ65_))*100,2) AS varchar) + '%' AS "INJ0_19",
				 CAST(ROUND(SUM(INJ20_64)/(SUM(INJ0_19)+SUM(INJ20_64)+SUM(INJ65_))*100,2) AS varchar) + '%' AS INJ20_64,
				 CAST(ROUND(SUM(INJ65_)/(SUM(INJ0_19)+SUM(INJ20_64)+SUM(INJ65_))*100,2) AS varchar) + '%' AS "INJ65_"
FROM Israel_Accidents
GROUP BY DISTRICT
ORDER BY 2 DESC

-----
---Judea and Samaria & the North District have the most involvement of injuries under the age of 20 (20.36%, 20.16% respectively).
---Tel Aviv District is the only district which has more injuries in the ages above 65 years old than under 20 years old (12.03%, 10.28% respectively).
-----


---5) How many drivers are involved in one accident (In average)?
SELECT SUM(SUMACCIDEN) AS "Number of accidents", SUM(TOTDRIVERS) AS "Number of drivers",SUM(TOTDRIVERS)/SUM(SUMACCIDEN) AS "Number of drivers involved in an accident"
FROM Israel_Accidents

SELECT DISTRICT, SUM(SUMACCIDEN) AS "Number of accidents", SUM(TOTDRIVERS) AS "Number of drivers", SUM(TOTDRIVERS)/SUM(SUMACCIDEN) AS "Number of drivers involved in an accident"
FROM Israel_Accidents
GROUP BY DISTRICT
ORDER BY 4 DESC

-----
---In Israel, For each one accident, there are 1.81 drivers.
---There is not a significant difference between the different districts regarding the number of drivers involved in an accident.
---This fact emphasizes the magnitude of the accidents where there is only 1 driver involve.
-----


---6) What is the vehicle type Distribution regarding the accidents?
SELECT DISTRICT, SUM(VEHICLE) AS "VEHICLE", SUM(PRIVATE) AS "PRIVATE", SUM(MOTORCYCLE) AS "MOTORCYCLE", SUM(TRUCK) AS "TRUCK", SUM(BICYCLE) AS "BICYCLE"
FROM Israel_Accidents
GROUP BY DISTRICT
ORDER BY 2 DESC

SELECT DISTRICT, CAST(ROUND(SUM(PRIVATE)/SUM(VEHICLE)*100,2) AS varchar) + '%' AS "PRIVATE",
				 CAST(ROUND(SUM(MOTORCYCLE)/SUM(VEHICLE)*100,2) AS varchar) + '%' AS "MOTORCYCLE",
				 CAST(ROUND(SUM(TRUCK)/SUM(VEHICLE)*100,2) AS varchar) + '%' AS "TRUCK",
				 CAST(ROUND(SUM(BICYCLE)/SUM(VEHICLE)*100,2) AS varchar) + '%' AS "BICYCLE"
FROM Israel_Accidents
GROUP BY DISTRICT
ORDER BY 2 DESC

-----
---Considering the different types of vehicles that took part in the accidents,
---Tel Aviv District has the least involvement of private vehicles (70.61%) in accidents and has the highest involvement of bicycles and motorcycles (26.38% combined).
---For comparison, the second district with high involvement of bicycles and motorcycles is Jerusalem, with 13.38%.
-----


---7) How many accidents there are in a square kilometer? 
SELECT DISTRICT, AVG(ACC_INDEX) AS "Num Of Accidents each 1 Square Kilometer"
FROM Israel_Accidents
GROUP BY DISTRICT
ORDER BY 2 DESC

-----
---In the last 5 years, for each square kilometer, Tel Aviv district has the most number of accidents (222.54).
---Jerusalem district is second with 65.05, and Judea and Samaria is last with 1.17.
---It is shown from the results that in Judea and Samaria there are less accidents, but their outcome are more fatal.
-----


---8) Which top 10 cities have the most number of accidents and injuries?
SELECT Top 10 CITY, SUMACCIDEN AS "Total_Accidents", INJTOTAL AS "Total_Injuries", ROUND(INJTOTAL/SUMACCIDEN,3) AS "Total_Injuries/Total_Accidents"
FROM Israel_Accidents
ORDER BY 2 DESC

-----
---The top 10 Cities in Israel that have the most number of accidents are:
---Tel Aviv-Yafo, Jerusalem, Haifa, Rishon Lezion, Beersheva, Petah Tikva, Judea and Samaria area, Holon, Ashdod And Netanya.
---Eventhough Tel-Aviv is the City with the most number of accidents, among those cities,
---it is the city with least chance to have injuries once there is an accident (1.17).
-----
