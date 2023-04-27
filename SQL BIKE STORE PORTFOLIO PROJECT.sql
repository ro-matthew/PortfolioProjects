/*
The purpose of this query is to practice and demonstrate sql skills using a sample Bike Store dataset. 

Skills used: Joins, Subqueries, Query Filtering, Aggregate Functions, Converting Data Types 

*/

--Looking at stores and their managers 
SELECT store.store_id, store_name, street, city, staff_id, CONCAT(first_name, ' ', last_name) AS Manager, manager_id
FROM sales.stores store
JOIN sales.staffs staff 
	ON store.store_id = staff.store_id 
WHERE manager_id is not null 

--Looking at the products and which stores they are sold 
SELECT prod.product_id, prod.product_name, brand.brand_name, cat.category_name, store_name, list_price, quantity 
FROM production.products prod
JOIN production.stocks stoc
	ON stoc.product_id = prod.product_id 
JOIN sales.stores store 
	ON store.store_id = stoc.store_id
JOIN production.brands brand 
	ON brand.brand_id = prod.brand_id
JOIN production.categories cat
	ON cat.category_id = prod.category_id
ORDER BY prod.product_id 

--Looking at highest product cost in each store
SELECT store.store_name, MAX(oitem.list_price) AS highest_product_price
FROM sales.customers cust
JOIN sales.orders ord 
	ON ord.customer_id = cust.customer_id
JOIN sales.order_items oitem 
	ON oitem.order_id = ord.order_id
JOIN production.products prod 
	ON prod.product_id = oitem.product_id
JOIN sales.stores store 
	ON store.store_id = ord.store_id
GROUP BY store_name

--Looking at all unique products that are less expensive than a specific product 
--Shows all products that are less than the price of the product called "Surly Wednesday Frameset - 2016" (i.e. less than $999.99) 
SELECT DISTINCT prod.product_id, prod.product_name, brand.brand_name, prod.list_price
FROM production.products prod
JOIN production.stocks stoc
	ON stoc.product_id = prod.product_id 
JOIN sales.stores store 
	ON store.store_id = stoc.store_id
JOIN production.brands brand 
	ON brand.brand_id = prod.brand_id
JOIN production.categories cat
	ON cat.category_id = prod.category_id
WHERE prod.list_price < ALL  
	(SELECT prod.list_price FROM production.products prod 
		JOIN production.stocks stoc
			ON stoc.product_id = prod.product_id 
		JOIN sales.stores store 
			ON store.store_id = stoc.store_id
		JOIN production.brands brand 
			ON brand.brand_id = prod.brand_id
		JOIN production.categories cat
			ON cat.category_id = prod.category_id
		WHERE prod.product_name LIKE 'Surly_Wednesday%2016') AND prod.model_year = 2016
ORDER BY prod.product_id

--Looking at the total number of customers 
SELECT COUNT(*) AS total_number_of_customers
FROM sales.customers

--Looking at state vs percentage of customers  
SELECT state, CONCAT(CONVERT(int,ROUND(COUNT(*)/1445.0 *100,0)), '%') AS percent_of_customers
FROM sales.customers
GROUP BY state 

--Looking at customers vs products 
--shows customer basic information and what products they have ordered 
SELECT ord.order_id, cust.customer_id, CONCAT(cust.first_name, ' ', cust.last_name) AS full_name, cust.phone, cust.email, cust.zip_code, ord.order_date, ord.required_date, ord.shipped_date, prod.product_id, oitem.quantity, prod.product_name, oitem.list_price, oitem.discount, store.store_name, CONCAT(staff.first_name, ' ', staff.last_name) AS sales_rep
FROM sales.customers cust
JOIN sales.orders ord 
	ON ord.customer_id = cust.customer_id
JOIN sales.order_items oitem 
	ON oitem.order_id = ord.order_id
JOIN production.products prod 
	ON prod.product_id = oitem.product_id
JOIN sales.staffs staff 
	ON staff.staff_id = ord.staff_id
JOIN sales.stores store 
	ON store.store_id = ord.store_id
ORDER BY ord.order_id

--Who are the top 5 customers? 
SELECT TOP 5 cust.customer_id, cust.first_name, cust.last_name, cust.phone, cust.email, SUM(oitem.list_price*oitem.quantity) AS total_amount_purchased
FROM sales.customers cust
JOIN sales.orders ord 
	ON ord.customer_id = cust.customer_id
JOIN sales.order_items oitem 
	ON oitem.order_id = ord.order_id
JOIN production.products prod 
	ON prod.product_id = oitem.product_id
GROUP BY cust.customer_id, cust.first_name, cust.last_name, cust.phone, cust.email
ORDER By total_amount_purchased DESC

--Who was the most recent customer? 
SELECT TOP 1 first_name, last_name, order_date 
FROM sales.customers cust
JOIN sales.orders ord 
	ON ord.customer_id = cust.customer_id
JOIN sales.order_items oitem 
	ON oitem.order_id = ord.order_id
JOIN production.products prod 
	ON prod.product_id = oitem.product_id
GROUP BY first_name, last_name, order_date 
ORDER BY ord.order_date DESC 

--How many people have registered their phone number? 
SELECT COUNT(DISTINCT cust.phone) AS number_of_phones_registered
FROM sales.customers cust
JOIN sales.orders ord 
	ON ord.customer_id = cust.customer_id
JOIN sales.order_items oitem 
	ON oitem.order_id = ord.order_id
JOIN production.products prod 
	ON prod.product_id = oitem.product_id
WHERE cust.phone is not null 

--Looking at first time customers
SELECT first_name, last_name, cust.customer_id
FROM sales.customers cust
JOIN sales.orders ord 
	ON ord.customer_id = cust.customer_id
JOIN sales.order_items oitem 
	ON oitem.order_id = ord.order_id
JOIN production.products prod 
	ON prod.product_id = oitem.product_id
GROUP BY first_name, last_name, cust.customer_id
HAVING count(cust.customer_id) = 1 

--Looking at total revenue of each store
SELECT store.store_id, store_name, SUM(oitem.list_price*oitem.quantity) AS total_revenue
FROM sales.customers cust
JOIN sales.orders ord 
	ON ord.customer_id = cust.customer_id
JOIN sales.order_items oitem 
	ON oitem.order_id = ord.order_id
JOIN production.products prod 
	ON prod.product_id = oitem.product_id
JOIN sales.stores store
	ON store.store_id = ord.store_id
GROUP BY store_name, store.store_id
ORDER BY total_revenue DESC

--Looking at all orders in the year 2017 
SELECT cust.customer_id, ord.order_date
FROM sales.customers cust
JOIN sales.orders ord 
	ON ord.customer_id = cust.customer_id
JOIN sales.order_items oitem 
	ON oitem.order_id = ord.order_id
JOIN production.products prod 
	ON prod.product_id = oitem.product_id
JOIN sales.stores store
	ON store.store_id = ord.store_id
WHERE YEAR(ord.order_date) = 2017 


