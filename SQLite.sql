CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

--Exploratory Data Analysis

--Check the number of unique apps in both apple store and apple store description tables

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined

--check for missing values in key fields

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc IS NULL

--Find Number of Apps for genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

--Get an overview of apps ratings

SELECT min(user_rating) AS MinRating,
       max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore

--Get the distribution of app prices

SELECT
      (price / 2) *2 as PriceBinStart,
      (price / 2) *2 +2 as PriceBinEnd,
      count(*) as NumApps
from AppleStore

GROUP by PriceBinStart
order by PriceBinStart

**DATA ANALYSIS**

--Determine whether paid apps have more rating than free apps

SELECT CASE
           WHEn price > 0 then 'paid'
           else 'free'
       end as App_type,
       avg(user_rating) AS Avg_rating
from AppleStore
group by App_type

--Check if apps with more supporting languages have higher ratings

select CASE
           when lang_num < 10 then '<10 languages'
           when lang_num between 10 and 30 then '10-30 languages'
           else '>30 languages'
       end as language_bucket,
       avg(user_rating) as Avg_Rating
from AppleStore
GROUP BY language_bucket
order by Avg_rating desc

--Check genres with low rating
           
 select prime_genre,
        avg(user_rating) as Avg_Rating
 from AppleStore
 GROUP BY prime_genre
 ORDER BY Avg_Rating ASC
 limit 10
 
 --check if there is any correlation bwetween app description length and user rating
 
 select case
            when length(b.app_desc) < 500 then 'short'
            when length(b.app_desc) between 500 and 1000 then 'medium'
            else 'long'
        end as description_length_bucket,
        avg(a.user_rating) as average_rating
        
from 
     AppleStore as a     
join
     appleStore_description_combined as b
ON
     a.id = b.id
     
group by description_length_bucket
order by average_rating desc

--Check the top rated app for each genre

select
      prime_genre,
      track_name,
      user_rating
from  (
       select 
       prime_genre,
       track_name,
       user_rating,
       RANK() OVER(PARTITION by prime_genre order by user_rating desc, rating_count_tot desc) as rank
       FROM
       AppleStore
      ) AS a 
WHERE
a.rank = 1
     
     
 

