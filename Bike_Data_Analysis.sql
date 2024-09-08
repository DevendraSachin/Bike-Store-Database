-- 1. Find the total number of orders placed by each customer.
select c.customer_id, c.first_name, c.last_name, count(o.customer_id) as total_orders
from customers as c 
left join orders as o on c.customer_id = o.customer_id
group by c.customer_id, c.first_name, c.last_name;


-- 2. Calculate the total sales amount (including discounts) for each store.
select s.store_name, sum(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) as total_sales from order_items as oi
join orders as o on o.order_id = oi.order_id
join stores as s on s.store_id = o.store_id
group by s.store_name; 


-- 3. Find the top 5 products with the highest sales amount.
-- select * from products order by rand() limit 10; 
select p.product_id, p.product_name, sum(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) as total_sales from products as p
join order_items as oi on p.product_id = oi.product_id
group by p.product_id, p.product_name
order by total_sales desc limit 5;


-- 4. List all customers who have never placed an order.
select c.customer_id, c.first_name, c.last_name from customers as c
left join orders as o on c.customer_id = o.customer_id
where o.customer_id is null;


-- 5. Find the total number of products available in each category.
select c.category_id, c.category_name, count(p.product_id) as total_products_available from categories as c
left join products as p on p.category_id = c.category_id
group by c.category_id, c.category_name;


-- 6. Find the store that has the highest number of staff members.
select s.store_name, count(st.staff_id) as 'No. of staff available' from stores as s
join staffs as st on s.store_id = st.store_id
group by s.store_name
order by 'No. of staff available' desc limit 1;


-- 7. List the products that are out of stock in all stores.
select p.product_name from products as p
left join stocks s on p.product_id = s.product_id
group by p.product_id, p.product_name
having sum(s.quantity) = 0 or sum(s.quantity) is null;


-- 8. Find the average discount given on products.
select p.product_id, p.product_name, avg(oi.discount)*100 as avg_discount from products p
left join order_items oi on oi.product_id = p.product_id
group by p.product_id, p.product_name;


-- 9. Retrieve all orders that were handled by staff with the title 'Not a Manager'.
select o.order_id, concat(s.first_name, " ", s.last_name) as Emp_name from orders as o
join staffs as s on o.staff_id = s.staff_id
where s.staff_id != s.manager_id;


-- 10. Find all products that have never been ordered.
select p.product_name from products p
left join order_items oi on p.product_id = oi.product_id
where oi.order_id is null;


-- 11. Calculate the total revenue generated per year.
select p.model_year, sum(oi.quantity * (oi.list_price - (oi.list_price * oi.discount))) as total_revenue from products as p
join order_items as oi on oi.product_id = p.product_id
group by p.model_year;


-- 12. Find the average order completion time (difference between order_date and shipped_date).
select round(avg(datediff(shipped_date, order_date))) as avg_completion_time from orders
where shipped_date is not null;


-- 13. List the top 3 customers with the highest number of completed orders.
select c.Customer_id, concat(c.first_name, " " ,c.last_name) as Full_Name, count(order_status) as Completed_orders from customers as c
join orders as o on o.customer_id = c.customer_id
where o.order_status = 4
group by c.customer_id, Full_Name
order by completed_orders desc
limit 3;


-- 14. Find all the orders where the ordered products are from multiple categories.
select o.order_id from orders as o
join order_items as oi on oi.order_id = o.order_id
join products as p on p.product_id = oi.product_id
group by o.order_id
having count(p.category_id)>1;


-- 15.  How many products have a stock quantity less than 5 units in each store.
select s.store_name, count(*) as products_below_threshold from stocks st
join stores s on st.store_id = s.store_id
where st.quantity < 5
group by s.store_name;


-- 16. Find the most profitable product (considering discounts) for each store.
with storeproductprofits as (
    select s.store_name, p.product_name, sum(oi.quantity * (oi.list_price - (oi.list_price * oi.discount / 100))) as total_profit from stores s 
	join orders o on s.store_id = o.store_id 
	join order_items oi on o.order_id = oi.order_id 
	join products p on oi.product_id = p.product_id 
    group by s.store_name, p.product_name
),
maxstoreprofits as (
    select store_name, max(total_profit) as max_total_profit from storeproductprofits
    group by store_name
)
select spp.store_name, spp.product_name, spp.total_profit from storeproductprofits as spp
join maxstoreprofits msp on spp.store_name = msp.store_name and spp.total_profit = msp.max_total_profit;


-- 17. Find the staff member who has handled the most diverse range of products in terms of categories.
select st.first_name, st.last_name, count(distinct p.category_id) as category_count from staffs st
join orders o on st.staff_id = o.staff_id
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by st.staff_id, st.first_name, st.last_name
order by category_count desc limit 1;


-- 18. Identify all customers who have placed orders for products from every available category.
select c.customer_id, c.first_name, c.last_name from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by c.customer_id, c.first_name, c.last_name
having count(distinct p.category_id) = (select count(*) from categories);


-- 19. Find the average number of days it takes for an order to be shipped, segmented by order status.
select o.order_status,
    case 
        when o.order_status = 1 then 'pending'
        when o.order_status = 2 then 'processing'
        when o.order_status = 3 then 'rejected'
        when o.order_status = 4 then 'completed'
        else 'unknown'
    end as status_description,
    avg(datediff(o.shipped_date, o.order_date)) as avg_shipping_days
from orders o
where o.shipped_date is not null
group by o.order_status
limit 0, 1000;


-- 20. Determine which product has contributed the most to total sales revenue over a specific time period (e.g., last year).
select p.product_name, sum(oi.quantity * (oi.list_price - (oi.list_price * oi.discount / 100))) as total_revenue
from products p
join order_items oi on p.product_id = oi.product_id
join orders o on oi.order_id = o.order_id
where o.order_date between curdate() - interval 1 year and curdate()
group by p.product_name
order by total_revenue desc
limit 1;




