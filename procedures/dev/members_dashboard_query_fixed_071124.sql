drop temporary table thegrint_analytics.temp_table_name_2;
CREATE TEMPORARY TABLE thegrint_analytics.temp_table_name_2
select
    -- Check if the user id is the same as the previous user id
    cast(if(@prev_user_id = user_id, @next_purchase_date, NULL) as date) as next_purchase_date,
    cast(if(@prev_user_id = user_id, @next_purchase_date_sys, NULL) as date) as next_purchase_date_sys,
    cast(if(@prev_user_id = user_id, @next_expiration_date, NULL) as date) as next_expiration_date,

    -- IF(cancelation_date < expiration_date, cancelation_date, expiration_date) as expiration_date_fixed,
	DATEDIFF(@next_purchase_date,expiration_date) < 60 as within_60_days,
	DATEDIFF(@next_purchase_date_sys,expiration_date) < 60 as within_60_days_system,

    -- Select the columns you want to return
    subq.*,

    -- Set the previous user id to the current user id
    @prev_user_id := user_id as user_id_var,

    -- Set the previous payment date to the current payment date
    @next_purchase_date := purchase_date as ignore_purchase_date_var,
    @next_purchase_date_sys := purchase_date_system as ignore_purchase_date_sys_var,
    @next_expiration_date := expiration_date as ignore_expiration_date_var

FROM (
    SELECT
        mp.*,
        mt.*,
        ms.*
    from thegrint_grint.membership AS m
    INNER JOIN thegrint_grint.membership_payment AS mp ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id 
    INNER JOIN thegrint_grint.membership_type AS mt ON mt.membership_type_id = m.membership_type_id
    INNER JOIN thegrint_grint.membership_source AS ms ON ms.membership_source_id = m.membership_source_id 
    LEFT JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id
    WHERE
        mtc.company_id is NULL
        and mp.amount > 0
        and mt.is_renewable = 1
    ORDER BY
        m.user_id,
        mp.purchase_date desc
) subq
CROSS JOIN (
    SELECT
        @prev_user_id := NULL,
        @next_purchase_date := NULL,
        @next_purchase_date_sys := NULL,
        @next_expiration_date := NULL
) vars;

-- Actual query broken down by days
SELECT
    -- DATE(next_purchase_date) AS purchase_day,
    -- COUNT(DISTINCT(user_id)) AS Re_engaged_2_Months
    -- case when DATEDIFF(next_purchase_date, expiration_date) < 60 then 'Within 60 Days' else 'After 60 Days' end as re_engaged_within_2_months,
	tmp.*
FROM thegrint_analytics.temp_table_name_2 tmp
WHERE 
    expiration_date < DATE_SUB('2024-04-29', INTERVAL 7 DAY)
    AND next_purchase_date >= DATE_SUB('2024-04-29', INTERVAL 7 DAY)
    AND next_purchase_date <= DATE_SUB('2024-04-29', INTERVAL 1 DAY)
    AND DATEDIFF(next_purchase_date, expiration_date) < 60
-- GROUP BY DATE(next_purchase_date)
ORDER BY DATE(next_purchase_date)
LIMIT 1000;