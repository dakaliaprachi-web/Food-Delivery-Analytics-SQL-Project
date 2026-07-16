show databases;

CREATE DATABASE food_delivery_analytics;
use food_delivery_analytics;

# show all tables
show tables;
select * from customers;


# see columns of all tables at once
#See PKs and FKs
select table_name,
       column_name,
       column_key,
        is_nullable,
       data_type
from information_schema.columns
where table_schema='fd_system'
order by table_name;


#for understanding relationships
show create table customers;
show create table delivery_partner;
show create table menu;
show create table orders;
show create table order_items;

/* ==================================================
   DATA INSPECTION
================================================== */
SELECT * FROM customers LIMIT 5;
SELECT * FROM restaurant LIMIT 5;
SELECT * FROM menu LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM payments LIMIT 5;
SELECT * FROM deliveries LIMIT 5;


/* ==================================================
   DATA QUALITY CHECKS
================================================== */

SELECT count(*) FROM customers;
SELECT count(*) FROM restaurant ;
SELECT count(*) FROM menu ;
SELECT count(*) FROM orders ;
SELECT count(*) FROM order_items ;
SELECT count(*) FROM payments ;
SELECT count(*) FROM deliveries ;
SELECT count(*) FROM reviews ;
SELECT count(*) FROM delivery_partner ;

/* ==========================================
       NULL VALUE CHECKS
========================================== */

-- Customers
SELECT COUNT(*) AS null_phone
FROM customers
WHERE phone IS NULL;

SELECT COUNT(*) AS null_address
FROM customers
WHERE address IS NULL;

-- Restaurants
SELECT COUNT(*) AS null_rating
FROM restaurant
WHERE rating IS NULL;


SELECT COUNT(*) AS null_address
FROM restaurant
WHERE address IS NULL;

-- Menu
SELECT COUNT(*) AS null_price
FROM menu
WHERE price IS NULL;

SELECT COUNT(*) AS null_category
FROM menu
WHERE category IS NULL;

-- Orders
SELECT COUNT(*) AS null_order_date
FROM orders
WHERE order_date IS NULL;

-- Payments
SELECT COUNT(*) AS null_amount
FROM payments
WHERE amount IS NULL;

SELECT COUNT(*) AS null_payment_method
FROM payments
WHERE payment_method IS NULL;

SELECT COUNT(*) AS null_payment_status
FROM payments
WHERE payment_status IS NULL;

-- Deliveries
SELECT COUNT(*) AS null_delivery_status
FROM deliveries
WHERE delivery_status IS NULL;

SELECT COUNT(*) AS null_delivery_time
FROM deliveries
WHERE delivery_time IS NULL;

-- Reviews
SELECT COUNT(*) AS null_rating
FROM reviews
WHERE rating IS NULL;

SELECT COUNT(*) AS null_review_date
FROM reviews
WHERE review_date IS NULL;

/* ==========================================
       DUPLICATE CHECKS
========================================== */

-- Customers
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Restaurants
SELECT restaurant_id, COUNT(*)
FROM restaurant
GROUP BY restaurant_id
HAVING COUNT(*) > 1;

-- Menu Items
SELECT item_id, COUNT(*)
FROM menu
GROUP BY item_id
HAVING COUNT(*) > 1;

-- Orders
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Payments
SELECT payment_id, COUNT(*)
FROM payments
GROUP BY payment_id
HAVING COUNT(*) > 1;

-- Deliveries
SELECT delivery_id, COUNT(*)
FROM deliveries
GROUP BY delivery_id
HAVING COUNT(*) > 1;

-- Delivery Partners
SELECT partner_id, COUNT(*)
FROM delivery_partner
GROUP BY partner_id
HAVING COUNT(*) > 1;

-- Reviews
SELECT review_id, COUNT(*)
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

/* ==================================================
            RELATIONSHIP VALIDATION
================================================== */

-- Orders → Customers
SELECT *
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Orders → Restaurant
SELECT *
FROM orders o
LEFT JOIN restaurant r
ON o.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL;

-- Menu → Restaurant
SELECT *
FROM menu m
LEFT JOIN restaurant r
ON m.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL;

-- Order_Items → Orders
SELECT *
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Order_Items → Menu
SELECT *
FROM order_items oi
LEFT JOIN menu m
ON oi.item_id = m.item_id
WHERE m.item_id IS NULL;

-- Payments → Orders
SELECT *
FROM payments p
LEFT JOIN orders o
ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Deliveries → Orders
SELECT *
FROM deliveries d
LEFT JOIN orders o
ON d.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Deliveries → Delivery_Partner
SELECT *
FROM deliveries d
LEFT JOIN delivery_partner dp
ON d.partner_id = dp.partner_id
WHERE dp.partner_id IS NULL;

-- Reviews → Customers
SELECT *
FROM reviews rv
LEFT JOIN customers c
ON rv.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Reviews → Restaurant
SELECT *
FROM reviews rv
LEFT JOIN restaurant r
ON rv.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL;

/* ==================================================
                CUSTOMER ANALYSIS
================================================== */
# How many customers are registered and how many have actually placed orders?
select
(select count(*) from customers) as total_customers,
count(distinct customer_id) as active_customers from orders;

#Which customers signed up but never placed an order?
select name  
from customers c left join orders o
on c.customer_id=o.customer_id 
where o.customer_id is null;

# How many orders has each customer placed?
select customer_id , count(customer_id) as total_orders
from orders 
group by customer_id  
order by total_orders desc;

#Who generated the highest revenue?
#Top 10 Customers by Spending
SELECT 
    c.customer_id,
    c.name AS customer_name,
    SUM(oi.quantity * m.price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments p
    ON o.order_id = p.order_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu m
    ON oi.item_id = m.item_id
WHERE p.payment_status = 'success'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 10;



#Average Order Value per customer(AOV)

SELECT
    c.customer_id,
    c.name,
    ROUND(
        SUM(oi.quantity * m.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu m
    ON oi.item_id = m.item_id
GROUP BY c.customer_id, c.name
ORDER BY avg_order_value DESC;

# Repeat vs one time customers
 SELECT customer_type,
COUNT(*) AS customer_count
FROM
(
SELECT customer_id,
CASE
WHEN COUNT(*) > 1 THEN 'Repeat Customer'
ELSE 'One-Time Customer'
END AS customer_type
FROM orders
GROUP BY customer_id
) t
GROUP BY customer_type;



#Top Restaurants by Revenue
-- Top Restaurants by Revenue

SELECT
    r.restaurant_id,
    r.name AS restaurant_name,
    SUM(oi.quantity * m.price) AS total_revenue
FROM restaurant r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu m
    ON oi.item_id = m.item_id
JOIN payments p
    ON o.order_id = p.order_id
WHERE p.payment_status = 'success'
GROUP BY r.restaurant_id, r.name
ORDER BY total_revenue DESC;

#Top Restaurants by Order Volume
select o.restaurant_id,name,count(distinct o.order_id) total_orders 
from restaurant r join orders o 
on r.restaurant_id=o.restaurant_id
group by o.restaurant_id,name
order by total_orders desc;



#Restaurants Above Average Revenue

SELECT
    r.restaurant_id,
    r.name AS restaurant_name,
    SUM(oi.quantity * m.price) AS revenue
FROM restaurant r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu m
    ON oi.item_id = m.item_id
GROUP BY r.restaurant_id, r.name
HAVING revenue >
(
    SELECT AVG(restaurant_revenue)
    FROM
    (
        SELECT
            SUM(oi.quantity * m.price) AS restaurant_revenue
        FROM restaurant r
        JOIN orders o
            ON r.restaurant_id = o.restaurant_id
        JOIN order_items oi
            ON o.order_id = oi.order_id
        JOIN menu m
            ON oi.item_id = m.item_id
        GROUP BY r.restaurant_id
    ) t
)
ORDER BY revenue DESC;

#Revenue Contribution % by Restaurant
SELECT
    r.name AS restaurant_name,
    ROUND(SUM(oi.quantity * m.price), 2) AS restaurant_revenue,
    ROUND(
        (SUM(oi.quantity * m.price) * 100.0) /
        (SELECT SUM(oi2.quantity * m2.price)
         FROM order_items oi2
         JOIN menu m2
         ON oi2.item_id = m2.item_id),
        2
    ) AS revenue_contribution_pct
FROM restaurant r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu m
    ON oi.item_id = m.item_id
GROUP BY r.restaurant_id, r.name
ORDER BY revenue_contribution_pct DESC;



#Best Selling Menu Items

SELECT
    m.item_id,
    m.item_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM menu m
JOIN order_items oi
    ON m.item_id = oi.item_id
GROUP BY m.item_id, m.item_name
ORDER BY total_quantity_sold DESC;



#Highest Revenue Generating Menu Items

SELECT
    m.item_id,
    m.item_name,
    SUM(oi.quantity * m.price) AS revenue
FROM menu m
JOIN order_items oi
    ON m.item_id = oi.item_id
GROUP BY m.item_id, m.item_name
ORDER BY revenue DESC;

#Menu Items Never Ordered
SELECT
    m.item_id,
    m.item_name
FROM menu m
LEFT JOIN order_items oi
    ON m.item_id = oi.item_id
WHERE oi.item_id IS NULL;



#Monthly Revenue Trend

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * m.price) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN menu m
    ON oi.item_id = m.item_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;


#Month-over-Month Revenue Growth using LAG()
WITH monthly_revenue AS
(
    SELECT
        DATE_FORMAT(o.order_date,'%Y-%m') AS month,
        SUM(oi.quantity * m.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN menu m
        ON oi.item_id = m.item_id
    GROUP BY DATE_FORMAT(o.order_date,'%Y-%m')
)

SELECT
    month,
    revenue,
    LAG(revenue) OVER(ORDER BY month) AS previous_month_revenue,
    ROUND(
        ((revenue - LAG(revenue) OVER(ORDER BY month))
        / LAG(revenue) OVER(ORDER BY month)) * 100,
        2
    ) AS mom_growth_pct
FROM monthly_revenue;


#Top 3 Customers Per Restaurant using DENSE_RANK()
-- Top 3 Customers Per Restaurant
WITH customer_spending AS
(
    SELECT
        r.restaurant_id,
        r.name AS restaurant_name,
        c.customer_id,
        c.name AS customer_name,
        SUM(oi.quantity * m.price) AS spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN restaurant r
        ON o.restaurant_id = r.restaurant_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN menu m
        ON oi.item_id = m.item_id
    GROUP BY
        r.restaurant_id,
        r.name,
        c.customer_id,
        c.name
)

SELECT
    restaurant_id,
    restaurant_name,
    customer_id,
    customer_name,
    spending,
    rnk
FROM
(
    SELECT
        *,
        DENSE_RANK() OVER
        (
            PARTITION BY restaurant_id
            ORDER BY spending DESC
        ) AS rnk
    FROM customer_spending
) t
WHERE rnk <= 3
ORDER BY restaurant_id, rnk;