
 
 select gender, count(*) from customers group by gender;
 
 # Q1. How many customers do not have DOB information available?
 select count(*) from customers where dob is null;
 
 
 # 2. How many customers are there in each pincode and gender combination?
 select primary_pincode, gender, count(cust_id) from customers 
 group by primary_pincode, gender order by  gender;
 
# 3. Print product name and mrp for products which have more than 50000 MRP?
select product_name, mrp from products 
where mrp > 50000;

 # 4. How many delivery personal are there in each pincode
 select count(delivery_person_id), pincode from delivery_person group by pincode;
 
 /* 5. For each Pin code, print the count of orders, sum of total amount paid, average amount paid, maximum amount paid,
 minimum amount paid for the transactions which were paid by 'cash'. 
Take only 'buy' order types
*/

select delivery_pincode , count(order_id) as 'Order_Count', sum(total_amount_paid)as "Total_Amount" , 
avg(total_amount_paid) as 'Avg_Total_Amount',
max(total_amount_paid) as 'Max_Total_paid', 
min(total_amount_paid) as 'Min_Total_paid' 
from orders
where order_type = 'buy' 
and payment_type = 'cash'
group by delivery_pincode 
order by `Total_Amount` desc;

/*
Q6. For each delivery_person_id, print the count of orders and 
total amount paid for product_id = 12350 or 12348 and total units > 8. 
Sort the output by total amount paid in descending order. Take only 'buy' order types
*/

select delivery_person_id, 
count(order_id) as 'order_count' , 
sum(total_amount_paid) as 'total_amount' 
from orders 
where product_id in (12350 ,12348) 
and tot_units > 8 
and order_type = 'buy'
group by delivery_person_id 
order by 'total_amount' desc;
 
 # Q7. Print the Full names (first name plus last name) for customers that have email on "gmail.com"?
 select * from customers;
 select concat(first_name, " " ,last_name) as name from customers  
 where email like '%gmail.com%';
 
 # Q8. How many orders had #units between 1-3, 4-6 and 7+? Take only 'buy' order types
 
select 
	
case     
when tot_units <= 3 then 'units 1-3' 
when tot_units >= 4 and tot_units <= 6 then 'units 4-6' 
else  '7+'
end as cat, 
count(order_id) from orders
where order_type = 'buy'
group by cat
order by cat;

# Q9. Which pincode has average amount paid more than 150,000? Take only 'buy' order types

select delivery_pincode, avg(total_amount_paid) as "average_total" 
from orders
where order_type = 'buy' 
group by delivery_pincode 
having `average_total` > 150000;

/* Q10. Create following columns from order_dim data -

order_date
Order day
Order month
Order year */

select orders_date, 
 SUBSTR(orders_date, 9, 2) AS order_day,
 SUBSTR(orders_date, 6, 2) AS order_month,
 SUBSTR(orders_date, 1, 4) AS order_year
 from orders
 where order_type="buy";
 
 /* Q11. How many total orders were there in each month and how many of them were returned? Add a column for return rate too.
return rate = (100.0 * total return orders) / total buy orders
Hint: You will need to combine SUM() with CASE WHEN
*/

with cte as
 (
 select substr(orders_date, 6,2) as mon,
 sum(case when order_type="return" then 1 else 0 end) as Total_Returns,
 sum(case when order_type="buy" then 1 else 0 end) as Total_buys
 from orders
 group by mon)
 select *, round((total_returns/total_buys)*100,1) as Return_Rate from cte
 order by return_rate desc;
 
 # Q12. How many units have been sold by each brand? Also get total returned units for each brand.
 
 select pr.brand , sum(case when order_type = 'buy' then o.tot_units end) as 'Total sale', 
 sum(case when order_type = 'return' then o.tot_units end) as 'Total returns' from products pr
 join orders o on o.product_id = pr.product_id
 group by pr.brand;
 
# Q13. How many distinct customers and delivery boys are there in each state?

select p.state, count(distinct c.cust_id) as 'customer', count(distinct  dp.delivery_person_id) as 'delivery_boy' 
from customers c inner join pincode p 
on p.pincode = c.primary_pincode
join delivery_person dp 
on dp.pincode = p.pincode
group by p.state ;

/* Q14. For every customer, print how many total units were ordered, how many units were 
ordered from their primary_pincode and how many were ordered not from the primary_pincode. 
Also calulate the percentage of total units which were ordered from 
primary_pincode(remember to multiply the numerator by 100.0). Sort by the percentage column in descending order.
*/ 
select * from customers;

select c.cust_id,  sum(o.tot_units) as 'total_units' ,
sum(case when c.primary_pincode = o.delivery_pincode then o.tot_units else 0 end) as same_city , 
sum(case when c.primary_pincode != o.delivery_pincode then o.tot_units else 0 end) as other_city,
(sum(case when c.primary_pincode = o.delivery_pincode then o.tot_units else 0 end)*100) / sum(o.tot_units)  as percentage
from customers as c
inner join orders o on o.cust_id = c.cust_id
group by c.cust_id 
order by percentage desc;


/* Task 15 
 For each product name, print the sum of number of units, total amount paid, 
 total displayed selling price, total mrp of these units, and finally the net discount from selling price 
 (i.e. 100.0 - 100.0 * total amount paid / total displayed selling price) 
 AND the net discount from mrp (i.e. 100.0 - 100.0 * total amount paid / total mrp)
*/


 with cte as
 (
 select pr.product_name, 
 sum(o.tot_units) as units, 
 sum(o.total_amount_paid) as Total_Amount_Paid,
 sum(o.tot_units*o.displayed_selling_price_per_unit) as Total_Display_Price,
 sum(o.tot_units*pr.mrp) as Total_MRP 
 from products pr left join orders o
 on pr.product_id = o.product_id
 group by pr.product_name
 )
 select *, 100-((total_amount_paid/total_display_price)*100) as Net_SP_discount,
 100-((total_amount_paid/total_mrp)*100) as Net_MRP_discount from cte;
 
 /* Task 16
 For every order_id (exclude returns), get the product name and calculate the discount 
 percentage from selling price. Sort by highest discount and print only
 those rows where discount percentage was above 10.10%.
 */
 
 select o.order_id, pr.product_name,
 round((((o.tot_units*o.displayed_selling_price_per_unit)- o.total_amount_paid )/( o.tot_units*o.displayed_selling_price_per_unit))*100,2) 
 as 'discount_percent'
 from orders o inner join products pr 
 on pr.product_id = o.product_id
 where order_type = 'buy'
 and round((((o.tot_units*o.displayed_selling_price_per_unit)- o.total_amount_paid )/( o.tot_units*o.displayed_selling_price_per_unit))*100,2) >= 10.10
 order by discount_percent desc;
 
 /* Task 17
Using the per unit procurement cost in product_dim, find which product category has made the most profit in both absolute amount and percentage
Absolute Profit = Total Amt Sold - Total Procurement Cost
Percentage Profit = 100.0 * Total Amt Sold / Total Procurement Cost - 100.0 
*/

with cte as
( 
select pr.category as 'cat', sum(o.tot_units) as 'total_units', sum(o.tot_units*procurement_cost_per_unit) as 'total_cost', sum(o.total_amount_paid) as 'revenue' 
from products pr inner join orders o  
on o.product_id = pr.product_id
group by pr.category
)
select cat, revenue-total_cost as abs_profit, 100-((total_cost/revenue)*100) as percent_profit from cte;

/* Task 18
For every delivery person(use their name), print the total number of order ids (exclude returns) 
by month in seperate columns i.e. there should be one row for each delivery_person_id and 12 columns for every month in the year
*/
with cte as
(
select d.f_name as rider, o.order_id, month(o.delivery_date) as 'delivery_month'
from delivery_person d join orders o
on o.delivery_person_id = d.delivery_person_id 
where order_type = 'buy'

)
select rider,
 sum(case when delivery_month = 1 then 1 else 0 end) as january,
 sum(case when delivery_month = 2 then 1 else 0 end) as feburary,
 sum(case when delivery_month = 3 then 1 else 0 end) as march,
 sum(case when delivery_month = 4 then 1 else 0 end) as april,
 sum(case when delivery_month = 5 then 1 else 0 end) as may,
 sum(case when delivery_month = 6 then 1 else 0 end) as june,
 sum(case when delivery_month = 7 then 1 else 0 end) as july,
 sum(case when delivery_month = 8 then 1 else 0 end) as august,
 sum(case when delivery_month = 9 then 1 else 0 end) as september,
 sum(case when delivery_month = 10 then 1 else 0 end) as october,
 sum(case when delivery_month = 11 then 1 else 0 end) as november,
 sum(case when delivery_month = 12 then 1 else 0 end) as december
 from cte
 group by rider
 order by rider; 
 

 