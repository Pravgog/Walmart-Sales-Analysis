SELECT * FROM walmart.sales_data;

```sql
CREATE TABLE `sales_data` (
  `Invoice ID` varchar (30) not null primary key,
  `Branch` varchar (5) not null,
  `City` varchar (30) not null,
  `Customer type` varchar (30) not null,
  `Gender` varchar (10) not null,
  `Product line` varchar (100) not null,
  `Unit price` decimal(10,2) not null,
  `Quantity` int not null,
  `VAT` float (6,4) not null,
  `Total` decimal (12,4) not null,
  `Date` datetime not null,
  `Time` time not null,
  `Payment_method` varchar(15) not null,
  `cogs` decimal(10,2) not null,
  `gross margin percentage` float(11,9) not null,
  `gross income` decimal(12,4) not null,
  `Rating` float(2,1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------TIME OF THE DAY------------------- 
SELECT TIME,
  CASE
    WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
    WHEN TIME BETWEEN '12:01:00' AND '16:00:00' THEN 'afternoon'
    ELSE 'evening'
  END AS TimeOfDay
FROM sales_data;

ALTER TABLE sales_data ADD COLUMN TimeOfDay varchar(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE sales_data
SET TimeOfDay = 
(CASE
    WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
    WHEN TIME BETWEEN '12:01:00' AND '16:00:00' THEN 'afternoon'
    ELSE 'evening'
  END) ;
--  --------------------DAY NAME-------------------------- 
SELECT date,dayname(DATE
)
FROM sales_data;

ALTER TABLE sales_data ADD COLUMN day_name VARCHAR(20);

UPDATE sales_data 
SET day_name = dayname(date);

-- ------------------------MONTH NAME--------------------------
SELECT DATE,
monthname(DATE)
FROM sales_data;

ALTER TABLE sales_data ADD COLUMN month_name VARCHAR(10);

UPDATE sales_data
SET month_name = monthname(date);

-- --------------------------GENERIC QUESTIONS-----------------------------
-- How many unique cities does the data have?

SELECT distinct(CITY)
FROM SALES_DATA;

-- In which city is each branch?

SELECT CITY,BRANCH
FROM SALES_DATA
group by CITY,BRANCH;

-- ------------------------------PRODUCT_QUESTIONS----------------------------

-- How many unique product lines does the data have?

SELECT count(distinct(`Product line`)) Distinct_product
FROM sales_data;

-- What is the most common payment method?

select Payment_method,count(*)
from sales_data
group by Payment_method;

-- What is the most selling product line?

select `product line`,count(*)
from sales_data
group by `product line`
order by count(*) desc
limit 1;

-- What is the total revenue by month?

select month_name, sum(total) as revenue
from sales_data
group by month_name;

-- What month had the largest COGS?

select month_name,sum(cogs) as total_cogs
from sales_data
group by month_name;

-- What product line had the largest revenue? 

select `product line`,sum(total) as revenue
from sales_data
group by `product line`
order by revenue desc
limit 1;

-- What is the city with the largest revenue?

select city,sum(Quantity) as revenue
from sales_data
group by city
order by revenue desc;

-- What product line had the largest VAT?

select `product line`,sum(vat) as tax
from sales_data
group by `product line`
order by tax desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select `product line`,
case
when total > (select avg(total)from sales_data) then 'good'
else 'bad'
end as review
from sales_data;

-- Which branch sold more products than average product sold?

select branch,sum(quantity) as qty
from sales_data
group by branch
having qty > (select avg(quantity) from sales_data);

-- What is the most common product line by gender?

select gender,`product line`,count(*)
from sales_data
group by gender,`product line`
order by count(*) desc;

-- What is the average rating of each product line?

select `product line`, avg(rating) avg_rating
from sales_data
group by `product line`
order by avg_rating desc;

-- ------------------------------------SALES QUESTIONS----------------------------------

-- Number of sales made in each time of the day per weekday

select TimeOfDay,count(*) sales_made
FROM sales_data
where day_name = 'sunday'
group by TimeofDay;

-- Which of the customer types brings the most revenue?

select `customer type`, sum(total) as revenue
from sales_data
group by `customer type`
order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, avg(vat) tax
from sales_data
group by city
order by tax desc;

-- Which customer type pays the most in VAT?

select `customer type`, avg(vat) tax
from sales_data
group by `customer type`
order by tax desc;

-- ----------------------------------------CUSTOMER QUESTIONS---------------------------------

-- How many unique customer types does the data have?

select distinct(`Customer type`)
from sales_data;

-- How many unique payment methods does the data have?

select count(distinct(Payment_method)) 
from sales_data;

-- What is the most common customer type?

select `customer type`,count(*)
from sales_data
group by `customer type`
order by count(*) desc;

-- Which customer type buys the most?

select `customer type`, sum(quantity) as quantity
from sales_data
group by `customer type`
order by quantity desc;

-- What is the gender of most of the customers?

select gender, count(*)
from sales_data
group by gender;

-- What is the gender distribution per branch?

select gender,branch,count(*)
from sales_data
group by gender,branch
order by branch;

-- Which time of the day do customers give most ratings?

select TimeOfDay,avg(rating) rating
from sales_data
group by TimeOfDay;

-- Which time of the day do customers give most ratings per branch?

select TimeOfDay,branch,count(*)
from sales_data
group by TimeOfDay,branch
order by branch;

-- Which day fo the week has the best avg ratings?

select day_name, avg(rating) as rating
from sales_data
group by day_name
order by rating desc;

-- Which day of the week has the best average ratings per branch?

select day_name,branch, avg(rating) as rating
from sales_data
group by day_name,branch
order by branch asc,Rating desc;

```
