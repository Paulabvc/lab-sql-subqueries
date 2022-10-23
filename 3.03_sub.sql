# Lab | SQL Subqueries 3.03

USE sakila;

#1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title,COUNT(DISTINCT i.inventory_id) as ncopies # I don´t know why it didn´t return the 6 copies
FROM inventory as i
JOIN film as f
ON i.film_id=f.film_id
HAVING f.title='Hunchback Impossible';

SELECT title, i.inventory_id
FROM inventory as i
JOIN film as f
ON i.film_id=f.film_id
HAVING f.title='Hunchback Impossible';

#2. List all films whose length is longer than the average of all the films.
SELECT title, AVG(length) as avg FROM film
WHERE length > avg;

SELECT title FROM film
WHERE length > 
(SELECT AVG(length)FROM film);

#3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT CONCAT(a.first_name,' ', a.last_name) as Actors_AloneTrip from film_actor as fa
JOIN actor as a
ON a.actor_id=fa.actor_id
WHERE film_id=
(SELECT film_id from film
WHERE title='Alone Trip');

#4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT fc.film_id, f.title, c.name FROM category as c
JOIN FILM_category as fc
ON c.category_id= fc.category_id
JOIN film as f
ON fc.film_id = f.film_id
WHERE c.name LIKE 'family';

#5. Get name and email from customers from Canada using subqueries. 
#Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT cust.first_name, cust.last_name, cust.email, co.country FROM customer as cust
JOIN address as a
ON cust.address_id=a.address_id
JOIN city as ci
ON a.city_id=ci.city_id
JOIN country as co
ON ci.country_id= co.country_id
HAVING co.country LIKE 'Canada';

SELECT # I don+t know why it is not returning
cust.first_name, cust.last_name, cust.email FROM customer as cust
WHERE co.country=
(SELECT country from country as co
JOIN city as ci
ON co.country_id= ci.country_id
HAVING co.country LIKE 'Canada');

(SELECT 
cust.first_name, cust.last_name, cust.email FROM customer as cust) sub1

(SELECT country from country as co
JOIN city as ci
ON co.country_id= ci.country_id
HAVING co.country LIKE 'Canada') sub2



#6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
# First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT fa.film_id, f.title from film_actor as fa
JOIN film as f
ON fa.film_id =f.film_id
WHERE fa.actor_id=
(SELECT actor_id from film_actor
GROUP BY actor_id
ORDER BY COUNT(DISTINCT film_id) DESC
limit 1);

#7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT f.title from rental as r
JOIN inventory as i
ON r.inventory_id =i.inventory_id
JOIN film as f
ON i.film_id=f.film_id
WHERE r.customer_id=
(SELECT customer_id from payment
GROUP BY customer_id
ORDER BY SUM(DISTINCT amount) DESC
limit 1);

#8. Customers who spent more than the average payments.
SELECT DISTINCT (customer_id) from payment
WHERE amount>
(
SELECT AVG(amount) FROM payment);









