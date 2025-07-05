-- Q1. What is the total amount each customer spent at the restaurant

SELECT sales.customer_id, sum(menu.price) as total_amount_spent
FROM `definivitve-bigquery-expertise.8week_challenge.sales` sales 
inner join `definivitve-bigquery-expertise.8week_challenge.menu` menu
on sales.product_id = menu.product_id
group by sales.customer_id;


-- How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) as visit_frequency
FROM `definivitve-bigquery-expertise.8week_challenge.sales`
group by customer_id;



-- What was the first item from the menu purchased by each customer?
With first_order_cte as (
  select sales.customer_id as customer_id, 
          sales.order_date as order_date, 
          menu.product_name as product_name,
row_number() over(partition by sales.customer_id order by sales.order_date) as first_order
FROM `definivitve-bigquery-expertise.8week_challenge.sales` sales
inner join `definivitve-bigquery-expertise.8week_challenge.menu` menu
on sales.product_id = menu.product_id
)
select customer_id, product_name 
from first_order_cte
where first_order =1
order by customer_id
;


-- What is the most purchased item on the menu and how many times was it purchased by all customers?
with max_frequency_items as(
select 
  menu.product_name as product_name,
  count(*) as purchased_time
from `definivitve-bigquery-expertise.8week_challenge.sales` sales
inner join `definivitve-bigquery-expertise.8week_challenge.menu` menu
on sales.product_id = menu.product_id
group by menu.product_name
),
max_pruchased_time as(
  select max(purchased_time) as max_freqeuncy
  from max_frequency_items 
) 
select product_name, purchased_time 
from max_frequency_items
inner join max_pruchased_time
on max_frequency_items.purchased_time = max_pruchased_time.max_freqeuncy
;


-- Which item was most popular for each customer
with item_frequency as(
select sales.customer_id as customer_id, menu.product_name as product_name, count(*) as frequency
from `definivitve-bigquery-expertise.8week_challenge.sales` sales
inner join `definivitve-bigquery-expertise.8week_challenge.menu` menu
on sales.product_id = menu.product_id
group by 1,2
)
select customer_id,product_name, frequency
from item_frequency
;
