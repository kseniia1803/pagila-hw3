/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */

WITH bacall1 AS (
  SELECT DISTINCT a.actor_id
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  JOIN film_actor fa2 ON fa.film_id = fa2.film_id
  JOIN actor r ON fa2.actor_id = r.actor_id
  WHERE r.first_name = 'RUSSELL' AND r.last_name = 'BACALL'
    AND a.actor_id <> r.actor_id
)
SELECT DISTINCT a.first_name || ' ' || a.last_name AS "Actor Name"
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_actor fa2 ON fa.film_id = fa2.film_id
JOIN bacall1 b ON fa2.actor_id = b.actor_id
WHERE a.actor_id NOT IN (SELECT actor_id FROM bacall1)
  AND a.actor_id NOT IN (SELECT actor_id FROM actor WHERE first_name = 'RUSSELL' AND last_name = 'BACALL')
ORDER BY "Actor Name";
