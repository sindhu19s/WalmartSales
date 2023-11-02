# WalmartSales
This project explores the basics of Walmart Sales Data using SQL queries. 

## Basic Information:
- OS : Mac Monterey 12.6.7
- Developement Environment : SQL Workbench version 8.0.27

## Derived fields 
- VAT (Value Added Tax) = 5% * COGS 
- total(gross_sales) = VAT + COGS
- TIME_OF_DAY = (CASE when `time` between "00:00:00" and "12:00:00" then "MORNING"
	   when `time` between "12:01:00" and "17:00:00" then "AFTERNOON"
	   else "EVENING" )
- month_name
- day_name

### Business Questions Answered with Respect to SALES , Customer , etc:
- Number of sales made in each time of the day per weekday?
- Which of the customer types brings the most revenue?
- Which city has the largest tax percent/ VAT (Value Added Tax) ?
- Which customer type pays the most in VAT ?
- How many unique customer types does the data have?
- How many unique payment methods does the data have?
- What is the most common customer type?
- Which customer type buys the most? 
- What is the gender of most of the customers?
- What is the gender distribution per branch?
- Which time of the day do customers give most ratings?
- Which time of the day do customers give most ratings per branch?
-  Which day fo the week has the best avg ratings?
-  Which day of the week has the best average ratings per branch?
-  How many unique cities does the data have?
-  In which city is each branch?
-  How many unique product lines does the data have?
-  What is the most common payment method?
-  What is the most selling product line?
-  What is the total revenue by month? ( COGS= unit_price * quantity sold)
-  Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
-   Which branch sold more products than average product sold?


