create database PizzaSales;
use `pizzasales`;
select * from pizzas;

create table orders(order_id integer primary key not null, order_date date not null, order_time time not null);
select * from orders;

create table order_details(order_details_id integer not null primary key, order_id integer not null, pizza_id text not null, quantity integer not null);

-- -Q.1--Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_Orders
FROM
    orders;

-- -Q.2--Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(od.quantity * p.price), 0) AS Total_Revenue_for_pizza_sales
FROM
    order_details od
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id;
    
    
-- -Q.3--Identify the highest-priced pizza.

SELECT 
    pt.name, p.price
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- -Q.4--Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(od.order_details_id) AS Most_Commen_pizza_size
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY Most_commen_pizza_size DESC limit 1;


-- -Q.5---List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name, SUM(od.quantity) AS Top_most_oredered_pizza
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Top_most_oredered_pizza DESC
LIMIT 5;

-- --Q.6--Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(od.quantity) AS Total_quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY Total_quantity DESC;

-- --Q.7--Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS Hours, COUNT(order_id) AS Order_By_Hour
FROM
    orders
GROUP BY Hours
ORDER BY Order_by_hour DESC;

-- --Q.8---Join relevant tables to find the category-wise distribution of pizzas. 

SELECT 
    category, COUNT(name) AS Total_pizzas
FROM
    pizza_types
GROUP BY category;


-- --Q.9--Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    AVG(Avg_Pizzas_Ordered_per_day)
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS Avg_Pizzas_Ordered_per_day
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS order_quantity;
    
    
-- --Q.10--Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name, ROUND(SUM(p.price * od.quantity), 0) AS Revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;


-- --Q.11--Calculate the percentage contribution of each pizza type to total revenue. 

SELECT 
    pt.category,
    (SUM(p.price * od.quantity) / (SELECT 
            ROUND(SUM(od.quantity * p.price), 0) AS Total_Revenue_for_pizza_sales
        FROM
            order_details od
                JOIN
            pizzas p ON p.pizza_id = od.pizza_id) * 100) AS revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY category
ORDER BY revenue DESC;


-- --Q.12 ----Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over(order by order_date) from 
(select o.order_date, sum(p.price*od.quantity) as revenue from orders o join order_details od on o.order_id = od.order_id join 
pizzas p on od.pizza_id = p.pizza_id group by o.order_date) as sales; 


-- --Q.13--Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, revenue from (select category, name, revenue,rank() over(partition by category order by revenue desc) as rn from
(select pt.category, pt.name, sum(p.price*(od.quantity)) as revenue from  pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
    group by pt.category, pt.name) as a) as b where rn<= 3;
    group by pt.category, pt.name) as a) as b where rn<= 3;
 