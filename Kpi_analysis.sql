--Sales_analysis
--Total sales for each respective month?
select to_char(transaction_date,'YYYY-MM') as month,
		sum(transaction_qty*unit_price)
from coffee_sales
group by to_char(transaction_date,'YYYY-MM');

--month on month increase or decrease in sales,diff in sales bw selected and prev_month

with sales as(
select to_char(transaction_date,'YYYY-MM') as month,
		sum(transaction_qty*unit_price) as total_sales,
		lag(sum(transaction_qty*unit_price)) 
			over(order by to_char(transaction_date,'YYYY-MM')) prev_month_sales
from coffee_sales
group by to_char(transaction_date,'YYYY-MM')
)
select *,
	total_sales-prev_month_sales as diff,
	round((total_sales-prev_month_sales)/total_sales*100,2) as growth,
	case 
		when total_sales-prev_month_sales>0 then 'Increase' 
		when total_sales-prev_month_sales<0 then 'decrease'
		end as bin
from sales

--Orders Analysis
--total_number of orders each month,
--month on month increase/decrese in orders,
--diff in orders of selected month and prev_month.
with total_orders as(
		select date_trunc('month',transaction_date)::date as month,
			 count(*) as total_orders
		from coffee_sales
		group by date_trunc('month',transaction_date)
),
growth_cte as(
select *,
	 lag(total_orders) over(order by month) as prev_month_orders,
	 round(
	 	(total_orders-lag(total_orders) over(order by month))::numeric/
		  lag(total_orders) over(order by month)*100,2
		) as growth
from total_orders
)
select *,
	case 
		when growth>0 then 'Increase'
		when growth<0 then 'Decrease'
	end as growth_bin
from growth_cte

--total_quantity_sold_analysis

--total_number of qty sold each month,
--month on month increase/decrease in no.of qty sold
--diff in no. of qty sold of selected month and prev_month

with total_qty as (
select date_trunc('month',transaction_date)::date as month,
		sum(transaction_qty) as total_quantity
from coffee_sales
group by date_trunc('month',transaction_date)
),
growth_cte as (
select *,
		lag(total_quantity) over(order by month) prev_month_qty
from total_qty
),
bin_cte as (
select *,
		total_quantity-prev_month_qty as diff,
		round(
			(total_quantity-prev_month_qty)::numeric/prev_month_qty*100,2
			)growth
from growth_cte
)
select *,
		case 
			when growth>0 then 'Increase'
			when growth<0 then 'Decrease'
			else 'No_change'
		end as bin
from bin_cte 