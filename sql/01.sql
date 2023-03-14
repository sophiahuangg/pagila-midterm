/*
 * You want to watch a movie tonight.
 * But you're superstitious,
 * and don't want anything to do with the letter 'F'.
 *
 * Write a SQL query that lists the titles of all movies that:
 * 1) do not have the letter 'F' in their title,
 * 2) have no actors with the letter 'F' in their names (first or last),
 * 3) have never been rented by a customer with the letter 'F' in their names (first or last).
 * 4) have never been rented by anyone with an 'F' in their address (at the street, city, or country level).
 *
 * NOTE:
 * Your results should not contain any duplicate titles.
 */

WITH noftitle AS(
    SELECT
        DISTINCT film_id
    FROM film
    WHERE title NOT ILIKE '%F%'
),

fActor AS(
    SELECT
        *
    FROM film_actor
    JOIN actor USING(actor_id)
    JOIN film USING(film_id)
    WHERE CONCAT(first_name, last_name) ILIKE '%F%'
),

rent AS(
    SELECT
        DISTINCT film_id, customer_id, CONCAT(first_name, ' ', last_name) AS custname
    FROM customer
    JOIN rental USING(customer_id)
    JOIN inventory USING(inventory_id)
    JOIN film USING(film_id)
),

fCustRent AS(
    SELECT
        *
    FROM rent
    WHERE custname ILIKE '%F%'
),

fCustAddress AS(
    SELECT
        *
    FROM customer
    JOIN address USING(address_id)
    JOIN city USING(city_id)
    JOIN country USING(country_id)
    JOIN rent USING(customer_id) 
    WHERE address ILIKE '%F%'
        OR city ILIKE '%F%'
        OR country ILIKE '%F%'
),

finalFilm AS(
    SELECT
        DISTINCT film_id
    FROM noftitle

    EXCEPT

    SELECT
        DISTINCT film_id
    FROM fActor

    EXCEPT

    SELECT
        DISTINCT film_id
    FROM fCustRent

    EXCEPT

    SELECT
        DISTINCT film_id
    FROM fCustAddress
)

SELECT
    title
FROM film
JOIN finalFilm USING(film_id)
ORDER BY 1;
