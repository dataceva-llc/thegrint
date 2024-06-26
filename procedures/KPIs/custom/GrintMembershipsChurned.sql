SELECT COUNT(*), COUNT(DISTINCT user_id) FROM 
(SELECT M.user_id, MAX(expiration_date) AS max_expiration_date
FROM  `membership` M
LEFT JOIN `membership_payment` MP
ON M.membership_id = MP.membership_id
AND M.`user_id` = MP.`user_id`
LEFT JOIN `membership_type` MTI
ON M.membership_type_id = MTI.membership_type_id
LEFT JOIN thegrint_grint.membership_type_company AS mtc 
ON M.membership_type_id = mtc.membership_type_id
WHERE amount > 0
AND  is_renewable = 1
AND reporting_group_id IN (1,2,3,4,5,6)
GROUP BY user_id) A
WHERE max_expiration_date <= '2024-03-03'
AND max_expiration_date >= '2024-02-26'
-- 336