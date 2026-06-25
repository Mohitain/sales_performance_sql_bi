--total_sales ,total_orders,total_qty_sold each day in may and june
select transaction_date,
		sum(transaction_qty*unit_price) as total_sales,
		count(transaction_id) as total_orders,
		sum(transaction_qty) as total_qty_sold
from coffee_sales
where transaction_date between '2023-05-01' and '2023-06-30'
group by transaction_date


--sales_analysis on weekdays and weekends for mont of 'may'
--1 = sunday
--7 = saturday

select case 
		when extract(isodow from transaction_date) in (6,7) then 'Weekend'
		else 'Weekday'
		end as cat,
		concat(round(sum(transaction_qty*unit_price)/1000,2),'K') as total_sales
from coffee_sales
where date_trunc('month',transaction_date) = date '2023-05-01'
group by cat


--total sales analysis for each store for may month

select store_location,sum(transaction_qty*unit_price) as total_sales
from coffee_sales
where date_trunc('month',transaction_date) = date '2023-05-01' 
group by store_location
order by total_sales desc;


--average sales for each day in may 
--and average sales line of may

with total_sales_cte as (
select date_trunc('day',transaction_date)::date as days,
		sum(transaction_qty*unit_price) as total_sales
from coffee_sales
where date_trunc('month',transaction_date) = date '2023-05-01' 
group by date_trunc('day',transaction_date) 
),
avg_sales_cte as (
		select round(avg(total_sales),2) as average_sales
		from total_sales_cte
)
select *,
		case 
			when t.total_sales >a.average_sales then 'Above_average'
			when t.total_sales<a.average_sales then 'Below_average'
			else 'Equal_to_average'
		end as diff
from total_sales_cte t
cross join avg_sales_cte a


--average sales line in may

select round(avg(total_sales),2) as average_sales
from (
select date_trunc('day',transaction_date)::date,
		sum(transaction_qty*unit_price) as total_sales
from coffee_sales
where date_trunc('month',transaction_date)= date '2023-05-01' 
group by date_trunc('day',transaction_date)
)

--total_sales by product_category

select product_category,
		sum(transaction_qty*unit_price) as total_sales 
from coffee_sales
where date_trunc('month',transaction_date)= date '2023-05-01'
group by product_category
order by total_sales desc

--top 10 products by sales
select product_type,
		sum(transaction_qty*unit_price) as total_sales 
from coffee_sales
where date_trunc('month',transaction_date)= date '2023-05-01'
group by product_type
order by total_sales desc
limit 10;