select o.order_id, o.orders_date, o.delivery_date, o.delivery_person_id, o.product_id, c.first_name, c.last_name, c.email, c.phone , 
c.cust_id, o.cust_id from orders as o
join customers c on c.cust_id = o.cust_id;

select o.order_id, o.orders_date, o.delivery_date, o.delivery_person_id, o.product_id, pr.mrp, pr.product_id, pr.product_id,
o.total_amount_paid,  o.tot_units from orders o 
left join products pr on pr.product_id= o.product_id ;

select o.order_id, o.orders_date, o.delivery_date, o.delivery_person_id, o.product_id, c.first_name, c.last_name, c.email, c.phone , 
c.cust_id,  pr.mrp, o.total_amount_paid  from orders as o
join customers c on c.cust_id = o.cust_id
join products pr on pr.product_id= o.product_id ;


select o.order_id, o.orders_date, o.delivery_date, o.delivery_person_id, o.product_id, c.first_name, c.last_name, c.email, c.phone , 
c.cust_id,  pr.mrp, o.total_amount_paid  from orders as o
join customers c on c.cust_id = o.cust_id
join products pr on pr.product_id= o.product_id 
where mrp < 5000 
and c.first_name like '%P%';

select o.order_id, o.orders_date, o.delivery_date, o.delivery_person_id, o.product_id, c.first_name, c.last_name, c.email, c.phone , 
c.cust_id,  pr.mrp, o.total_amount_paid  from orders as o
join customers c on c.cust_id = o.cust_id
join products pr on pr.product_id= o.product_id 
where mrp < 5000 
and o.total_amount_paid > 6000;


select o.order_id, o.orders_date, o.delivery_date, o.delivery_person_id, o.product_id, c.first_name, c.last_name, c.email, c.phone , 
c.cust_id,  pr.mrp, o.total_amount_paid  from orders as o
join customers c on c.cust_id = o.cust_id
join products pr on pr.product_id= o.product_id 
where mrp < 5000 
and o.delivery_person_id = 1000005;

select cust_id, sum(total_amount_paid) 
from orders group by cust_id ;

select cust_id, sum(total_amount_paid), avg(total_amount_paid), count(order_type) 
from orders group by cust_id ;

select o.cust_id, sum(total_amount_paid), avg(total_amount_paid), count(order_type) 
from orders o join products p on p.product_id = o.product_id
group by o.cust_id ;

select  c.first_name, p.product_name, o.cust_id, count(o.total_amount_paid), sum(o.total_amount_paid) as 'Total Amount'
from orders o 
join products p on p.product_id = o.product_id 
join customers c on c.cust_id = o.cust_id
group by c.first_name, p.product_name, o.cust_id order by c.first_name, p.product_name, o.cust_id desc
limit 10;

select  c.first_name, p.product_name, o.cust_id, count(o.tot_units) as 'Total Units', sum(o.total_amount_paid) as 'Total Amount'
from orders o 
join products p on p.product_id = o.product_id 
join customers c on c.cust_id = o.cust_id
group by c.first_name, p.product_name, o.cust_id order by `Total Units` desc
limit 20 ;

select  c.first_name, p.product_name, o.cust_id, count(o.tot_units) as 'Total Units', sum(o.total_amount_paid) as 'Total Amount'
from orders o 
join products p on p.product_id = o.product_id 
join customers c on c.cust_id = o.cust_id
group by c.first_name, p.product_name, o.cust_id order by  c.first_name, p.product_name, o.cust_id  desc;

 