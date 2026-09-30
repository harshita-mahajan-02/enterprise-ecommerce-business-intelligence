-- create database ecommerce_db;
-- use ecommerce_db;
/*
Project Overview

Database: Olist E-commerce Dataset

Total Tables Used:
- customer_clean
- order_clean
- order_items_clean
- order_payments_clean
- products_clean
- sellers_clean  
Objective:
To analyze customer behavior, sales performance, seller performance, product trends, and business insights using SQL.*/



/*===============================================================
Business Case 1

Business Question:
How many customers are registered on the e-commerce platform?
===============================================================*/
select count(*) as customer_count from customer_clean;
-- Insight:
-- The platform has 103,886 registered customers.


/*----------------------------------------------------------
Business Case 2

Business Question:
How many orders have been placed on the e-commerce platform?
----------------------------------------------------------*/
select count(*) as orders_count from order_clean;
-- Insight:
-- The platform has 99,441 orders recorded in the dataset.

/*----------------------------------------------------------
Business Case 3

Business Question:
How many sellers are registered on the e-commerce platform?
----------------------------------------------------------*/
select count(*) as seller_count from sellers_clean;
-- Insight:
-- The platform has 3,095 registered sellers.

/*----------------------------------------------------------
Business Case 4

Business Question:
How many products are available on the e-commerce platform?
----------------------------------------------------------*/
select count(*) as products_count from products_clean;
-- Insight:
-- The platform offers 32,951 unique products across various categories.

/*----------------------------------------------------------
Business Case 5

Business Question:
How many product categories are available on the e-commerce platform?
----------------------------------------------------------*/
select count( distinct product_category_name) as category_counts from products_clean;
-- Insight:
-- The platform offers products across 73 unique product categories.

/*----------------------------------------------------------
Business Case 6

Business Question:
How many customers are from each state?

----------------------------------------------------------*/
select customer_state,count(customer_id) customer_count from customer_clean group by customer_state order by customer_count;
-- Insight:
-- Customer distribution is uneven across states, with some states contributing significantly more customers than others.

/*----------------------------------------------------------
Business Case 7

Business Question:
Which are the top 10 states with the highest number of customers?
----------------------------------------------------------*/
select customer_state,count(customer_id) customer_count from customer_clean group by customer_state order by customer_count desc limit 10;

/*----------------------------------------------------------
Business Case 8

Business Question:
Which 10 cities have the highest number of registered customers?
----------------------------------------------------------*/
select customer_city,count(customer_id) customer_count from customer_clean group by customer_city order by customer_count desc limit 10;  
-- Insight:
-- Customer registrations are concentrated in a few major cities,
-- indicating stronger market penetration in urban regions.

/*----------------------------------------------------------
Business Case 9

Business Question:
How many delivered orders are there on the platform?
----------------------------------------------------------*/

select count(order_id) order_count from order_clean where order_status="delivered";
-- Insight:
-- The majority of orders placed on the platform were successfully delivered.

/*----------------------------------------------------------
Business Case 10

Business Question:
How many orders were cancelled?
----------------------------------------------------------*/
select count(order_id) order_count from order_clean where order_status="canceled";
-- Insight:
-- This metric helps monitor the overall order cancellation volume on the platform.

/*----------------------------------------------------------
Business Case 11

Business Question:
How many orders are there for each order status?
----------------------------------------------------------*/
select order_status ,count(order_id) order_count from order_clean group by order_status; 
-- Insight:
-- This analysis helps understand the distribution of orders across different order statuses and can highlight operational performance.

	/*----------------------------------------------------------
Business Case 12

Business Question:
What is the average payment value of all orders?
----------------------------------------------------------*/
select round(avg(payment_value),3) average_payment_value from order_payments_clean;
-- Insight:
-- The average payment value represents the typical amount customers spend per payment transaction.

/*----------------------------------------------------------
Business Case 13

Business Question:
What is the minimum, maximum, and average payment value made by customers?
----------------------------------------------------------*/
select max(payment_value) maximum_payment_value,min(payment_value) minimum_payment_value,round(avg(payment_value),3) average_payment_value from order_payments_clean;
-- Business Insight:
-- The minimum, maximum, and average payment values provide an overview of customer spending behavior.
-- These metrics help identify the typical transaction value as well as the overall payment range on the platform.

/*----------------------------------------------------------
Business Case 14

Business Question:
Which 10 customers have placed the highest number of orders?
----------------------------------------------------------*/
select customer_id,count(*) as order_counts from order_clean group by customer_id order by order_counts desc limit 10;
-- Business Insight:
-- Identifying the top customers by order volume helps the business recognize its most active customers and supports customer loyalty and retention strategies.

/*----------------------------------------------------------
Business Case 15

Business Question:
Which 10 sellers have sold the highest number of products?
----------------------------------------------------------*/
select seller_id ,count(product_id) as product_counts  from order_items_clean group by seller_id order by product_counts desc limit 10;
-- Business Insight:
-- Identifying the top-performing sellers by products sold helps the business recognize its highest contributing sellers and supports performance monitoring and incentive planning.

/*----------------------------------------------------------
Business Case 16

Business Question:
Which 10 products have been sold the most?
----------------------------------------------------------*/
select product_id,count(*) product_count from order_items_clean group by product_id order by product_count desc limit 10;
-- Business Insight:
-- Identifying the most frequently sold products helps the business understand product demand, optimize inventory, and improve sales planning.

/*----------------------------------------------------------
Business Case 17

Business Question:
What are the top 10 product categories with the highest number of products sold?
----------------------------------------------------------*/
select p.product_category_name,count(o.product_id) product_count from order_items_clean o join products_clean p on p.product_id=o.product_id group by product_category_name order by product_count desc limit 10;
-- Business Insight:
-- Identifying the top-selling product categories helps the business understand customer purchasing preferences, optimize inventory planning, prioritize marketing efforts, and focus on the categories that contribute the most to overall sales.

/*----------------------------------------------------------
Business Case 18

Business Question:
Which 10 sellers have generated the highest total sales revenue?
----------------------------------------------------------*/
select seller_id,sum(price) total_sales from order_items_clean group by seller_id order by total_sales desc limit 10;
-- Business Insight:
-- Identifying the highest revenue-generating sellers helps the business recognize top-performing sellers, design incentive programs, strengthen partnerships, and analyze revenue concentration across the marketplace.

/*----------------------------------------------------------
Business Case 19

Business Question:
Which sellers have sold more than 100 products?
----------------------------------------------------------*/
select seller_id,count(product_id) product_count from order_items_clean group by seller_id having product_count>100 order by product_count desc ;
-- Business Insight:
-- Identifying sellers who have sold more than 100 products helps the business recognize consistently high-performing sellers, evaluate seller performance, and support decisions related to incentives and strategic partnerships.

/*----------------------------------------------------------
Business Case 20

Business Question:
List the top 10 customers who have spent the highest total amount on delivered orders.
----------------------------------------------------------*/
select o.customer_id,count(o.order_id) order_count,sum(p.payment_value) total_payment_value from order_clean o join order_payments_clean p on o.order_id=p.order_id where o.order_status="delivered" group by o.customer_id order by total_payment_value  desc limit 10; 
-- Business Insight:
-- Identifying the highest-spending customers helps the business recognize its most valuable customers, design targeted loyalty programs, improve customer retention, and maximize long-term revenue.

/*----------------------------------------------------------
Business Case 21

Business Question:
Classify each order into the following categories based on its payment value:
- Low Value (Below 100)
- Medium Value (100 to 500)
- High Value (Above 500)

Display:
Order ID,
Payment Value,
Order Category
----------------------------------------------------------*/
select order_id,sum(payment_value ) total_payment_value,case
when sum(payment_value )<100 then 'Low Value'
when sum(payment_value )>=100  and sum(payment_value )<=500  then 'Medium Value'
else "High Value"
end order_category from order_payments_clean group by order_id ;
-- Business Insight:
-- Categorizing orders based on payment value helps the business understand purchasing behavior, identify high-value transactions, and design pricing, promotional, and customer segmentation strategies.

/*----------------------------------------------------------
Business Case 22

Business Question:
Show the total sales revenue for each year based on delivered orders.
----------------------------------------------------------*/
select year(o.order_delivered_customer_date) years,sum(p.payment_value) total_sales from order_clean o join order_payments_clean p on o.order_id=p.order_id where o.order_status="delivered" AND order_delivered_customer_date IS NOT NULL group by years order by years;
-- Business Insight:
-- Analyzing yearly sales revenue helps the business identify long-term revenue trends, measure business growth over time, evaluate yearly performance, and support strategic planning and sales forecasting. Orders with missing delivery dates should be excluded because they cannot be assigned to a specific year, ensuring accurate year-wise reporting.


/*----------------------------------------------------------
Business Case 23

Business Question:
Find the top 10 cities that generated the highest total sales revenue.
----------------------------------------------------------*/
select c.customer_city as city,sum(py.payment_value) as sales from customer_clean c join order_clean o on o.customer_id=c.customer_id join order_payments_clean py on py.order_id=o.order_id group by c.customer_city order by sales desc limit 10;
-- Business Insight:
-- Identifying the top revenue-generating cities helps the business understand its strongest markets, prioritize regional marketing efforts, optimize logistics, and support expansion decisions based on customer demand.

/*----------------------------------------------------------
Business Case 24

Business Question:
Find the top 10 sellers who have generated the highest average order value.
----------------------------------------------------------*/
WITH order_values AS
(
    SELECT order_id,
           SUM(payment_value) AS order_value
    FROM order_payments_clean
    GROUP BY order_id
)

SELECT o.seller_id,
       ROUND(AVG(ov.order_value),2) AS average_order_value
FROM order_items_clean o
JOIN order_values ov
ON o.order_id = ov.order_id
GROUP BY o.seller_id
ORDER BY average_order_value DESC
LIMIT 10;
-- Business Insight:
-- Measuring the average order value handled by each seller helps identify sellers associated with higher-value transactions. This can support seller performance evaluation, premium seller identification, targeted incentive programs, and strategic partnership decisions.

/*----------------------------------------------------------
Business Case 25

Business Question:
Find the top 10 customers who have spent the highest total amount on delivered orders.
----------------------------------------------------------*/
with cte1 as
(select order_id,sum(payment_value) sales from order_payments_clean group by order_id) 
select o.customer_id,sum(s.sales) ts from cte1 s join order_clean o on o.order_id=s.order_id  where order_status="delivered" group by customer_id order by ts desc limit 10;
-- Business Insight:
-- Identifying the highest-spending customers helps the business recognize its most valuable customers, design loyalty and retention programs, prioritize personalized marketing campaigns, and maximize long-term customer lifetime value.

/*----------------------------------------------------------
Business Case 26

Business Question:
Find the top 10 product categories with the highest average payment value per order.
----------------------------------------------------------*/
with avg_payment as
(select order_id,sum(payment_value) as payment from order_payments_clean group by order_id)
select p.product_category_name,avg(a.payment) avg_payment_value from products_clean p join order_items_clean o on p.product_id=o.product_id join avg_payment as a on o.order_id=a.order_id group by product_category_name order by avg_payment_value desc limit 10;
-- Business Insight:
-- Calculating the average payment value for each product category helps the business identify premium product categories, understand customer spending patterns, support pricing strategies, and prioritize high-value product segments.

/*----------------------------------------------------------
Business Case 27

Business Question:
Rank all product categories based on their total sales revenue from highest to lowest. Display the category name, total sales revenue, and the rank.
----------------------------------------------------------*/
with cte1 as
(select order_id,sum(payment_value) total_sales from order_payments_clean group by order_id)
select p.product_category_name,sum(c.total_sales) as sales,rank() over(order by sum(c.total_sales)) as ranking  from cte1 c join order_items_clean o on c.order_id=o.order_id join products_clean p on p.product_id=o.product_id group by p.product_category_name order by ranking  ;
-- Business Insight:
-- Ranking product categories by total sales revenue helps the business identify its highest-performing categories, prioritize inventory planning, allocate marketing budgets effectively, and focus on product segments that generate the greatest revenue.
	
/*----------------------------------------------------------
Business Case 28

Business Question:
Find the top 10 customers who have purchased products from the highest number of different product categories.
----------------------------------------------------------*/
SELECT o.customer_id,COUNT(DISTINCT p.product_category_name) AS category_count FROM order_clean o JOIN order_items_clean oi ON o.order_id = oi.order_id JOIN products_clean p ON oi.product_id = p.product_id
GROUP BY o.customer_id ORDER BY category_count DESC LIMIT 10;


/*----------------------------------------------------------
Business Case 29

Business Question:
For each customer state, find the customer who has spent the highest total amount on delivered orders.
----------------------------------------------------------*/
with cte1 as 
(select c.customer_id,c.customer_state, Row_number() over(partition by c.customer_state order by sum(py.payment_value) desc ) as rank_num from customer_clean c join order_clean o on c.customer_id=o.customer_id join
order_payments_clean py on py.order_id=o.order_id where o.order_status="delivered"  group by c.customer_state,c.customer_id )
select * from cte1 where rank_num=1;
-- Business Insight:
-- Identifying the highest-spending customer in each state helps the business recognize regional high-value customers, design location-specific loyalty programs, and support targeted marketing strategies based on customer spending behavior.

/*----------------------------------------------------------
Business Case 30

Business Question:
Find the top 10 customers whose total spending is higher than the average total spending of all customers.
----------------------------------------------------------*/
with cte1 as
(select o.customer_id,sum(p.payment_value) as ts from  order_clean o join order_payments_clean p on p.order_id=o.order_id group by o.customer_id  )
select customer_id from cte1  where ts>(select avg(ts) from cte1)  order by ts desc limit 10 ;
-- Business Insight:
-- Customers whose spending exceeds the average represent high-value customers. Identifying them helps the business focus on retention strategies, personalized promotions, loyalty programs, and increasing customer lifetime value.


