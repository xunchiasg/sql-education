-- Active: 1727328334513@@127.0.0.1@3306@db
USE db;

-- 1. Analyse the data
-- Hint: use a SELECT statement via a JOIN to sample the data
-- ****************************************************************


-- Data Tables (basic) 
SELECT * FROM progress;


SELECT * FROM users;

SELECT u.user_id, u.email_domain, u.city, u.country, 
       p.learn_cpp, p.learn_sql, p.learn_html, p.learn_javascript, p.learn_java
FROM users u
JOIN progress p ON u.user_id = p.user_id
LIMIT 20;


-- 2. What are the Top 25 schools (.edu domains)?
-- Hint: use an aggregate function to COUNT() schools with most students
-- ****************************************************************
SELECT email_domain, COUNT (*) as students
FROM users
GROUP BY 1
ORDER BY COUNT(email_domain) DESC
LIMIT 25;

-- 3. How many .edu learners are located in New York?
-- Hint: use an aggregate function to COUNT() students in New York
-- ****************************************************************
SELECT city, COUNT(*) as 'New York edu learners'
FROM users
WHERE city = 'New York'
AND email_domain LIKE '%.edu';

-- 4. The mobile_app column contains either mobile-user or NULL. 
-- How many of these learners are using the mobile app?
-- Hint: COUNT()...WHERE...IN()...GROUP BY...
-- Hint: Alternate answers are accepted.
-- ****************************************************************

WITH mobile_app_users AS (
    SELECT (CASE WHEN mobile_app = 'mobile-user' THEN 1 ELSE NULL END) AS "Mobile Users"
    FROM users
)
SELECT COUNT("Mobile Users") AS mobile_users_count
FROM mobile_app_users;

-- 5.uery for the sign up counts for each hour.
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_date-format 
-- ****************************************************************
-- Hour use of %H (24 hour clock)

SELECT DATE_FORMAT(sign_up_at, '%H') AS 'sign_up_hour',
       COUNT(*) AS 'sign_up_count'
FROM users
GROUP BY sign_up_hour;


-- 6. What courses are the New Yorker Students taking?
-- Hint: SUM(CASE WHEN learn_cpp NOT IN('') THEN 1 ELSE 0 END) AS "New Yorker learners taking C++"
-- ****************************************************************

SELECT city, 
       SUM(CASE WHEN p.learn_sql IN ('completed', 'started') THEN 1 ELSE 0 END) AS "New Yorker learners taking SQL",
       SUM(CASE WHEN p.learn_cpp IN ('completed', 'started') THEN 1 ELSE 0 END) AS "New Yorker learners taking C++",
       SUM(CASE WHEN p.learn_html IN ('completed', 'started') THEN 1 ELSE 0 END) AS "New Yorker learners taking HTML",
       SUM(CASE WHEN p.learn_javascript IN ('completed', 'started') THEN 1 ELSE 0 END) AS "New Yorker learners taking JS",
       SUM(CASE WHEN p.learn_java IN ('completed', 'started') THEN 1 ELSE 0 END) AS "New Yorker learners taking Java"
FROM users AS u
LEFT JOIN progress AS p
  ON u.user_id = p.user_id
WHERE city = 'New York'
GROUP BY city;

-- 7. What courses are the Chicago Students taking?
-- Hint: SUM(CASE WHEN learn_cpp NOT IN('') THEN 1 ELSE 0 END) AS "Chicago learners taking C++"
-- ****************************************************************

SELECT city, 
       SUM(CASE WHEN p.learn_sql NOT IN ('completed', 'started') THEN 1 ELSE 0 END) AS "Chicago learners taking SQL",
       SUM(CASE WHEN p.learn_cpp NOT IN ('completed', 'started') THEN 1 ELSE 0 END) AS "Chicago learners taking C++",
       SUM(CASE WHEN p.learn_html NOT IN ('completed', 'started') THEN 1 ELSE 0 END) AS "Chicago learners taking HTML",
       SUM(CASE WHEN p.learn_javascript NOT IN ('completed', 'started') THEN 1 ELSE 0 END) AS "Chicago learners taking JS",
       SUM(CASE WHEN p.learn_java NOT IN ('completed', 'started') THEN 1 ELSE 0 END) AS "Chicago learners taking Java"
FROM users AS u
LEFT JOIN progress AS p
  ON u.user_id = p.user_id
WHERE city = 'Chicago'
GROUP BY city;