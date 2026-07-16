show databases;
use fd_system;
# show all tables
show tables;

# see columns of all tables at once
select table_name,
       column_name,
       data_type
from information_schema.columns
where table_schema = 'fd_system'
order by table_name, ordinal_position;

#See PKs and FKs
select table_name,
       column_name,
       column_key
from information_schema.columns
where table_schema='fd_system'
order by table_name;

#Generate all DESC commands automatically
select concat('desc ', table_name, ';')
from information_schema.tables
where table_schema='fd_system';

#for understanding relationships
show create table customers;
show create table restaurant;
show create table menu;
show create table orders;
show create table order_items;

 
 
 # CREATING TABLES 
 
-- =========================
-- CUSTOMERS
-- =========================

CREATE TABLE customers (
customer_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
phone VARCHAR(15),
address VARCHAR(100) NOT NULL
);

-- =========================
-- RESTAURANTS
-- =========================
CREATE TABLE restaurant (
restaurant_id INT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5),
address VARCHAR(100)
);

-- =========================
-- MENU
-- =========================
CREATE TABLE menu (
item_id INT PRIMARY KEY,
restaurant_id INT,
item_name VARCHAR(50) NOT NULL,
price DECIMAL(8,2) NOT NULL,
category ENUM('veg','non-veg') NOT NULL,
FOREIGN KEY (restaurant_id)
REFERENCES restaurant(restaurant_id)
ON DELETE CASCADE
);

-- =========================
-- ORDERS
-- =========================
CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
restaurant_id INT,
order_date DATE NOT NULL,
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE CASCADE,
FOREIGN KEY (restaurant_id)
REFERENCES restaurant(restaurant_id)
ON DELETE CASCADE
);

-- =========================
-- ORDER ITEMS
-- =========================
CREATE TABLE order_items (
order_id INT,
item_id INT,
quantity INT NOT NULL,
PRIMARY KEY (order_id, item_id),
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE CASCADE,
FOREIGN KEY (item_id)
REFERENCES menu(item_id)
ON DELETE CASCADE
);

-- =========================
-- PAYMENTS
-- =========================
CREATE TABLE payments (
payment_id INT PRIMARY KEY,
order_id INT UNIQUE,
payment_date DATE,
amount DECIMAL(10,2),
payment_method ENUM(
'UPI',
'Credit Card',
'Debit Card',
'Cash'
),
payment_status ENUM(
'Success',
'Pending',
'Failed'
),
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE CASCADE
);

-- =========================
-- DELIVERY PARTNERS
-- =========================
CREATE TABLE delivery_partner (
partner_id INT PRIMARY KEY,
partner_name VARCHAR(50),
phone VARCHAR(15),
vehicle_type ENUM(
'Bike',
'Scooter',
'Cycle'
)
);

-- =========================
-- DELIVERIES
-- =========================
CREATE TABLE deliveries (
delivery_id INT PRIMARY KEY,
order_id INT UNIQUE,
partner_id INT,
delivery_status ENUM(
'Assigned',
'Picked Up',
'Delivered',
'Cancelled'
),
delivery_time INT,
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE CASCADE,
FOREIGN KEY (partner_id)
REFERENCES delivery_partner(partner_id)
ON DELETE CASCADE
);

-- =========================
-- REVIEWS
-- =========================
CREATE TABLE reviews (
review_id INT PRIMARY KEY,
customer_id INT,
restaurant_id INT,
rating DECIMAL(2,1) CHECK (rating BETWEEN 1 AND 5),
review_text VARCHAR(255),
review_date DATE,
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE CASCADE,
FOREIGN KEY (restaurant_id)
REFERENCES restaurant(restaurant_id)
ON DELETE CASCADE
);


# INSERTING DATA INTO TABLES

-- =====================================
-- CUSTOMERS
-- =====================================

INSERT INTO customers(name, phone, address)
VALUES
('Rahul Sharma', '9876543210', 'Delhi'),
('Priya Mehta', '9123456780', 'Mumbai'),
('Aman Verma', '9988776655', 'Jaipur'),
('Sneha Kapoor', '9012345678', 'Pune'),
('Arjun Singh', '9898989898', 'Chandigarh'),
('Neha Joshi', '9871203456', 'Ahmedabad'),
('Karan Malhotra', '9765432109', 'Lucknow'),
('Simran Kaur', '9345678901', 'Amritsar'),
('Rohit Yadav', '9090909090', 'Patna'),
('Anjali Gupta', '9812345670', 'Bhopal'),
('Vikas Jain', '9701234567', 'Indore'),
('Pooja Arora', '9654321098', 'Kolkata'),
('Mohit Saini', '9887766554', 'Dehradun'),
('Isha Nair', '9445566778', 'Kochi'),
('Dev Patel', '9332211445', 'Surat');

-- =====================================
-- RESTAURANTS
-- =====================================

INSERT INTO restaurant(restaurant_id, name, rating, address)
VALUES
(1, 'Spice Hub', 4.5, 'Delhi'),
(2, 'Food Plaza', 4.2, 'Mumbai'),
(3, 'Tasty Bites', 4.8, 'Jaipur'),
(4, 'Urban Tadka', 4.1, 'Pune'),
(5, 'Royal Feast', 4.7, 'Chandigarh'),
(6, 'Flavour Street', 4.0, 'Ahmedabad'),
(7, 'Hungry Point', 3.9, 'Lucknow'),
(8, 'The Food Court', 4.3, 'Amritsar'),
(9, 'Desi Delight', 4.6, 'Patna'),
(10, 'Grill House', 4.4, 'Bhopal'),
(11, 'Taste Junction', 4.2, 'Indore'),
(12, 'Yummy Corner', 3.8, 'Kolkata'),
(13, 'Cafe Aroma', 4.5, 'Dehradun'),
(14, 'Ocean Spice', 4.9, 'Kochi'),
(15, 'Street Flavours', 4.1, 'Surat');

-- =====================================
-- MENU
-- =====================================

INSERT INTO menu
(item_id, restaurant_id, item_name, price, category)
VALUES
(101,1,'Paneer Butter Masala',250,'veg'),
(102,1,'Chicken Biryani',320,'non-veg'),

(103,2,'Veg Burger',120,'veg'),
(104,2,'Chicken Burger',180,'non-veg'),

(105,3,'Masala Dosa',180,'veg'),
(106,3,'Chicken Pizza',450,'non-veg'),

(107,4,'Pav Bhaji',150,'veg'),
(108,4,'Chicken Sandwich',220,'non-veg'),

(109,5,'Mutton Curry',380,'non-veg'),
(110,5,'Paneer Tikka',280,'veg'),

(111,6,'Gujarati Thali',300,'veg'),
(112,6,'Chicken Curry',350,'non-veg'),

(113,7,'Chicken Roll',140,'non-veg'),
(114,7,'Veg Roll',110,'veg'),

(115,8,'Amritsari Kulcha',200,'veg'),
(116,8,'Butter Chicken',390,'non-veg'),

(117,9,'Litti Chokha',160,'veg'),
(118,9,'Fish Curry',340,'non-veg'),

(119,10,'Grilled Chicken',420,'non-veg'),
(120,10,'Veg Pasta',240,'veg'),

(121,11,'Veg Noodles',180,'veg'),
(122,12,'Paneer Pizza',350,'veg'),

(123,13,'Cold Coffee',120,'veg'),
(124,14,'Prawn Curry',500,'non-veg'),

(125,15,'Chole Bhature',170,'veg');

-- =====================================
-- ORDERS
-- =====================================

INSERT INTO orders
(order_id, customer_id, restaurant_id, order_date)
VALUES
(1001, 1, 1, '2026-05-10'),
(1002, 2, 2, '2026-05-10'),
(1003, 3, 3, '2026-05-11'),
(1004, 4, 4, '2026-05-11'),
(1005, 5, 5, '2026-05-12'),
(1006, 6, 6, '2026-05-12'),
(1007, 7, 7, '2026-05-13'),
(1008, 8, 8, '2026-05-13'),
(1009, 9, 9, '2026-05-14'),
(1010, 10, 10, '2026-05-14'),

-- Extra orders for advanced interview questions
(1011, 1, 2, '2026-05-15');
-- Remaining Orders

INSERT INTO orders
(order_id, customer_id, restaurant_id, order_date)
VALUES
(1012, 2, 5, '2026-05-15'),
(1013, 3, 1, '2026-05-16'),
(1014, 4, 3, '2026-05-16'),
(1015, 5, 8, '2026-05-17');

-- =====================================
-- ORDER ITEMS
-- =====================================

INSERT INTO order_items
(order_id, item_id, quantity)
VALUES

-- Rahul Sharma
(1001, 101, 2),
(1001, 102, 1),

-- Priya Mehta
(1002, 103, 3),

-- Aman Verma
(1003, 105, 2),

-- Sneha Kapoor
(1004, 107, 1),

-- Arjun Singh
(1005, 109, 2),

-- Neha Joshi
(1006, 111, 1),

-- Karan Malhotra
(1007, 113, 4),

-- Simran Kaur
(1008, 115, 2),

-- Rohit Yadav
(1009, 117, 3),

-- Anjali Gupta
(1010, 119, 1),

-- Rahul's second order
(1011, 103, 2),
(1011, 104, 1),

-- Priya's second order
(1012, 109, 1),
(1012, 110, 2),

-- Aman's second order
(1013, 101, 1),
(1013, 102, 2),

-- Sneha's second order
(1014, 105, 1),
(1014, 106, 1),

-- Arjun's second order
(1015, 115, 2),
(1015, 116, 1);

-- =====================================
-- PAYMENTS
-- =====================================

INSERT INTO payments
(payment_id, order_id, payment_date, amount, payment_method, payment_status)
VALUES
(1, 1001, '2026-05-10', 820.00, 'UPI', 'Success'),
(2, 1002, '2026-05-10', 360.00, 'Credit Card', 'Success'),
(3, 1003, '2026-05-11', 360.00, 'UPI', 'Success'),
(4, 1004, '2026-05-11', 150.00, 'Cash', 'Success'),
(5, 1005, '2026-05-12', 760.00, 'Debit Card', 'Success'),
(6, 1006, '2026-05-12', 300.00, 'UPI', 'Success'),
(7, 1007, '2026-05-13', 560.00, 'Cash', 'Success'),
(8, 1008, '2026-05-13', 400.00, 'UPI', 'Success'),
(9, 1009, '2026-05-14', 480.00, 'Credit Card', 'Failed'),
(10, 1010, '2026-05-14', 420.00, 'UPI', 'Success');

-- =====================================
-- DELIVERY PARTNERS
-- =====================================

INSERT INTO delivery_partner
(partner_id, partner_name, phone, vehicle_type)
VALUES
(1, 'Rakesh Kumar', '9871111111', 'Bike'),
(2, 'Amit Singh', '9872222222', 'Scooter'),
(3, 'Deepak Sharma', '9873333333', 'Bike'),
(4, 'Vikas Yadav', '9874444444', 'Cycle'),
(5, 'Mohit Jain', '9875555555', 'Bike');

-- =====================================
-- DELIVERIES
-- =====================================

INSERT INTO deliveries
(delivery_id, order_id, partner_id, delivery_status, delivery_time)
VALUES
(1, 1001, 1, 'Delivered', 28),
(2, 1002, 2, 'Delivered', 35),
(3, 1003, 3, 'Delivered', 25),
(4, 1004, 4, 'Delivered', 40),
(5, 1005, 5, 'Delivered', 32),
(6, 1006, 1, 'Delivered', 22),
(7, 1007, 2, 'Delivered', 38),
(8, 1008, 3, 'Delivered', 30),
(9, 1009, 4, 'Cancelled', NULL),
(10, 1010, 5, 'Delivered', 27);

-- =====================================
-- REVIEWS
-- =====================================

INSERT INTO reviews
(review_id, customer_id, restaurant_id, rating, review_text, review_date)
VALUES
(1, 1, 1, 4.5, 'Excellent food and fast delivery', '2026-05-11'),
(2, 2, 2, 4.0, 'Good taste and packaging', '2026-05-11'),
(3, 3, 3, 5.0, 'Amazing experience', '2026-05-12'),
(4, 4, 4, 3.5, 'Food was okay', '2026-05-12'),
(5, 5, 5, 4.8, 'Loved the mutton curry', '2026-05-13'),
(6, 6, 6, 4.2, 'Authentic Gujarati food', '2026-05-13'),
(7, 7, 7, 3.8, 'Delivery was late', '2026-05-14'),
(8, 8, 8, 4.6, 'Kulcha was delicious', '2026-05-14'),
(9, 9, 9, 4.1, 'Nice traditional food', '2026-05-15'),
(10, 10, 10, 4.7, 'Chicken was perfectly grilled', '2026-05-15');


-- Show all customers
SELECT * FROM customers;







-- Show all restaurants
SELECT * FROM restaurant;


-- Show all menu items
SELECT * FROM menu;

-- Show all orders
SELECT * FROM orders;

-- Show all order items
SELECT * FROM order_items;

-- Show all payments
SELECT * FROM payments;

-- Show all delivery partners
SELECT * FROM delivery_partner;

-- Show all deliveries
SELECT * FROM deliveries;

-- Show all reviews
SELECT * FROM reviews;

-- Orders with customer names and restaurant names
SELECT o.order_id,
       c.name AS customer_name,
       r.name AS restaurant_name,
       o.order_date
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN restaurant r
ON o.restaurant_id = r.restaurant_id;

-- Order details with item names
SELECT oi.order_id,
       m.item_name,
       oi.quantity,
       m.price
FROM order_items oi
JOIN menu m
ON oi.item_id = m.item_id;

-- Payments with customer names
SELECT p.payment_id,
       c.name,
       p.amount,
       p.payment_method,
       p.payment_status
FROM payments p
JOIN orders o
ON p.order_id = o.order_id
JOIN customers c
ON o.customer_id = c.customer_id;

-- Deliveries with delivery partner names
SELECT d.delivery_id,
       d.order_id,
       dp.partner_name,
       d.delivery_status,
       d.delivery_time
FROM deliveries d
JOIN delivery_partner dp
ON d.partner_id = dp.partner_id;

-- Reviews with customer and restaurant names
SELECT r.review_id,
       c.name AS customer_name,
       rt.name AS restaurant_name,
       r.rating,
       r.review_text
FROM reviews r
JOIN customers c
ON r.customer_id = c.customer_id
JOIN restaurant rt
ON r.restaurant_id = rt.restaurant_id;


SELECT table_name,
       column_name,
       data_type
FROM information_schema.columns
WHERE table_schema = 'fd_system'
ORDER BY table_name, ordinal_position;


# ---------------------------------PRACTICE QUERIES-----------------------------------------------------------------------------------
-- Q1. Show all customers
SELECT * FROM customers;

-- Q2. Show customer names and phone numbers only
SELECT name, phone
FROM customers;

-- Q3. Display customers from Delhi
SELECT *
FROM customers
WHERE address = 'Delhi';

-- Q4. Show customers whose name starts with 'A'
SELECT *
FROM customers
WHERE name LIKE 'A%';

-- Q5. Show customers whose name ends with 'a'
SELECT *
FROM customers
WHERE name LIKE '%a';

-- Q6. Show customers whose phone number starts with '98'
SELECT *
FROM customers
WHERE phone LIKE '98%';

-- Q7. Display unique customer cities
SELECT DISTINCT address
FROM customers;

-- Q8. Count total customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Q9. Display customers sorted by name
SELECT *
FROM customers
ORDER BY name;

-- Q10. Display customers sorted by city descending
SELECT *
FROM customers
ORDER BY address DESC;

-- Q11. Show first 5 customers
SELECT *
FROM customers
LIMIT 5;

-- Q12. Show next 5 customers after skipping first 5
SELECT *
FROM customers
LIMIT 5 OFFSET 5;

-- Q13. Show customers whose name contains 'ar'
SELECT *
FROM customers
WHERE name LIKE '%ar%';

-- Q14. Show customers whose name has a space in it
SELECT *
FROM customers
WHERE name LIKE '% %';

-- Q15. Display customer names along with their name lengths
SELECT name,
       LENGTH(name) AS name_length
FROM customers;

-- Q16. Find the customer with the longest name
SELECT *
FROM customers
ORDER BY LENGTH(name) DESC
LIMIT 1;

-- Q17. Find the customer with the shortest name
SELECT *
FROM customers
ORDER BY LENGTH(name)
LIMIT 1;

-- Q18. Display customer details where address is either Delhi, Pune, or Jaipur
SELECT *
FROM customers
WHERE address IN ('Delhi','Pune','Jaipur');

-- Q19. Count customers city-wise
SELECT address,
       COUNT(*) AS total_customers
FROM customers
GROUP BY address;

-- Q20. Display total number of customers city-wise sorted by highest count first
SELECT address,
       COUNT(*) AS total_customers
FROM customers
GROUP BY address
ORDER BY total_customers DESC;

-- Q21. Show all restaurants
SELECT * 
FROM restaurant;

-- Q22. Display restaurant names and ratings
SELECT name, rating
FROM restaurant;

-- Q23. Show restaurants with rating greater than 4.5
SELECT *
FROM restaurant
WHERE rating > 4.5;

-- Q24. Find the highest rated restaurant
SELECT *
FROM restaurant
ORDER BY rating DESC
LIMIT 1;

-- Q25. Find the second highest rated restaurant
SELECT *
FROM restaurant
ORDER BY rating DESC
LIMIT 1 OFFSET 1;

-- Q26. Display restaurants sorted by rating descending
SELECT *
FROM restaurant
ORDER BY rating DESC;

-- Q27. Count total restaurants
SELECT COUNT(*) AS total_restaurants
FROM restaurant;

-- Q28. Find average restaurant rating
SELECT AVG(rating) AS avg_rating
FROM restaurant;

-- Q29. Show restaurants whose name contains 'Food'
SELECT *
FROM restaurant
WHERE name LIKE '%Food%';

-- Q30. Display restaurants located in Delhi
SELECT *
FROM restaurant
WHERE address = 'Delhi';

-- Q31. Show all menu items
SELECT *
FROM menu;

-- Q32. Display only veg items
SELECT *
FROM menu
WHERE category = 'veg';

-- Q33. Display only non-veg items
SELECT *
FROM menu
WHERE category = 'non-veg';

-- Q34. Find the most expensive menu item
SELECT *
FROM menu
ORDER BY price DESC
LIMIT 1;

-- Q35. Find the second most expensive menu item
SELECT *
FROM menu
ORDER BY price DESC
LIMIT 1 OFFSET 1;

-- Q36. Find the cheapest menu item
SELECT *
FROM menu
ORDER BY price
LIMIT 1;

-- Q37. Show average item price category-wise
SELECT category,
       AVG(price) AS avg_price
FROM menu
GROUP BY category;

-- Q38. Count menu items category-wise
SELECT category,
       COUNT(*) AS total_items
FROM menu
GROUP BY category;

-- Q39. Display items costing more than 300
SELECT *
FROM menu
WHERE price > 300;

-- Q40. Find total menu value for each restaurant
SELECT restaurant_id,
       SUM(price) AS total_menu_value
FROM menu
GROUP BY restaurant_id;

-- -----------------------------------------------------------JOINS----------------------------------------------------

-- J1. Show customer name and order date for all orders
select  c.name as customer_name,o.order_date from customers c join orders o on c.customer_id=o.customer_id;

-- J2. Show customer name and restaurant name for every order
select o.order_id,c.name as customer_name,r.name as restaurant_name  from customers c join orders o  on c.customer_id = o.customer_id join restaurant r 
on o.restaurant_id=r.restaurant_id ;


-- J3. Show order id, item name and quantity ordered
select oi.order_id,item_name,quantity from order_items oi join menu m on oi.item_id=m.item_id;
select * from menu;
select * from order_items;
select * from customers;
show tables;
-- J4. Show customer name, item name and quantity ordered
select c.name as customer_name,item_name,quantity from customers as c  join orders o on c.customer_id=o.customer_id join order_items oi
 on o.order_id=oi.order_id join menu m on oi.item_id=m.item_id order by c.name asc;

-- J5. Show restaurant name and item name for every menu item
select name as restaurant_name ,item_name from menu m join restaurant r on r.restaurant_id=m.restaurant_id ;

-- J6. Show customer name, restaurant name and order date



-- J7. Show all customers along with their order ids

-- J8. Show all customers including those who never placed an order

-- J9. Show all restaurants including those that never received an order

-- J10. Show customers who never placed any order

-- J11. Show restaurants that never received any order

-- J12. Display total number of orders received by each restaurant

-- J13. Display total quantity sold for each menu item

-- J14. Show total spending for each order

-- J15. Show customer name and total amount spent on each order

-- J16. Display restaurant name and total revenue generated

-- J17. Show customer name and total amount spent across all orders

-- J18. Display restaurant name and total number of distinct customers served

-- J19. Show the most ordered menu item based on quantity

-- J20. Show the least ordered menu item based on quantity

# MEDIUM LEVEL----------------------------------------------------------------

-- J21. Show customers who ordered from more than one restaurant
select c.name as customers_name ,count( r.name) as count_restaurant from customers c join orders o on c.customer_id=o.customer_id join restaurant r on o.restaurant_id=r.restaurant_id
 group by c.customer_id having count_restaurant>1 ;

-- J22. Show restaurants that served more than one customer
select name as restaurant_name  from restaurant r join orders o on r.restaurant_id=o.restaurant_id group by name  having count(customer_id)>1;


-- J23. Show customers who ordered both veg and non-veg items
select customer_id from menu m join orders o on m.restaurant_id=o.restaurant_id group by customer_id having count(distinct(category))=2;
show tables;

-- J24. Show restaurant-wise count of veg and non-veg items
SELECT r.name AS restaurant_name,
       SUM(CASE WHEN m.category = 'veg' THEN 1 ELSE 0 END) AS veg_count,
       SUM(CASE WHEN m.category = 'non-veg' THEN 1 ELSE 0 END) AS non_veg_count
FROM restaurant r
JOIN menu m
ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id, r.name;
select * from order_items;

-- J25. Display average order value for each restaurant
# hard ....
SELECT r.restaurant_id,
       r.name AS restaurant_name,
       ROUND(AVG(t.order_value),2) AS avg_order_value
FROM restaurant r
JOIN(
select sum(oi.quantity*price) as order_value,o.restaurant_id from orders o join order_items oi on o.order_id=oi.order_id join
 menu m on m.item_id=oi.item_id
 group by o.restaurant_id) t 
 on r.restaurant_id=t.restaurant_id
 group by r.restaurant_id,r.name;
 
select * from menu;

#J26. Show restaurant generating highest revenue

# hard...

select * from restaurant;
select * from menu;
select * from order_items;

with cte as ( 
select  name ,revenue,dense_rank() over(order by t.revenue desc)  ranking  from restaurant r join  (
select sum(quantity*price) as revenue , restaurant_id
from menu m  join order_items oi on m.item_id=oi.item_id 
group by restaurant_id order by revenue desc) t 
 on r.restaurant_id=t.restaurant_id) 
 select name,revenue from cte where ranking=1 ;

-- J27. Show customer with highest spending
select * from order_items;
select * from menu;
select * from orders;
select * from customers;

-- J28. Show top 3 customers by spending


-- J29. Show top 3 restaurants by revenue

-- J30. Show all orders with payment details

-- J31. Show all delivered orders with delivery partner names

-- J32. Show delivery partner and number of deliveries completed

-- J33. Show average delivery time for each delivery partner

-- J34. Show restaurant name and average customer review rating

-- J35. Show customers who submitted reviews

-- J36. Show customers who placed orders but never submitted reviews

-- J37. Show orders whose payment status is Failed

-- J38. Show restaurant revenue by payment method

-- J39. Show delivery partners who handled more than 2 deliveries

-- J40. Show customer, restaurant, item and quantity in a single result

# HARD (INTERVIEWER FAV)----------------------------------------------------------------

-- J41. Find customers whose spending is above average customer spending

-- J42. Find restaurants whose revenue is above average restaurant revenue

-- J43. Find the highest revenue generating menu item

-- J44. Find customers who ordered on multiple different dates

-- J45. Find restaurants with more than average number of orders

-- J46. Find customers who ordered from the highest rated restaurant

-- J47. Find restaurants that have never received a review

-- J48. Find customers who reviewed every restaurant they ordered from

-- J49. Find delivery partners who never delivered any order

-- J50. Find orders where delivery time exceeded average delivery time

-- J51. Find the customer who generated maximum revenue for each restaurant

-- J52. Find the most popular item in each restaurant

-- J53. Find restaurants whose average review rating is higher than their listed rating

-- J54. Find customers who spent more than the average spending of their city

-- J55. Find the restaurant contributing the highest percentage of total revenue

-- J56. Find customers who ordered the same item more than once

-- J57. Find pairs of customers who ordered from the same restaurant

-- J58. Find the delivery partner with the fastest average delivery time

-- J59. Find restaurants that have both veg and non-veg items but only veg orders

-- J60. Find customers who have ordered from every restaurant they reviewed



-- -----------------------------------------------SUBQUERIES-------------------------------------------

-- SQ1. Find the customer with the highest customer_id
select customer_id,name as customer_name from (select * from customers order by customer_id desc limit 1) highest;

-- SQ2. Find the customer with the lowest customer_id
 select * from(select * from customers order by customer_id )lowest limit 1;

-- SQ3. Find the restaurant with the highest rating
select * from (select *from restaurant  order by rating desc) highest_rating limit 1  ;
 select * from (select*, dense_rank() over( order by rating desc) as ranking  from restaurant) den_rank where ranking =1;
 
-- SQ4. Find the restaurant with the lowest rating
select * from (select*, dense_rank() over( order by rating ) as ranking  from restaurant) den_rank where ranking =1;

-- SQ5. Find menu items priced above the average menu price
select * from  menu;
select * from menu where price>(select avg(price) from menu) ;

-- SQ6. Find menu items priced below the average menu price
select * from menu where price<(select avg(price) from menu);

-- SQ7. Find customers who have placed at least one order
select * from customers;
select * from orders;
select * from customers where customer_id in (select customer_id from orders group by customer_id having count(customer_id)>1) ;

-- SQ8. Find customers who never placed an order using a subquery
select * from customers where customer_id not in (select customer_id from orders );

-- SQ9. Find restaurants that have received at least one order
select * from restaurant where restaurant_id in ( select restaurant_id from orders);

-- SQ10. Find restaurants that never received any order using a subquery
select * from restaurant where restaurant_id NOT in ( select restaurant_id from orders);

-- SQ11. Find the most expensive menu item
SELECT * FROM MENU;
SELECT * FROM (
SELECT *,DENSE_RANK() OVER(ORDER BY PRICE DESC) AS RANKING  FROM MENU) A  WHERE RANKING=1;

-- SQ12. Find the second most expensive menu item

-- SQ13. Find the cheapest menu item

-- SQ14. Find menu items costing more than the average price of veg items
select item_name from menu where price>(
select avg(price) as average from menu where category="veg");

select * from menu;
-- SQ15. Find menu items costing more than the average price of non-veg it
select item_name from menu where price>(select avg(price) as avg_price  from menu where category="non-veg");

-- SQ16. Find restaurants whose rating is above average rating

-- SQ17. Find restaurants whose rating is below average rating

-- SQ18. Find customers whose name length is greater than average name length
select * from customers where length(name)>(select avg(length(name)) as average_length from customers);

-- SQ19. Find customers whose phone number length is equal to the maximum phone number length
 select * from customers where length(phone)=(select avg(length(phone)) as phone_len from customers);

-- SQ20. Find restaurants located in cities where customers exist


# MEDIUM---------------------------------

-- SQ21. Find customers who ordered from restaurant_id = 1
select * from customers where customer_id in (select customer_id from orders where restaurant_id=1);

-- SQ22. Find customers who ordered from the highest rated restaurant
select name from customers where customer_id=
(select customer_id from orders where restaurant_id =
( select restaurant_id from (
select restaurant_id , dense_rank() over(order by rating desc) dense_rating   
from restaurant limit 1) max_rating  where dense_rating=1)
);

-- SQ23. Find customers who ordered from the lowest rated restaurant

-- SQ24. Find restaurants that served customer_id = 1

-- SQ25. Find restaurants that have more orders than the average restaurant order count
select restaurant_id ,count(*) from orders  group by restaurant_id having count(*)>(
select avg(count_id) from (
 select  restaurant_id ,count(restaurant_id) as count_id from orders group by restaurant_id 
)countt);
select * from menu;
-- SQ26. Find menu items that were never ordered
select item_id from menu where item_id not in (select item_id  from order_items);

-- SQ27. Find menu items that were ordered at least once
select item_id from menu where item_id in (select item_id  from order_items group by item_id having count(*)>=1);

-- SQ28. Find customers who ordered the most expensive menu item
select customer_id from orders where restaurant_id in 
(select restaurant_id from 
(select restaurant_id ,dense_rank() over( order by price desc) as ranking  from menu)rank_table where ranking=1);

-- SQ29. Find customers who ordered the cheapest menu item
select customer_id from orders where restaurant_id in 
(select restaurant_id from 
(select restaurant_id ,dense_rank() over( order by price asc) as ranking  from menu)rank_table where ranking=1);

-- SQ30. Find restaurants whose average menu price is greater than overall average menu price
select * from menu;
select restaurant_id ,avg(price)from menu group by restaurant_id having  (avg(price))>(select avg(price) from menu  );

-- SQ31. Find restaurants whose average menu price is less than overall average menu price

-- SQ32. Find customers who placed more orders than the average customer

-- SQ33. Find restaurants that generated revenue above average restaurant revenue

-- SQ34. Find customers whose total spending is above average customer spending

-- SQ35. Find customers whose total spending is below average customer spending

-- SQ36. Find the customer who spent the most money

-- SQ37. Find the restaurant that generated the most revenue

-- SQ38. Find the menu item with highest quantity sold

-- SQ39. Find the menu item with lowest quantity sold

-- SQ40. Find restaurants that have both veg and non-veg items

# CORELATED SUBQUERIES----------------

-- SQ41. Find customers whose total spending is greater than the average spending of all customers


-- SQ42. Find restaurants whose revenue is greater than the average revenue of all restaurants

-- SQ43. Find customers who placed more orders than the average orders placed by customers

-- SQ44. Find menu items whose price is greater than the average price within their category

-- SQ45. Find menu items whose price is less than the average price within their category

-- SQ46. Find restaurants whose rating is greater than the average rating of restaurants in the same city

-- SQ47. Find customers who spent more than the average spending of customers from the same city

-- SQ48. Find restaurants that served more customers than the average restaurant

-- SQ49. Find customers who ordered more items than the average customer

-- SQ50. Find restaurants whose average review rating exceeds their listed rating

#EXISTS/ NOT-EXISTS-----------------------------------------------------------------

-- SQ51. Find customers who have placed at least one order using EXISTS

-- SQ52. Find customers who never placed any order using NOT EXISTS

-- SQ53. Find restaurants that have received at least one review using EXISTS

-- SQ54. Find restaurants that never received any review using NOT EXISTS

-- SQ55. Find menu items that were ordered at least once using EXISTS

-- SQ56. Find menu items that were never ordered using NOT EXISTS

-- SQ57. Find delivery partners who completed at least one delivery

-- SQ58. Find delivery partners who never completed any delivery

-- SQ59. Find customers who ordered from more than one restaurant

-- SQ60. Find restaurants that served more than one customer


# HARD ( INTERVIEW LEVEL )--------------------------------------------------------------------------

-- SQ61. Find the second highest spending customer

-- SQ62. Find the third highest spending customer

-- SQ63. Find the second highest revenue generating restaurant

-- SQ64. Find the third highest revenue generating restaurant

-- SQ65. Find customers who ordered from every restaurant they reviewed

-- SQ66. Find restaurants whose revenue contributes more than 10% of total revenue

-- SQ67. Find customers who ordered every menu item of a restaurant

-- SQ68. Find restaurants whose average review rating is above the overall average review rating

-- SQ69. Find the most popular item within each restaurant

-- SQ70. Find customers whose spending is higher than all customers from Delhi


-- -------------------------------------WINDOW FUNCTIONS-------------------------------------------------
SHOW CREATE TABLE customers;
SHOW CREATE TABLE restaurant;
SHOW CREATE TABLE menu;
SHOW CREATE TABLE orders;
SHOW CREATE TABLE order_items;
SHOW CREATE TABLE payments;
SHOW CREATE TABLE deliveries;
SHOW CREATE TABLE reviews;
SHOW CREATE TABLE delivery_partner;

