-- Create database
CREATE DATABASE if not exists walmartSales;
-- USE DATABASE
USE walmartSales;
-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

SELECT * FROM sales;

-- Feature ENgineering ------------------------------  --
--  TIME OF DAY , day_name , month_name , VAT = 5% of cogs 

ALTER TABLE sales 
ADD TIME_OF_DAY varchar(15),
ADD month_name varchar(15),
ADD day_name varchar(15)
;

UPDATE sales 
set TIME_OF_DAY = ( case when `time` between "00:00:00" and "12:00:00" then "MORNING"
	   when `time` between "12:01:00" and "17:00:00" then "AFTERNOON"
	   else "EVENING"
	   END),
month_name= monthname(date),
day_name = DAYNAME(date)
;    
 /*  SELECT time,date,
 	 ( case when `time` between "00:00:00" and "12:00:00" then "MORNING"
	   when `time` between "12:01:00" and "17:00:00" then "AFTERNOON"
	   else "EVENING"
	   END
	 ) AS TIME_OF_DAY,
	 monthname(date) as month_name,
     DAYNAME(date) as day_name
	from sales; */
    
ALTER TABLE sales
ADD vat decimal(10,2) not null;

UPDATE sales 
set vat= 0.05 * cogs;
COMMIT ;

-- ------------------------------------------------------ --
-- 1) How many unique cities does the data have?
select distinct(city) from sales; -- 3 cities
-- 2) In which city is each branch?
SELECT 
	DISTINCT city, branch
FROM sales;
-- ------------------------------------------------------ --
-- ------------------------------------------------------ --
-- How many unique product lines does the data have?
select count(distinct(product_line)) from sales;
select distinct(product_line) from sales;
-- What is the most common payment method?
SELECT distinct PAYMENT , count(*) FROM sales
group by 1 
order by 2 desc;
-- What is the most selling product line?
select product_line , sum(quantity) from sales
group by 1 
order by 2 desc
LIMIT 1;
-- What is the total revenue by month? ( COGS= unit_price * quantity sold)
select month_name , sum(cogs) from sales
group by 1 
order by 1;
-- What product line had the largest revenue? (VAT value added tax is not added in revenue) 
select product_line , sum(cogs) from sales
group by 1 
order by 2 desc
LIMIT 1;
-- What is the city with the largest revenue?
select city , sum(cogs) from sales
group by 1 
order by 2  desc
LIMIT 1;
-- What product line had the largest VAT?
select product_line , sum(vat) from sales
group by 1 
order by 2 desc 
 limit 1;
 -- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT
    product_line,
    cogs,
    CASE
        WHEN cogs > (SELECT AVG(cogs) FROM sales) THEN 'Good'
        ELSE 'Bad'
    END AS sales_quality
FROM
    sales;
    
-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender? 
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY 1, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
select product_line , avg(rating)
from sales 
group by 1 ;

-- SALES ------
-- Number of sales made in each time of the day per weekday

SELECT day_name , count(quantity) 
from sales group by 1 
order by 1;
 
-- Which of the customer types brings the most revenue? --
select customer_type , sum(cogs) as revenue
from sales group by 1 
order by revenue;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select * from sales;

SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;
 
 -- Which customer type pays the most in VAT? 
 select customer_type , MAX(vat) as vt from sales group by 1 order by 2 desc;
 
-- How many unique customer types does the data have? 
select distinct(customer_type) from sales; 

-- How many unique payment methods does the data have?
select distinct(payment) from sales; 

-- What is the most common customer type? 
select customer_type , count(customer_type) as tp  
from sales group by 1 order by 2 desc;
 
-- Which customer type buys the most? 
select customer_type , sum( quantity) 
from sales group by 1 
order by 2 desc;

 -- What is the gender of most of the customers?
 select gender,customer_type ,count(gender)
from sales group by 1 , 2
order by 2 desc;
 
-- What is the gender distribution per branch?
select branch,gender,count(gender) 
from sales group by 1 , 2
order by 2,1 desc;

-- Which time of the day do customers give most ratings?
select time_of_day ,count(rating) from sales
group by 1 
order by 2 desc ;

-- Which time of the day do customers give most ratings per branch?
 select time_of_day ,branch, count(rating) from sales
group by 1,2
order by 2 desc ;

-- Which day fo the week has the best avg ratings?
 select day_name , AVG(rating) 
from sales
group by 1 
order by 2;

-- Which day of the week has the best average ratings per branch?
select day_name ,branch, AVG(rating) 
from sales
group by 1 , 2
order by 2;
