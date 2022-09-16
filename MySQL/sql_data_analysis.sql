#Business questions answered using MySQL:
-- EDA
-- 1. Create a database called house_price_regression.
drop database if exists house_price_regression;
CREATE DATABASE house_price_regression;
Use house_price_regression;

-- 2. Create a table house_price_data with the same columns as given in the csv file. 
-- Please make sure you use the correct data types for the columns.
drop table if exists house_price_data;

CREATE TABLE house_price_data (
    house_id VARCHAR(30) NOT NULL,
    `date` DATE,
    bedrooms INT DEFAULT NULL,
    bathrooms FLOAT DEFAULT NULL,
    sqft_living INT DEFAULT NULL,
    sqft_lot INT DEFAULT NULL,
    floors FLOAT DEFAULT NULL,
    waterfront INT DEFAULT NULL,
    `view` INT DEFAULT NULL,
    `condition` INT DEFAULT NULL,
    grade INT DEFAULT NULL,
    sqft_above INT DEFAULT NULL,
    sqft_basement INT DEFAULT NULL,
    yr_built INT,
    yr_renovated INT,
    zipcode INT DEFAULT NULL,
    lat FLOAT,
    `long` FLOAT,
    sqft_living15 INT DEFAULT NULL,
    sqft_lot15 INT DEFAULT NULL,
    price INT DEFAULT NULL
);
-- 3. Import the data from the csv file into the table.
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C:/Users/mahna/Ironhack/Week9/data/regression_data.csv' 
INTO TABLE house_price_data
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';
-- Encountered a bug and solved in following way:
-- check: https://bugs.mysql.com/bug.php?id=91891
-- SHOW GLOBAL VARIABLES LIKE 'local_infile';
-- SET GLOBAL local_infile = ON;
-- used this link: Martin Baxter: https://bugs.mysql.com/bug.php?id=91872

-- 4.Select all the data from table house_price_data to check if the data was imported correctly
SELECT * FROM house_price_regression.house_price_data;

-- 5.Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. 
-- Select all the data from the table to verify if the command worked. Limit your returned results to 10
ALTER TABLE house_price_data DROP date;
SELECT * FROM house_price_data
LIMIT 10;

-- 6. Use sql query to find how many rows of data you have.
SELECT COUNT(*) FROM house_price_data;

-- 7. Now we will try to find the unique values in some of the categorical columns:
-- What are the unique values in the column bedrooms?
SELECT DISTINCT bedrooms
FROM house_price_data;

-- What are the unique values in the column bathrooms?
SELECT DISTINCT bathrooms
FROM house_price_data;

-- What are the unique values in the column floors?
SELECT DISTINCT floors
FROM house_price_data;

-- What are the unique values in the column condition?
SELECT DISTINCT
    `condition`
FROM
    house_price_data;

-- What are the unique values in the column grade?
SELECT DISTINCT
    grade
FROM house_price_data;

-- 8. Arrange the data in a decreasing order by the price of the house. 
-- Return only the IDs of the top 10 most expensive houses in your data.
SELECT house_id, price
FROM house_price_data
ORDER BY price DESC
LIMIT 10;

-- 9.What is the average price of all the properties in your data?
SELECT ROUND(AVG(price), 2)
FROM house_price_data;

-- 10. In this exercise we will use simple group by to check the properties of some of the categorical variables
-- A. What is the average price of the houses grouped by bedrooms? 
-- The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
SELECT bedrooms, ROUND(AVG(price), 2) AS avgprice_fornbedrooms
FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms;

-- B. What is the average sqft_living of the houses grouped by bedrooms? 
-- The returned result should have only two columns, bedrooms and Average of the sqft_living.

SELECT bedrooms, ROUND(avg(sqft_living), 0) AS avgprice_livingsqft
FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms;

-- C. What is the average price of the houses with a waterfront and without a waterfront?
-- The returned result have only two columns, waterfront and Average of the prices.
SELECT waterfront, ROUND(AVG(price), 2) AS pricebywaterfront
FROM house_price_data
GROUP BY waterfront;

-- D. Is there any correlation between the columns condition and grade?

SELECT `condition`, AVG(grade)
FROM house_price_data
GROUP BY `condition`
ORDER BY `condition`;

SELECT grade, AVG(`condition`)
FROM house_price_data
GROUP BY grade
ORDER BY grade;
-- According to these queries no clear pattern or correlation is visible between grade and condition.
-- 11. One of the customers is only interested in the following houses:
-- Number of bedrooms either 3 or 4
-- Bathrooms more than 3
-- One Floor
-- No waterfront
-- Condition should be 3 at least
-- Grade should be 5 at least
-- Price less than 400000
-- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?

SELECT 
    *
FROM
    house_price_data
WHERE
    (bedrooms = 3 OR bedrooms = 4)
		AND floors = 1
        AND (bathrooms > 3)
        AND (waterfront = 0)
        AND (`condition` >= 3)
        AND (grade >= 5)
        AND (price < 400000);
-- Only two options available for the client. house_id: '561000300' and '2817900180'.

-- 12. Your manager wants to find out the list of properties whose prices are twice more than the average 
-- of all the properties in the database. Write a query to show them the list of such properties. 
-- You might need to use a sub query for this problem.
SELECT *
FROM house_price_data
WHERE
    price > (SELECT 
            AVG(price) * 2
        FROM
            house_price_data)
ORDER BY price;

-- 13. Since this is something that the senior management is regularly interested in, create a view of the same query.
drop view if exists price_more_than_twice_the_avg;
CREATE VIEW price_more_than_twice_the_avg AS
    SELECT 
        *
    FROM
        house_price_data
    WHERE
        price > (SELECT 
                AVG(price) * 2
            FROM
                house_price_data)
    ORDER BY price;

-- 14. Most customers are interested in properties with three or four bedrooms. 
-- What is the difference in average prices of the properties with three and four bedrooms?

SELECT 
    (SELECT 
            ROUND(AVG(price), 2)
        FROM
            house_price_data
        WHERE
            bedrooms = 4) - (SELECT 
            ROUND(AVG(price), 2)
        FROM
            house_price_data
        WHERE
            bedrooms = 3) AS avgprice_diff_4_3;
#169288.09$
            
-- 15. What are the different locations where properties are available in your database? (distinct zip codes)
SELECT DISTINCT
    zipcode
FROM
    house_price_data; 

-- 16. Show the list of all the properties that were renovated.
SELECT 
    *
FROM
    house_price_data
WHERE
    yr_renovated != 0
ORDER BY yr_renovated;

-- 17. Provide the details of the property that is the 11th most expensive property in your database.
SELECT *
FROM house_price_data
ORDER BY price DESC
LIMIT 1 OFFSET 10;