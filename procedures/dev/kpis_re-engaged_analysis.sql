-- DROP TABLE IF EXISTS temp_table_name;

-- CREATE TEMPORARY TABLE temp_table_name
SELECT
    count(DISTINCT CASE WHEN
        expiration_date < DATE_SUB('2024-05-06', INTERVAL 7 DAY)
        AND next_purchase_date >=  DATE_SUB('2024-05-06', INTERVAL 7 DAY)
        AND next_purchase_date <= DATE_SUB('2024-05-06', INTERVAL 1 DAY)
        AND DATEDIFF(next_purchase_date,expiration_date) < 60
        THEN user_id END) AS re_engaged_within_2_months,

    count(DISTINCT CASE WHEN
        next_purchase_date >= DATE_SUB('2024-05-06', INTERVAL 7 DAY) 
        AND next_purchase_date <= DATE_SUB('2024-05-06', INTERVAL 1 DAY)
        AND DATEDIFF(next_purchase_date,expiration_date) >= 60
        THEN user_id END) AS re_engaged_after_2_months
FROM (
    select
        mp0.*,
        mp1.user_id as next_user_id,
        mp1.purchase_date as next_purchase_date,
        mp1.expiration_date as next_expiration_date_date,
        mp1.membership_id as next_membership_id,
        mp1.membership_payment_id as next_membership_payment_id,
        mp1.membership_source_id as next_membership_source_id,
        mp1.source as next_source,
        mp1.membership_type_id as next_membership_type_id,
        mp1.renewal_period as next_renewal_period,
        mp1.amount as next_amount,
        mp1.trial_period as next_trial_period,
        mp1.membership_profile_id as next_membership_profile_id

        from (
            select
                mp.*,
                mt.*,
                ms.*
            FROM thegrint_grint.membership AS m
                INNER JOIN thegrint_grint.membership_payment AS mp ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id 
                INNER JOIN thegrint_grint.membership_type AS mt ON mt.membership_type_id = m.membership_type_id
                INNER JOIN thegrint_grint.membership_source AS ms ON ms.membership_source_id = m.membership_source_id 
                LEFT JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id
                WHERE
                    mtc.company_id is NULL
                    and mp.amount > 0
                    and mt.is_renewable = 1
        ) as mp0

        LEFT JOIN (
            select
                mp.*,
                mt.*,
                ms.*
            FROM thegrint_grint.membership AS m
                INNER JOIN thegrint_grint.membership_payment AS mp ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id
                INNER JOIN thegrint_grint.membership_type AS mt ON mt.membership_type_id = m.membership_type_id
                INNER JOIN thegrint_grint.membership_source AS ms ON ms.membership_source_id = m.membership_source_id
                LEFT JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id
                WHERE
                    mtc.company_id is NULL
                    and mp.amount > 0
                    and mt.is_renewable = 1
        ) as mp1 ON
            mp0.user_id = mp1.user_id
            and mp1.purchase_date = (
                select
                    min(tm.purchase_date)
                from (
                    select
                        mp_.user_id,
                        mp_.purchase_date
                    FROM  thegrint_grint.membership AS m_ 
                        INNER JOIN thegrint_grint.membership_payment AS mp_ ON mp_.membership_id = m_.membership_id AND mp_.user_id = m_.user_id 
                        INNER JOIN thegrint_grint.membership_type AS mt_ ON mt_.membership_type_id = m_.membership_type_id
                        LEFT JOIN thegrint_grint.membership_type_company AS mtc_ ON m_.membership_type_id = mtc_.membership_type_id 
                    WHERE
                        mtc_.company_id is NULL
                        and mp_.amount > 0
                        and mt_.is_renewable = 1
                        and mp_.purchase_date < '2024-05-06'
                ) AS tm
                where
                    mp0.purchase_date < tm.purchase_date
                    and mp0.user_id = tm.user_id
            )
) AS A 
WHERE
    A.purchase_date < '2024-05-06';


-- Re-Engaged WITHIN 2 Months
SELECT
    count(DISTINCT(user_id)) AS Re_engaged_2_Months
FROM temp_table_name
WHERE 
    expiration_date < DATE_SUB('2024-05-06', INTERVAL 7 DAY)
    AND next_purchase_date >= DATE_SUB('2024-05-06', INTERVAL 7 DAY)
    AND next_purchase_date <= DATE_SUB('2024-05-06', INTERVAL 1 DAY)
    AND DATEDIFF(next_purchase_date,expiration_date) < 60
LIMIT 1000;

-- Re-Engaged AFTER 2 Months
select
    count(DISTINCT(user_id)) as re_engaged
from temp_table_name 
where
    next_purchase_date >= DATE_SUB('2024-05-06', INTERVAL 7 DAY) 
    AND next_purchase_date <= DATE_SUB('2024-05-06', INTERVAL 1 DAY)
    AND DATEDIFF(next_purchase_date,expiration_date) >= 60
LIMIT 1000;