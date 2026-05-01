Create database DATATHON2026
Use DATATHON2026
--Create tables: geography, web_traffic, products, promotions, customers, orders, order_items, payments, shipments, reviews, returns, sales, inventory
Select * from [geography]
Select top 100 * from web_traffic
select top 100 * from products
select top 100 * from promotions
select top 100 * from customers
select top 100 * from orders
select top 100 * from order_items
select top 100 * from payments
select top 100 * from shipments
select top 100 * from reviews
select top 100 * from returns
select top 100 * from sales
select top 100 * from inventory



/*Create foreign keys: 
1. customers.zip = geography.zip
2. orders.customer_id =customers.customer_id
3. orders.zip = geography.zip
4. order_items.order_id = orders.order_id
5. order_items.product_id = products.product_id
6. order_items.promo_id = promotions.promo_id
7. payments.order_id = orders.order_id
8. shipments.order_id = orders.order_id
9. reviews.order_id = orders.order_id
10. reviews.product_id = products.product_id
11. reviews.customer_id = customers.customer_id
12. returns.order_id = orders.order_id
13. returns.product_id = products.product_id
14. inventory.product_id = products.product_id

*/
Alter table customers
add constraint FK_customers_geography foreign key (zip) references geography(zip)
--
Alter table orders
add constraint FK_orders_customers foreign key (customer_id) references customers(customer_id),
constraint FK_orders_geography foreign key (zip) references geography(zip)
--
Alter table order_items
add constraint FK_order_items_orders foreign key (order_id) references orders(order_id),
constraint FK_order_items_products foreign key (product_id) references products(product_id),
constraint FK_order_items_promotions foreign key (promo_id) references promotions(promo_id)
--
Alter table payments
add constraint FK_payments_orders foreign key (order_id) references orders(order_id)
--
Alter table shipments
add constraint FK_shipments_orders foreign key (order_id) references orders(order_id)
-- 
Alter table reviews
add constraint FK_reviews_orders foreign key (order_id) references orders(order_id),
constraint FK_reviews_products foreign key (product_id) references products(product_id),
constraint FK_reviews_customers foreign key (customer_id) references customers(customer_id)
--
Alter table returns
add constraint FK_returns_orders foreign key (order_id) references orders(order_id),
constraint FK_returns_products foreign key (product_id) references products(product_id)
--
Alter table inventory
add constraint FK_inventory_products foreign key (product_id) references products(product_id)

--Q1. In customers with more than 1 order, what is the approximate median number of days betwen 2 consecutive orders? (calculated from the orders table)
With OrderIntervals as (
select customer_id, 
datediff(day, lag(order_date) over (partition by customer_id order by order_date),
order_date) as days_between_orders
from orders
)
select top 1 percentile_cont(0.5) within group (order by days_between_orders) over () as median_days
from OrderIntervals
where days_between_orders is not null
-- Answer 144 days
--Q2. What is the segment in products with the highest average profit rate (calculated as (price-cogs)/prices)?
select top 1 segment, avg((price-cogs)/price) as avg_profit_rate
from products
group by segment
order by avg_profit_rate desc
-- Answer: Standard
--Q3. What is the most common return reason for products in the "Streetwear" category?
select top 1 return_reason, count(*) as reason_count
from returns
where product_id in (select product_id from products where category = 'Streetwear')
group by return_reason
order by reason_count desc
--Answer: wrong size
--Q4. In web_traffic, which traffic source has the lowest average bounce rate across all dates it appears?
select top 1 traffic_source, avg(bounce_rate) as avg_bounce_rate
from web_traffic
group by traffic_source
order by avg_bounce_rate asc
--Answer: email_compaign
--Q5. What is the approximate percentage of orders that were applied a promotion (promo_id is not null)?
select 100.0*count(case when promo_id is not null then 1 end)/count(*) as promo_percentage
from order_items
--Answer: 39%
--Q6. In customers, which age group has the highest average order value (calculated as total orders divided by the number of customers in that age group)?
with CustomerOrderValues as(
select age_group, 
count(distinct order_id) as total_orders, 
count(distinct customers.customer_id) as total_customers
from customers left join orders on customers.customer_id = orders.customer_id
where age_group is not null
group by age_group
)
select age_group, 1.0* total_orders/total_customers as avg_order_value
from CustomerOrderValues
order by avg_order_value desc
--Answer: 55+
--Q7. What is the region with the highest total revenue in sales table?
select  region, sum(revenue) as total_revenue
from sales inner join orders on sales.date = orders.order_date
inner join geography on orders.zip = geography.zip
group by region
order by total_revenue desc
--Answer: east
--Q8. In orders, among orders with order_status = 'cancelled', which payment method is used most frequently?
select payment_method, count(*) as method_count
from orders
where order_status = 'cancelled'
group by payment_method
order by method_count desc
--Answer: credit_card
--Q9. In 4 sizes (S, M, L, XL), which size has the higest return rate (calculated as total return orders divided by total orders for that size and )?
With ReturnCounts as (
select size,
count(*) as total_returns
from returns inner join products on returns.product_id = products.product_id
group by size),

OrderCounts as (
select size, 
count(*) as total_orders
from order_items inner join products on order_items.product_id = products.product_id
group by size)

select OrderCounts.size,
1.0 * total_returns/total_orders as return_rate
from OrderCounts inner join ReturnCounts on OrderCounts.Size = ReturnCounts.Size
where OrderCounts.Size in ('S', 'M', 'L', 'XL')
Order by return_rate desc
--Answer: S
--Q10. In payments table, which installments having the highest avarage payment_value on per orders?
With OrderPayments as (
select order_id, installments, sum(payment_value) as total_payment_per_order
from payments
group by order_id, installments)

select installments, 
avg(total_payment_per_order) as avg_payment_per_order
from orderpayments
group by installments
order by avg_payment_per_order desc
--Answee: 6