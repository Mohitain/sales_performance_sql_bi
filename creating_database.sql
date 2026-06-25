--transaction_id	transaction_date	transaction_time	transaction_qty	store_id	
--store_location	product_id	unit_price	product_category	
--product_type	product_detail

drop table if exists coffee_sales;
create table coffee_sales(
transaction_id int,
transaction_date date,
transaction_time time,
transaction_qty int,
store_id int,
store_location varchar(50),
product_id int,
unit_price numeric(10,2),
product_category varchar(50),
product_type varchar(50),
product_detail varchar(100)
);

select * 
from coffee_sales;

select transaction_date,count(*)
from coffee_sales
group by transaction_date
order by transaction_date asc

--setting date format as 'dmy'
set datestyle = 'iso,dmy';

select column_name,data_type
from information_schema.columns
where table_name = 'coffee_sales';
