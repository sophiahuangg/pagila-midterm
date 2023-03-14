/*
 * Write a SQL query SELECT query that:
 * List the first and last names of all actors who have appeared in movies in the "Children" category,
 * but that have never appeared in movies in the "Horror" category.
 */

WITH children AS(
    SELECT
        *
    FROM actor_info
    WHERE film_info LIKE '%Children:%'
),

nothorror AS(
    SELECT
        *
    FROM children
    WHERE film_info NOT LIKE '%Horror:%'
)

SELECT
    first_name, last_name
FROM nothorror
ORDER BY 2, 1;

