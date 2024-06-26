SELECT COUNT(DISTINCT MP.user_id) AS MP_Users,
COUNT(DISTINCT M.user_id) AS M_Users
FROM  `membership` M
LEFT JOIN `membership_payment` MP
ON M.membership_id = MP.membership_id
AND M.`user_id` = MP.`user_id`
LEFT JOIN `membership_type` MTI
ON M.membership_type_id = MTI.membership_type_id
WHERE year(purchase_date) = '2023'
AND amount > 0
AND  is_renewable = 1
and purchase_date <= '2023-03-10'
-- 34,953