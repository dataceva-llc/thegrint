
select
	week_start,
    IFNULL(SUM(IF(expiration_date <= DATE_SUB(week_start, INTERVAL 1 DAY) and expiration_date >= DATE_SUB(week_start, INTERVAL 7 DAY),1,0)),0) AS churned_all,
    IFNULL(SUM(IF(expiration_date <= DATE_SUB(week_start, INTERVAL 1 DAY) and expiration_date >= DATE_SUB(week_start, INTERVAL 7 DAY) and old_membership_profile_id = 4 ,1,0)),0) AS churned_pro,
    IFNULL(SUM(IF(expiration_date <= DATE_SUB(week_start, INTERVAL 1 DAY) and expiration_date >= DATE_SUB(week_start, INTERVAL 7 DAY) and old_membership_profile_id = 5 ,1,0)),0) AS churned_pro_plus,
    IFNULL(SUM(IF(expiration_date > DATE_SUB(week_start, INTERVAL 1 DAY),1,0)),0) AS active_all,
    IFNULL(SUM(IF(expiration_date > DATE_SUB(week_start, INTERVAL 1 DAY) and renewal_period = 1,1,0)),0) AS active_monthly,
    IFNULL(SUM(IF(expiration_date > DATE_SUB(week_start, INTERVAL 1 DAY) and renewal_period = 1 AND old_membership_profile_id = 4,1,0)),0) AS active_monthly_pro,
    IFNULL(SUM(IF(expiration_date > DATE_SUB(week_start, INTERVAL 1 DAY) and renewal_period = 1 AND old_membership_profile_id = 5 AND membership_type_id>=123 and membership_type_id<=140 ,1,0)),0) AS active_monthly_pro_plus_gold,
    IFNULL(SUM(IF(expiration_date > DATE_SUB(week_start, INTERVAL 1 DAY) and renewal_period = 1 AND (old_membership_profile_id = 5 OR old_membership_profile_id =1) AND (membership_type_id<123 OR membership_type_id>140),1,0)),0) AS active_monthly_pro_plus,
    IFNULL(SUM(IF(expiration_date > DATE_SUB(week_start, INTERVAL 1 DAY) and renewal_period = 12,1,0)),0) AS active_annual,
    IFNULL(SUM(IF(expiration_date > DATE_SUB(week_start, INTERVAL 1 DAY) and renewal_period = 12 AND old_membership_profile_id = 4,1,0)),0) AS active_annual_pro,
    IFNULL(SUM(IF(expiration_date > DATE_SUB(week_start, INTERVAL 1 DAY) and renewal_period = 12 AND old_membership_profile_id = 5 AND membership_type_id>=123 and membership_type_id<=140,1,0)),0) AS active_annual_pro_plus_gold,
    IFNULL(SUM(IF(expiration_date > DATE_SUB(week_start, INTERVAL 1 DAY) and renewal_period = 12 AND (old_membership_profile_id = 5 OR old_membership_profile_id =1) AND (membership_type_id<123 OR membership_type_id>140),1,0)),0) AS active_annual_pro_plus
FROM (
SELECT
              weeks.week_start,
              user_id,
              membership_id,
              membership_payment_id,
              amount,
              transaction_amount,
              transaction_currency,
              purchase_date,
              expiration_date,
              cancelation_date,
              on_sale,
              trial_period,
              auto_renewing,
              purchase_date_system,
              
              is_renewable,
              company_id,

              membership_profile_id,
              old_membership_profile_id,
              membership_type_id,
              renewal_period,
              CAST(IF ( (@prev_user_id <> user_id OR @prev_user_id IS NULL), membership_id, @last_membership_id) AS UNSIGNED) AS last_membership_id,
              CAST(IF ( (@prev_user_id <> user_id OR @prev_user_id IS NULL), membership_payment_id, @last_membership_payment_id) AS UNSIGNED) AS last_membership_payment_id,
              IF ( (@prev_user_id <> user_id OR @prev_user_id IS NULL), 1, NULL) AS active_column,

              CASE WHEN purchase_date <= DATE_SUB(weeks.week_start, INTERVAL 1 DAY) THEN 1 ELSE NULL END AS active_week,

              @last_membership_id := (IF ( (@prev_user_id <> user_id OR @prev_user_id IS NULL), membership_id, @last_membership_id)) AS ignore_membership_id,
              @last_membership_payment_id := (IF ( (@prev_user_id <> user_id OR @prev_user_id IS NULL), membership_payment_id, @last_membership_payment_id)) AS ignore_membership_payment_id,
              @prev_user_id := user_id AS ignore_user_id
       FROM (
              SELECT
                     mp.user_id,
                     mp.membership_id,
                     mp.membership_payment_id,
                     mp.amount,
                     mp.transaction_amount,
                     mp.transaction_currency,
                     mp.purchase_date,
                     mp.expiration_date,
                     mp.cancelation_date,
                     mp.on_sale,
                     mp.trial_period,
                     mp.auto_renewing,
                     mp.purchase_date_system,
                     mt.membership_profile_id,
                     mt.old_membership_profile_id,
                     mt.membership_type_id,
                     mt.renewal_period,
                     mt.is_renewable,
                     mtc.company_id
              FROM thegrint_grint.membership_payment AS mp
              JOIN thegrint_grint.membership AS m ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id
              JOIN thegrint_grint.membership_type AS mt ON m.membership_type_id = mt.membership_type_id
              LEFT JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id
              ORDER BY
                     mp.user_id,
                     mp.purchase_date DESC,
                     mp.purchase_date_system DESC
       ) AS membership
       CROSS JOIN (
              SELECT DATE_ADD('2024-06-01', INTERVAL (7 - DAYOFWEEK('2024-06-01') + 2) % 7 DAY) + INTERVAL (seq - 1) WEEK AS week_start
              FROM (
              SELECT @rownum := @rownum + 1 AS seq
              FROM (
                     SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
              ) t1,
              (
                     SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
              ) t2,
              (
                     SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
              ) t3,
              (SELECT @rownum := -1) r
              ) d
              WHERE DATE_ADD('2024-06-01', INTERVAL (7 - DAYOFWEEK('2024-06-01') + 2) % 7 DAY) + INTERVAL (seq - 1) WEEK <= CURDATE()
       ) AS weeks
       CROSS JOIN (SELECT
              @prev_user_id := NULL,
              @last_membership_id := NULL,
              @last_membership_payment_id := NULL
       ) AS vars
       WHERE  company_id IS NULL
              AND amount > 0
              AND is_renewable = 1
              -- AND purchase_date <= DATE_SUB('2024-06-24', INTERVAL 1 day)
              AND membership_profile_id IN ( 4, 5 )
       HAVING active_column IS NOT NULL
       ORDER BY
              user_id,
              purchase_date DESC,
              purchase_date_system DESC
) AS membership
WHERE active_week IS NOT NULL
GROUP BY week_start