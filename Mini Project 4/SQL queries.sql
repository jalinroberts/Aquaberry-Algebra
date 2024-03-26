USE sakila;

#Part 1
#Single Table Queries
#1
SELECT title FROM film
ORDER BY title ASC;

#2
SELECT description, release_year, length, rating FROM film
WHERE title="KENTUCKIAN GIANT";

#3
SELECT last_name,first_name FROM staff;

#4
SELECT CONCAT(last_name,', ',first_name) AS Name FROM staff;

#5
SELECT COUNT(customer_id) AS Num_Customers FROM customer;

#6
SELECT active,COUNT(customer_id) AS Num_Customers FROM customer 
GROUP BY active;

#7
SELECT customer_id, AVG(amount) AS average_rental_cost FROM payment GROUP BY customer_id;

#8
SELECT customer_id, MAX(amount) AS max_rental_cost FROM payment GROUP BY customer_id;

#9
SELECT CONCAT(last_name,', ',first_name) AS actor_name FROM actor
ORDER BY last_name ASC;

#10
SELECT CONCAT(last_name,', ',first_name) AS actor_name FROM actor
ORDER BY last_name DESC;

#11
SELECT CONCAT(last_name,', ',first_name) AS actor_name FROM actor
WHERE LEFT(last_name,1) IN ('M','V')
ORDER BY last_name ASC;

#12
SELECT CONCAT(last_name,', ',first_name) AS actor_name FROM actor
WHERE LEFT(last_name,1) IN ('M','N','O','P','Q','R','S','T','U','V')
ORDER BY last_name ASC;

#13
SELECT customer_id, count(rental_id) FROM rental
Group BY customer_id;

#Multi Table Queries
#1
SELECT category.name as Category, COUNT(film_category.film_id) as Num_Films FROM category,film_category
WHERE film_category.category_id=category.category_id
GROUP BY category.name;

#2
SELECT category.name as Category, COUNT(film_category.film_id) AS Num_Films FROM category
LEFT JOIN film_category ON film_category.category_id=category.category_id
GROUP BY category.name;

#3
SELECT country.country as Country, COUNT(city.city) AS Num_cities FROM country,city
WHERE country.country_id=city.country_id
GROUP BY country.country
ORDER BY country asc;

#4
SELECT country.country as Country, COUNT(city.city) AS Num_cities FROM country
LEFT JOIN city ON city.country_id=country.country_id
GROUP BY country.country
ORDER BY country asc;

#5
SELECT CONCAT(customer.last_name,', ',customer.first_name) as Customer_Name, COUNT(rental.rental_id) as Num_Rentals 
FROM customer,rental
WHERE customer.customer_id=rental.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name asc;

#6
SELECT CONCAT(customer.last_name,', ',customer.first_name) as Customer_Name, COUNT(rental.rental_id) as Num_Rentals 
FROM customer
LEFT JOIN rental ON customer.customer_id=rental.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name asc;

#7
SELECT CONCAT(customer.last_name,', ',customer.first_name) as Customer_Name, SUM(payment.amount) AS Total_Spent
From customer
LEFT JOIN payment ON payment.customer_id=customer.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name asc;

#8
SELECT film.title as Title, COUNT(film_actor.actor_id) as Num_Actors
From film
Left JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY film.title
ORDER BY film.title asc;

#9
SELECT store.manager_staff_id as Manager, COUNT(film_id) as Num_Films
FROM store
LEFT JOIN inventory ON store.store_id=inventory.store_id
GROUP BY store.manager_staff_id;
 
#10
SELECT store.manager_staff_id as Manager, COUNT(customer.customer_id) as Num_Customers
FROM store
LEFT JOIN customer ON store.store_id=customer.store_id
GROUP BY store.manager_staff_id
ORDER BY store.store_id asc;

#11
SELECT film.title as Title, category.name as Category
FROM film_category
INNER JOIN film ON film.film_id=film_category.film_id
INNER JOIN category ON category.category_id=film_category.category_id
ORDER BY category.name asc;

#12
SELECT customer.first_name AS 'First Name',customer.last_name AS 'Last Name',CONCAT(address.address,', ',city.city,', ',country.country) AS Address
FROM customer
INNER JOIN address ON customer.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON city.country_id=country.country_id
ORDER BY customer.last_name asc;

#13
SELECT customer.first_name AS 'First Name',customer.last_name AS 'Last Name',CONCAT(address.address,', ',city.city,', ',country.country) AS Address
FROM customer
INNER JOIN address ON customer.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON city.country_id=country.country_id
WHERE customer.active=0 and country.country='CHINA'
ORDER BY customer.last_name asc;

#14
SELECT CONCAT(customer.last_name,', ',customer.first_name),
GROUP_CONCAT(DISTINCT film.title ORDER BY film.title asc SEPARATOR', ') as 'Rented Films'
FROM customer
INNER JOIN inventory ON customer.store_id=inventory.store_id
INNER JOIN film ON inventory.film_id=film.film_id
GROUP BY customer.customer_id
ORDER BY customer.last_name asc;

#15
SELECT CONCAT(customer.last_name,', ',customer.first_name),
GROUP_CONCAT(DISTINCT film.title,' (',category.name,')' ORDER BY film.title asc SEPARATOR', ') as 'Rented Films'
FROM customer
INNER JOIN inventory ON customer.store_id=inventory.store_id
INNER JOIN film ON inventory.film_id=film.film_id
INNER JOIN film_category ON film.film_id=film_category.film_id
INNER JOIN category ON film_category.category_id=category.category_id
GROUP BY customer.customer_id
ORDER BY customer.last_name asc;

#16
SELECT CONCAT(customer.last_name,', ',customer.first_name) AS 'Cutstomer Name',COUNT(rental.rental_id) AS Num_Rentals,SUM(payment.amount) AS Total_Spent
FROM customer
INNER JOIN rental ON customer.customer_id=rental.customer_id
INNER JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY customer.customer_id
ORDER BY customer.last_name asc;

#17
SELECT CONCAT(customer.last_name,', ',customer.first_name) AS 'Cutstomer Name',country.country as Country,COUNT(rental.rental_id) AS Num_Rentals,SUM(payment.amount) AS Total_Spent
FROM customer
INNER JOIN rental ON customer.customer_id=rental.customer_id
INNER JOIN payment ON rental.rental_id=payment.rental_id
INNER JOIN address ON customer.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON city.country_id=country.country_id
GROUP BY customer.customer_id
ORDER BY customer.last_name asc;

#Part 2
#1
SELECT category.name, COUNT(film_category.category_id) AS 'Film Count'
FROM category
LEFT JOIN film_category ON category.category_id=film_category.category_id
GROUP BY category.name
ORDER BY COUNT(film_category.category_id) desc;

#2
SELECT country.country AS Country, COUNT(city.city) AS 'City Count'
FROM country
LEFT JOIN city ON country.country_id=city.country_id
GROUP BY country.country
ORDER BY COUNT(city.city) desc
LIMIT 10;

#3
SELECT film.title AS Title, COUNT(film_actor.actor_id) AS 'Actor Count'
FROM film
LEFT JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY film.title
ORDER BY COUNT(film_actor.actor_id) desc
LIMIT 10;

#4
#Ask about this one in class
SELECT country.country AS Country, COUNT(rental.rental_id) as 'Rental Count'
FROM country
INNER JOIN city ON country.country_id=city.country_id
INNER JOIN address ON city.city_id=address.city_id
INNER JOIN customer ON address.address_id=customer.address_id
INNER JOIN rental ON customer.customer_id=rental.customer_id
GROUP BY country.country
ORDER BY COUNT(rental.rental_id) desc
LIMIT 10;

#5
SELECT country.country AS Country, SUM(payment.amount) AS 'Total Payment'
FROM country
INNER JOIN city ON country.country_id=city.country_id
INNER JOIN address ON city.city_id=address.city_id
INNER JOIN customer ON address.address_id=customer.address_id
INNER JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY country.country
ORDER BY SUM(payment.amount) desc
LIMIT 10;

#6
SELECT country.country AS Country,COUNT(payment.rental_id) AS 'Rentals', SUM(payment.amount) AS 'Payment'
FROM country
INNER JOIN city ON country.country_id=city.country_id
INNER JOIN address ON city.city_id=address.city_id
INNER JOIN customer ON address.address_id=customer.address_id
INNER JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY country.country
ORDER BY SUM(payment.amount) desc;

