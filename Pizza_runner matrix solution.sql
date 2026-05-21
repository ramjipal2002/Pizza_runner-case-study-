select * from pizza_runner.customer_orders
select * from pizza_runner.pizza_names
Select * from Pizza_runner.Pizza_toppings
Select * from Pizza_runner.runner_orders
Select * from Pizza_runner.runners

--1.How many pizzas were ordered.
select count(order_id)as total_pizza_order
from pizza_runner.customer_orders;

--2.How many unique customer orders were made?
Select count(distinct(order_id)) as uniqe_customer_orders
from pizza_runner.customer_orders

--3. How many successful orders were delivered by each runner?
Select runner_id,count(order_id) as sucessfully_delivered
from pizza_runner.runner_orders
where cancellation is null
or cancellation = ''
group by runner_id;

--4. How many of each type of pizza was delivered?
Select o.Pizza_id, count(r.order_id) as sucessfully_delivered
from pizza_runner.customer_orders as o
join pizza_runner.runner_orders as r on o.order_id = r.order_id
where cancellation is null
or cancellation = ''
group by o.pizza_id

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
Select o.customer_id,Pn.Pizza_name, count(*) as Total_order 
from [pizza_runner].[customer_orders] as o
Join [pizza_runner].[pizza_names] as Pn on pn.pizza_id = o.pizza_id
group by  o.customer_id,pn.pizza_name
order by o.customer_id

--6. What was the maximum number of pizzas delivered in a single order?
SELECT MAX(total_pizzas) AS max_pizzas
FROM (
    SELECT o.order_id,
           COUNT(*) AS total_pizzas
    FROM pizza_runner.customer_orders AS o
    JOIN pizza_runner.runner_orders AS r
        ON o.order_id = r.order_id
    WHERE r.cancellation IS NULL
    GROUP BY o.order_id
) AS t;
/*-- 7.For each customer, how many delivered pizzas had at least
1 change and how many had no changes? */
SELECT 
    customer_id,
SUM(
        CASE 
            WHEN exclusions IS NOT NULL 
                 OR extras IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS has_changes,

    SUM(
        CASE 
            WHEN exclusions IS NULL 
                 AND extras IS NULL
            THEN 1
            ELSE 0
        END
    ) AS no_changes

FROM pizza_runner.customer_orders
GROUP BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
with total_pizza_deiverd as
(SELECT 
    customer_id,
SUM( CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1  ELSE 0   END
    ) AS has_changes,

    SUM( CASE WHEN exclusions IS NULL  AND extras IS NULL THEN 1  ELSE 0  END
    ) AS no_changes

FROM pizza_runner.customer_orders
GROUP BY customer_id
)
select sum(has_changes) as total_p_d_both from  total_pizza_deiverd 

select sum (CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1  ELSE 0   END
    ) as total_order_deliverd_with_both  
FROM pizza_runner.customer_orders

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
    DATEPART(HOUR, order_time) AS order_hour,
    COUNT(*) AS total_pizzas
FROM pizza_runner.customer_orders
GROUP BY DATEPART(HOUR, order_time)
ORDER BY order_hour;

--10 What was the volume of orders for each day of the week?
Select datename(weekday,order_time)as each_day_of_the_week,
count (*) as total_orders
from pizza_runner.customer_orders
group by datename(weekday,order_time)
order by each_day_of_the_week