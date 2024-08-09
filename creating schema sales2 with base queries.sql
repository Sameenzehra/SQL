create database sales2;
USE sales2;
 CREATE TABLE orders(order_id INT PRIMARY KEY ,
	order_type VARCHAR(255) ,
	cust_id INT,
	order_date VARCHAR(10),
	delivery_date VARCHAR(10),
	tot_units INT,
	displayed_selling_price_per_unit INT,
	total_amount_paid INT,
	product_id INT,	
    delivery_person_id INT,
	payment_type VARCHAR(255),
	delivery_pincode INT );

 SELECT * FROM sales2.orders; 
Alter TABLE orders CHANGE order_date orders_date Date;
Alter TABLE orders CHANGE delivery_date delivery_date Date;
select * from orders;

 
CREATE TABLE customers(
    cust_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    phone BIGINT,
    primary_pincode INT,
    gender VARCHAR(50),
    dob DATE,
    joining_date DATE
    );
    SELECT * FROM sales2.customers;


CREATE TABLE delivery_person(
    delivery_person_id INT PRIMARY KEY, 
    f_name VARCHAR(255),
     pincode INT,
     joining_date DATE
);
SELECT * FROM delivery_person; 

CREATE TABLE pincode(
pincode INT PRIMARY KEY,
city VARCHAR(255),
state VARCHAR(255)
);
SELECT * FROM pincode;

CREATE TABLE products(
product_id INT PRIMARY KEY,
product_name VARCHAR(255),
brand VARCHAR(255),	
category VARCHAR(255),
procurement_cost_per_unit INT,
mrp INT
);
SELECT * FROM products;

SELECT * FROM sales2.orders;
select * from orders 
where payment_type = 'cash' order by tot_units;

select * from customers
where gender = 'male' and year(joining_date) = 2015
order by cust_id , dob desc;

select * from delivery_person
where f_name like 'R%';

select * from delivery_person
where f_name like '%R%';


select * from orders;
select order_id, cust_id, tot_units, displayed_selling_price_per_unit, total_amount_paid, 
			case  		when total_amount_paid < 0 then 'Loss'
						when total_amount_paid  < 15000 then 'Under 15k'
						when total_amount_paid  < 50000 then 'Under 50K'
						when total_amount_paid  > 50000 and total_amount_paid < 100000 then 'Under 100k'
						when total_amount_paid  > 100000 and total_amount_paid < 500000 then 'Under 500k'
					else 'More then 500k'
			end as 'amount_category' 
from orders order by total_amount_paid  ;

select order_id, cust_id, tot_units, displayed_selling_price_per_unit, total_amount_paid, 
			case  		when total_amount_paid < 0 then 'Loss'
						when total_amount_paid  < 15000 then 'Under 15k'
						when total_amount_paid  < 50000 then 'Under 50K'
						when total_amount_paid  > 50000 and total_amount_paid < 100000 then 'Under 100k'
						when total_amount_paid  > 100000 and total_amount_paid < 500000 then 'Under 500k'
					else 'More then 500k'
			end as 'amount_category' 
from orders order by total_amount_paid desc  ;



 