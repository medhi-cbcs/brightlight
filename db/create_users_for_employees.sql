-- Create new users for each employees not yet in users table

INSERT INTO users (name, first_name, last_name, email, roles_mask, created_at, updated_at)
SELECT e.name, e.first_name, e.last_name, e.email, 72, now(), now()
FROM employees e
LEFT JOIN users u
ON e.email = u.email
where u.email is null and e.email is not null

-- Next, update the employees' user_id to match the created user record
UPDATE employees
SET user_id = u.id,
    updated_at = now()
FROM (
    SELECT id, email
    FROM users) u
WHERE
    u.email = employees.email and employees.email is not null
