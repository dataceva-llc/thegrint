CREATE DEFINER=`a@n8L$t1c44s`@`%` PROCEDURE `get_kpis`(IN `revisiondate` DATE)
BEGIN

DROP TABLE IF EXISTS temp_table_name ;
CREATE TEMPORARY TABLE temp_table_name SELECT * FROM 
(select mp0.*, mp1.user_id as next_user_id, mp1.purchase_date as next_purchase_date, mp1.expiration_date as next_expiration_date_date,
mp1.membership_id as next_membership_id, mp1.membership_payment_id as next_membership_payment_id, mp1.membership_source_id as next_membership_source_id, mp1.source as next_source,
mp1.membership_type_id as next_membership_type_id, mp1.renewal_period as next_renewal_period, mp1.amount as next_amount, mp1.trial_period as next_trial_period, mp1.membership_profile_id as next_membership_profile_id
from 
(select mp.*, mt.*, ms.* FROM thegrint_grint.membership AS m
	INNER JOIN thegrint_grint.membership_payment AS mp ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id 
    INNER JOIN thegrint_grint.membership_type AS mt ON mt.membership_type_id = m.membership_type_id
	INNER JOIN thegrint_grint.membership_source AS ms ON ms.membership_source_id = m.membership_source_id 
    LEFT JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id WHERE mtc.company_id is NULL and mp.amount >0 and mt.is_renewable = 1
    ) as mp0
LEFT JOIN 
( select mp.*, mt.*, ms.* FROM thegrint_grint.membership AS m
	INNER JOIN thegrint_grint.membership_payment AS mp ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id
    INNER JOIN thegrint_grint.membership_type AS mt ON mt.membership_type_id = m.membership_type_id
	INNER JOIN thegrint_grint.membership_source AS ms ON ms.membership_source_id = m.membership_source_id
    LEFT JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id WHERE mtc.company_id is NULL and mp.amount > 0 and mt.is_renewable = 1
    ) as mp1 
ON mp0.user_id = mp1.user_id and mp1.purchase_date = (select min(tm.purchase_date) from 
																(select mp_.user_id, mp_.purchase_date 
																FROM  thegrint_grint.membership AS m_ 
																INNER JOIN thegrint_grint.membership_payment AS mp_ ON mp_.membership_id = m_.membership_id AND mp_.user_id = m_.user_id 
																INNER JOIN thegrint_grint.membership_type AS mt_ ON mt_.membership_type_id = m_.membership_type_id
                                                                LEFT JOIN thegrint_grint.membership_type_company AS mtc_ ON m_.membership_type_id = mtc_.membership_type_id 
																WHERE mtc_.company_id is NULL and mp_.amount > 0 and mt_.is_renewable = 1 and mp_.purchase_date < revisiondate) AS tm
													where mp0.purchase_date < tm.purchase_date and mp0.user_id = tm.user_id)) AS A 
                                                    WHERE A.purchase_date < revisiondate;

SELECT count(*) as LAST_WEEK_RENEWAL INTO @LAST_WEEK_RENEWAL from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_SUB(revisiondate, INTERVAL 7 DAY) AND next_purchase_date is not null;

SELECT count(*) as LAST_WEEK_CHURNED INTO @LAST_WEEK_CHURNED from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_SUB(revisiondate, INTERVAL 7 DAY) AND next_purchase_date is null;

SELECT count(*) as LAST_WEEK_RENEWAL_ANNUAL INTO @LAST_WEEK_RENEWAL_ANNUAL from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_SUB(revisiondate, INTERVAL 7 DAY) AND next_purchase_date is not null AND renewal_period = 12;

SELECT count(*) as LAST_WEEK_CHURNED_ANNUAL INTO @LAST_WEEK_CHURNED_ANNUAL from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_SUB(revisiondate, INTERVAL 7 DAY) AND next_purchase_date is null AND renewal_period = 12;

SELECT count(*) as LAST_WEEK_RENEWAL_MONTHLY INTO @LAST_WEEK_RENEWAL_MONTHLY from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_SUB(revisiondate, INTERVAL 7 DAY) AND next_purchase_date is not null AND renewal_period = 1;

SELECT count(*) as LAST_WEEK_CHURNED_MONTHLY INTO @LAST_WEEK_CHURNED_MONTHLY from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_SUB(revisiondate, INTERVAL 7 DAY) AND next_purchase_date is null AND renewal_period = 1;

SELECT (@LAST_WEEK_RENEWAL/(@LAST_WEEK_CHURNED+@LAST_WEEK_RENEWAL))*100 AS Last_week into @Last_week;
SELECT (@LAST_WEEK_RENEWAL_ANNUAL/(@LAST_WEEK_CHURNED_ANNUAL+@LAST_WEEK_RENEWAL_ANNUAL))*100 AS Last_week_annual into @Last_week_annual;
SELECT (@LAST_WEEK_RENEWAL_MONTHLY/(@LAST_WEEK_CHURNED_MONTHLY+@LAST_WEEK_RENEWAL_MONTHLY))*100 AS Last_week_monthly into @Last_week_monthly;

SELECT count(*) as LAST_MONTH_RENEWAL INTO @LAST_MONTH_RENEWAL from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_ADD(DATE_SUB(revisiondate, INTERVAL 1 DAY), INTERVAL -DAY(DATE_SUB(revisiondate, INTERVAL 1 DAY))+1 DAY) AND next_purchase_date is not null;

SELECT count(*) as LAST_MONTH_CHURNED INTO @LAST_MONTH_CHURNED from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_ADD(DATE_SUB(revisiondate, INTERVAL 1 DAY), INTERVAL -DAY(DATE_SUB(revisiondate, INTERVAL 1 DAY))+1 DAY) AND next_purchase_date is null;

SELECT count(*) as LAST_MONTH_RENEWAL_ANNUAL INTO @LAST_MONTH_RENEWAL_ANNUAL from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_ADD(DATE_SUB(revisiondate, INTERVAL 1 DAY), INTERVAL -DAY(DATE_SUB(revisiondate, INTERVAL 1 DAY))+1 DAY) AND next_purchase_date is not null AND renewal_period = 12;

SELECT count(*) as LAST_MONTH_CHURNED_ANNUAL INTO @LAST_MONTH_CHURNED_ANNUAL from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_ADD(DATE_SUB(revisiondate, INTERVAL 1 DAY), INTERVAL -DAY(DATE_SUB(revisiondate, INTERVAL 1 DAY))+1 DAY) AND next_purchase_date is null AND renewal_period = 12;

SELECT count(*) as LAST_MONTH_RENEWAL_MONTHLY INTO @LAST_MONTH_RENEWAL_MONTHLY from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_ADD(DATE_SUB(revisiondate, INTERVAL 1 DAY), INTERVAL -DAY(DATE_SUB(revisiondate, INTERVAL 1 DAY))+1 DAY) AND next_purchase_date is not null AND renewal_period = 1;

SELECT count(*) as LAST_MONTH_CHURNED_MONTHLY INTO @LAST_MONTH_CHURNED_MONTHLY from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  DATE_ADD(DATE_SUB(revisiondate, INTERVAL 1 DAY), INTERVAL -DAY(DATE_SUB(revisiondate, INTERVAL 1 DAY))+1 DAY) AND next_purchase_date is null AND renewal_period = 1;

SELECT (@LAST_MONTH_RENEWAL/(@LAST_MONTH_CHURNED+@LAST_MONTH_RENEWAL))*100 AS MTD into @MTD;
SELECT (@LAST_MONTH_RENEWAL_ANNUAL/(@LAST_MONTH_CHURNED_ANNUAL+@LAST_MONTH_RENEWAL_ANNUAL))*100 AS MTD_annual into @MTD_annual;
SELECT (@LAST_MONTH_RENEWAL_MONTHLY/(@LAST_MONTH_CHURNED_MONTHLY+@LAST_MONTH_RENEWAL_MONTHLY))*100 AS MTD_monthly into @MTD_monthly;


SELECT count(*) as LAST_YEAR_RENEWAL INTO @LAST_YEAR_RENEWAL from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is not null;

SELECT count(*) as LAST_YEAR_CHURNED INTO @LAST_YEAR_CHURNED from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is null;

SELECT count(*) as LAST_YEAR_RENEWAL_ANNUAL INTO @LAST_YEAR_RENEWAL_ANNUAL from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is not null AND renewal_period = 12;

SELECT count(*) as LAST_YEAR_CHURNED_ANNUAL INTO @LAST_YEAR_CHURNED_ANNUAL from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is null AND renewal_period = 12;

SELECT count(*) as LAST_YEAR_RENEWAL_MONTHLY INTO @LAST_YEAR_RENEWAL_MONTHLY from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is not null AND renewal_period = 1;

SELECT count(*) as LAST_YEAR_CHURNED_MONTHLY INTO @LAST_YEAR_CHURNED_MONTHLY from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is null AND renewal_period = 1;

SELECT (@LAST_YEAR_RENEWAL/(@LAST_YEAR_CHURNED+@LAST_YEAR_RENEWAL))*100 AS YTD into @YTD;
SELECT (@LAST_YEAR_RENEWAL_ANNUAL/(@LAST_YEAR_CHURNED_ANNUAL+@LAST_YEAR_RENEWAL_ANNUAL))*100 AS MTD_annual into @YTD_annual;
SELECT (@LAST_YEAR_RENEWAL_MONTHLY/(@LAST_YEAR_RENEWAL_MONTHLY+@LAST_YEAR_CHURNED_MONTHLY))*100 AS MTD_monthly into @YTD_monthly;


SELECT count(*) as LAST_YEAR_RENEWAL_PRO INTO @LAST_YEAR_RENEWAL_PRO from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is not null AND old_membership_profile_id = 4 and renewal_period = 12;

SELECT count(*) as LAST_YEAR_CHURNED_PRO INTO @LAST_YEAR_CHURNED_PRO from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is null AND old_membership_profile_id = 4  and renewal_period = 12;

SELECT count(*) as LAST_YEAR_RENEWAL_PRO_PLUS INTO @LAST_YEAR_RENEWAL_PRO_PLUS from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is not null AND old_membership_profile_id = 5 and renewal_period = 12;

SELECT count(*) as LAST_YEAR_CHURNED_PRO_PLUS INTO @LAST_YEAR_CHURNED_PRO_PLUS from temp_table_name where expiration_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND 
expiration_date >=  MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY)),1) AND next_purchase_date is null AND old_membership_profile_id = 5  and renewal_period = 12;

SELECT (@LAST_YEAR_RENEWAL_PRO/(@LAST_YEAR_CHURNED_PRO+@LAST_YEAR_RENEWAL_PRO))*100 AS YTD_pro INTO @YTD_pro;
SELECT (@LAST_YEAR_RENEWAL_PRO_PLUS/(@LAST_YEAR_CHURNED_PRO_PLUS+@LAST_YEAR_RENEWAL_PRO_PLUS))*100 AS YTD_pro_plus INTO @YTD_pro_plus;

SELECT
IFNULL(SUM(IF(membership_profile_id = 5 AND next_membership_profile_id = 4 ,1,0)),0) AS downgraded_from_pro_plus,
IFNULL(SUM(IF(membership_profile_id = 2 AND next_membership_profile_id = 4 ,1,0)),0) AS upgrade_from_handicap_pro,
IFNULL(SUM(IF(membership_profile_id = 4 AND next_membership_profile_id = 5,1,0)),0) AS upgraded_from_pro,
IFNULL(SUM(IF(membership_profile_id = 2 AND next_membership_profile_id = 5,1,0)),0) AS upgraded_from_handicap_pro_plus,
IFNULL(SUM(IF(old_membership_profile_id = 4 AND next_membership_type_id >=123,1,0)),0) AS crossgrade_from_pro_to_pro_plus

INTO @downgraded_from_pro_plus, @upgrade_from_handicap_pro, @upgraded_from_pro, @upgraded_from_handicap_pro_plus, @crossgrade_from_pro_to_pro_plus
FROM temp_table_name WHERE
next_purchase_date <=  DATE_SUB(revisiondate, INTERVAL 1 DAY) AND next_purchase_date >=  DATE_SUB(revisiondate, INTERVAL 7 DAY);

DROP TABLE IF EXISTS last_membership ;
CREATE TEMPORARY TABLE last_membership

(`user_id` int(10) unsigned NOT NULL,
`membership_id` tinyint(3) unsigned NOT NULL,
`membership_payment_id` tinyint(3) unsigned NOT NULL,
`amount` decimal(10,2) unsigned NOT NULL,
`transaction_amount` decimal(10,2) unsigned NOT NULL,
`transaction_currency` char(3) NOT NULL DEFAULT 'USD',
`purchase_date` date NOT NULL,
`expiration_date` date NOT NULL,
`cancelation_date` date DEFAULT NULL,
`on_sale` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0=regular_price 1=on_sale',
`trial_period` tinyint(1) unsigned DEFAULT '0' COMMENT 'If the membership is trial period',
`auto_renewing` tinyint(1) unsigned DEFAULT '1',
`purchase_date_system` datetime DEFAULT NULL,
`membership_profile_id` tinyint(3) unsigned NOT NULL,
`membership_type_id` tinyint(3) unsigned NOT NULL,
`old_membership_profile_id` tinyint(3) unsigned NOT NULL,
`renewal_period` tinyint(3) unsigned NOT NULL,
`last_membership_id` tinyint(3) unsigned NOT NULL,
`last_membership_payment_id` tinyint(3) unsigned NOT NULL,
PRIMARY KEY (`user_id`,`membership_id`,`membership_payment_id`))

select mp.*, mt.membership_profile_id, mt.old_membership_profile_id, mt.membership_type_id ,mt.renewal_period, 
(select mp1.membership_id from
thegrint_grint.membership_payment AS mp1
INNER JOIN thegrint_grint.membership as m1 ON mp1.membership_id = m1.membership_id AND mp1.user_id = m1.user_id
INNER JOIN thegrint_grint.membership_type as mt1 ON m1.membership_type_id = mt1.membership_type_id
LEFT JOIN thegrint_grint.membership_type_company as mtc1 ON m1.membership_type_id = mtc1.membership_type_id
WHERE mtc1.company_id is NULL AND mt1.is_renewable = 1 AND mp1.amount > 0 and mp1.user_id = mp.user_id and mp1.purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and mt1.membership_profile_id in (4,5)
order by mp1.purchase_date desc, mp1.purchase_date_system desc
limit 1
) as last_membership_id, 

(select mp1.membership_payment_id from
thegrint_grint.membership_payment AS mp1
INNER JOIN thegrint_grint.membership as m1 ON mp1.membership_id = m1.membership_id AND mp1.user_id = m1.user_id
INNER JOIN thegrint_grint.membership_type as mt1 ON m1.membership_type_id = mt1.membership_type_id
LEFT JOIN thegrint_grint.membership_type_company as mtc1 ON m1.membership_type_id = mtc1.membership_type_id
WHERE mtc1.company_id is NULL AND mt1.is_renewable = 1 AND mp1.amount > 0 and mp1.user_id = mp.user_id and mp1.purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and mt1.membership_profile_id in (4,5)
order by mp1.purchase_date desc, mp1.purchase_date_system desc
limit 1
) as last_membership_payment_id
from
thegrint_grint.membership_payment AS mp
INNER JOIN thegrint_grint.membership as m ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id
INNER JOIN thegrint_grint.membership_type as mt ON m.membership_type_id = mt.membership_type_id
LEFT JOIN thegrint_grint.membership_type_company as mtc ON m.membership_type_id = mtc.membership_type_id
WHERE mtc.company_id is NULL AND mp.amount > 0 AND mt.is_renewable = 1 
and mp.purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and mt.membership_profile_id in (4,5)
having membership_id = last_membership_id and membership_payment_id = last_membership_payment_id;

select
IFNULL(SUM(IF(expiration_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and expiration_date >= DATE_SUB(revisiondate, INTERVAL 7 DAY),1,0)),0) AS churned_all,
IFNULL(SUM(IF(expiration_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and expiration_date >= DATE_SUB(revisiondate, INTERVAL 7 DAY) and old_membership_profile_id = 4 ,1,0)),0) AS churned_pro,
IFNULL(SUM(IF(expiration_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and expiration_date >= DATE_SUB(revisiondate, INTERVAL 7 DAY) and old_membership_profile_id = 5 ,1,0)),0) AS churned_pro_plus,
IFNULL(SUM(IF(expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY),1,0)),0) AS active_all,
IFNULL(SUM(IF(expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY) and renewal_period = 1,1,0)),0) AS active_monthly,
IFNULL(SUM(IF(expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY) and renewal_period = 1 AND old_membership_profile_id = 4,1,0)),0) AS active_monthly_pro,
IFNULL(SUM(IF(expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY) and renewal_period = 1 AND old_membership_profile_id = 5 AND membership_type_id>=123 and membership_type_id<=140 ,1,0)),0) AS active_monthly_pro_plus_gold,
IFNULL(SUM(IF(expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY) and renewal_period = 1 AND (old_membership_profile_id = 5 OR old_membership_profile_id =1) AND (membership_type_id<123 OR membership_type_id>140),1,0)),0) AS active_monthly_pro_plus,
IFNULL(SUM(IF(expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY) and renewal_period = 12,1,0)),0) AS active_annual,
IFNULL(SUM(IF(expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY) and renewal_period = 12 AND old_membership_profile_id = 4,1,0)),0) AS active_annual_pro,
IFNULL(SUM(IF(expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY) and renewal_period = 12 AND old_membership_profile_id = 5 AND membership_type_id>=123 and membership_type_id<=140,1,0)),0) AS active_annual_pro_plus_gold,
IFNULL(SUM(IF(expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY) and renewal_period = 12 AND (old_membership_profile_id = 5 OR old_membership_profile_id =1) AND (membership_type_id<123 OR membership_type_id>140),1,0)),0) AS active_annual_pro_plus
INTO @churned_all, @churned_pro, @churned_pro_plus, @active_all, @active_monthly, @active_monthly_pro, @active_monthly_pro_plus_gold,@active_monthly_pro_plus, @active_annual, @active_annual_pro, @active_annual_pro_plus_gold, @active_annual_pro_plus
from last_membership;

DROP TABLE IF EXISTS new_memberships;
CREATE TEMPORARY TABLE new_memberships
SELECT mp.user_id, min(mp.purchase_date) AS first_purchase,
(select mt1.membership_profile_id from
thegrint_grint.membership AS m1 INNER JOIN thegrint_grint.membership_payment AS mp1 
ON mp1.membership_id = m1.membership_id AND mp1.user_id = m1.user_id
INNER JOIN thegrint_grint.membership_type as mt1 ON m1.membership_type_id = mt1.membership_type_id
LEFT JOIN  thegrint_grint.membership_type_company as mtc1 ON m1.membership_type_id = mtc1.membership_type_id
WHERE mtc1.company_id is NULL AND mp1.amount > 0 and mt1.is_renewable = 1 and mp1.user_id = mp.user_id order by mp1.purchase_date, mp1.purchase_date_system limit 1
) as membership_profile_id,
(select mt1.renewal_period from
thegrint_grint.membership AS m1 INNER JOIN thegrint_grint.membership_payment AS mp1 
ON mp1.membership_id = m1.membership_id AND mp1.user_id = m1.user_id
INNER JOIN thegrint_grint.membership_type as mt1 ON m1.membership_type_id = mt1.membership_type_id
LEFT JOIN  thegrint_grint.membership_type_company as mtc1 ON m1.membership_type_id = mtc1.membership_type_id
WHERE mtc1.company_id is NULL AND mp1.amount > 0 and mt1.is_renewable = 1 and mp1.user_id = mp.user_id order by mp1.purchase_date, mp1.purchase_date_system limit 1
) as renewal_period
FROM thegrint_grint.membership AS m INNER JOIN thegrint_grint.membership_payment AS mp 
ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id
INNER JOIN thegrint_grint.membership_type as mt ON m.membership_type_id = mt.membership_type_id
LEFT JOIN  thegrint_grint.membership_type_company as mtc ON m.membership_type_id = mtc.membership_type_id
WHERE mtc.company_id is NULL  AND mp.amount > 0 and mt.is_renewable = 1
GROUP BY m.user_id
HAVING first_purchase >= DATE_SUB(revisiondate, INTERVAL 7 DAY) and first_purchase <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND membership_profile_id IN (4,5);

SELECT count(*) as new_all into @new_all FROM new_memberships;
SELECT count(*) as new_pro into @new_pro  FROM new_memberships where membership_profile_id = 4;
SELECT count(*) as new_pro_plus into @new_pro_plus  FROM new_memberships where membership_profile_id = 5;

SELECT count(*) as new_annual into @new_annual  FROM new_memberships where renewal_period = 12;
SELECT count(*) as new_monthly into @new_monthly  FROM new_memberships where renewal_period = 1;

DROP TABLE IF EXISTS new_memberships_by_source;
CREATE TEMPORARY TABLE new_memberships_by_source 
SELECT * FROM 
(select np.*,
CASE
	When (gu.app_type is null or gu.app_type = 'C') and gu.website_registered != '0' and gu.website_registered != 0 Then gu.website_registered
	When gu.app_type is not null and gu.app_type != 'C' Then gu.app_type
	else null
END AS 'Source'
FROM new_memberships as np
LEFT JOIN (SELECT app_type, user_id, website_registered FROM thegrint_grint.grint_user) as gu on np.USER_ID = gu.user_id) AS p;

SELECT count(*) as new_mem_android into @new_mem_android FROM (select distinct user_id FROM new_memberships_by_source where Source = 'A') as d;
SELECT count(*) as new_mem_ios into @new_mem_ios FROM (select distinct user_id FROM new_memberships_by_source where Source = 'I') as d;
SELECT count(*) as new_mem_web into @new_mem_web FROM (select distinct user_id FROM new_memberships_by_source where Source = 1 or Source = '1') as d;
SELECT count(*) as new_mem_null into @new_mem_null FROM (select distinct user_id FROM new_memberships_by_source where (Source != 1 and Source != '1' and Source != 'I' and Source != 'A') or (Source is null)) as d;

if @new_mem_null > 0 THEN
	SET @new_mem_ios_ = round(((@new_mem_ios/(@new_mem_ios+@new_mem_android+@new_mem_web))*@new_mem_null) + @new_mem_ios,0);
    SET @new_mem_android_ = round(((@new_mem_android/(@new_mem_ios+@new_mem_android+@new_mem_web))*@new_mem_null) + @new_mem_android,0);
    SET @new_mem_web_ = round(((@new_mem_web/(@new_mem_ios+@new_mem_android+@new_mem_web))*@new_mem_null) + @new_mem_web,0);
END IF;

DROP TABLE IF EXISTS new_registered;
CREATE TEMPORARY TABLE new_registered 
select user_id, 
CASE
	When (app_type is null or app_type = 'C') and website_registered != '0' and website_registered != 0 Then website_registered
	When app_type is not null and app_type != 'C' Then app_type
	else null
END AS 'Source'

from thegrint_grint.grint_user where doj >= DATE_SUB(revisiondate, INTERVAL 7 DAY) and doj <= DATE_SUB(revisiondate, INTERVAL 1 DAY);

select count(*) AS new_users into @new_users from new_registered;
select count(*) AS new_android into @new_android from new_registered where Source = 'A';
select count(*) AS new_ios into @new_ios from new_registered where Source = 'I';
select count(*) AS new_web into @new_web from new_registered where Source = 1 or Source = '1';
select count(*) AS new_null into @new_null from new_registered where (Source != 1 and Source != '1' and Source != 'I' and Source != 'A') or (Source is null);

if @new_null > 0 THEN
	SET @new_ios_ = round(@new_ios/(@new_ios+@new_android+@new_web)*@new_null + @new_ios,0);
	SET @new_android_ = round(@new_android/(@new_ios+@new_android+@new_web)*@new_null + @new_android,0);
	SET @new_web_ = round(@new_web/(@new_ios+@new_android+@new_web)*@new_null + @new_web,0);
END IF;

SELECT count(*) as total_users INTO @total_users FROM thegrint_grint.grint_user where doj <= DATE_SUB(revisiondate, INTERVAL 1 DAY);

DROP TABLE IF EXISTS memberships_usga;
CREATE TEMPORARY TABLE memberships_usga
(`user_id` int(10) unsigned NOT NULL,
`membership_id` tinyint(3) unsigned NOT NULL,
`membership_type_id` tinyint(3) unsigned NOT NULL,
`membership_source_id` tinyint(3) unsigned NOT NULL,
`membership_payment_id` tinyint(3) unsigned NOT NULL,
`purchase_date` date NOT NULL,
`expiration_date` date NOT NULL,
`type` char(20) NOT NULL,
INDEX user_id (user_ID))

SELECT  m.*, mp.purchase_date, mp.expiration_date,
           CASE
				When wtu.ghin IS NOT NULL OR NOT EXISTS (SELECT wl.log_id FROM thegrint_grint.whs_log AS wl WHERE wl.ghin = ma.account_id AND ACTION='CREATE_USER' LIMIT 1) then 'is_transition_user'
				else 'is_new_user'
				END AS 'type'
		FROM thegrint_grint.membership AS m
		INNER JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id AND mtc.company_id = 3
		INNER JOIN thegrint_grint.membership_payment AS mp ON mp.user_id = m.user_id AND mp.membership_id = m.membership_id
		INNER JOIN thegrint_grint.membership_account AS ma ON ma.user_id = m.user_id AND ma.membership_id = mp.membership_id and ma.membership_payment_id = mp.membership_payment_id
		LEFT JOIN thegrint_grint.whs_transition_user AS wtu ON wtu.ghin = ma.account_id;

SELECT count(distinct(user_id)) AS all_usga INTO @all_usga FROM memberships_usga WHERE purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY);

DROP TABLE IF EXISTS new_memberships_usga;
CREATE TEMPORARY TABLE new_memberships_usga
SELECT user_id, type, min(purchase_date) AS min_purchase FROM memberships_usga GROUP BY user_id HAVING min_purchase >= DATE_SUB(revisiondate, INTERVAL 7 DAY) and min_purchase <= DATE_SUB(revisiondate, INTERVAL 1 DAY);

SELECT count(*) as all_new_usga INTO @all_new_usga from new_memberships_usga;
SELECT count(*) as all_new_usga_new INTO @all_new_usga_new from new_memberships_usga WHERE type = 'is_new_user';
SELECT count(*) as all_new_usga_trans INTO @all_new_usga_trans from new_memberships_usga WHERE type = 'is_transition_user';

DROP TABLE IF EXISTS usga_thegrint;
CREATE TEMPORARY TABLE usga_thegrint  
SELECT m.* FROM last_membership AS m INNER JOIN 
(SELECT user_id as user_id_usga, expiration_date FROM memberships_usga WHERE purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY)) AS um 
ON m.user_id = um.user_id_usga;

SELECT count(DISTINCT(user_id)) AS usga_membership_thegrint into @usga_membership_thegrint FROM usga_thegrint WHERE expiration_date >  DATE_SUB(revisiondate, INTERVAL 1 DAY);
SELECT count(DISTINCT(user_id)) AS usga_churned_thegrint    into @usga_churned_thegrint    FROM usga_thegrint WHERE expiration_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY);

select count(DISTINCT(user_id)) as re_engaged INTO @re_engaged from temp_table_name 
where next_purchase_date >= DATE_SUB(revisiondate, INTERVAL 7 DAY) 
AND next_purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY)
AND DATEDIFF(next_purchase_date,expiration_date) >= 60; 

SELECT count(DISTINCT(user_id)) AS Re_engaged_2_Months INTO @Re_engaged_2_Months FROM temp_table_name WHERE 
expiration_date < DATE_SUB(revisiondate, INTERVAL 7 DAY) AND
next_purchase_date >=  DATE_SUB(revisiondate, INTERVAL 7 DAY) AND
next_purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND
DATEDIFF(next_purchase_date,expiration_date) < 60;


SELECT COUNT(*) AS hooked into @hooked FROM hooked_kpis
WHERE logins_1_month>=1 AND logins_3_months >= 4 AND scores_last_12_months >= 5 AND friends >= 5 AND total_score >= 20 and revision_date = revisiondate;

SELECT COUNT(*) AS engaged into @engaged FROM hooked_kpis
WHERE logins_1_month>=1 and logins_3_months >= 4 and scores_last_12_months >= 1 and revision_date = revisiondate;

SELECT COUNT(*) AS on_boarded into @on_boarded FROM hooked_kpis
WHERE logins_3_months >= 1 and scores_last_12_months >= 1 and revision_date = revisiondate;

DROP TABLE IF EXISTS tmp_user_account;
CREATE TEMPORARY TABLE tmp_user_account 
SELECT * FROM thegrint_grint.user_account;

SELECT COUNT(*) as handicaps into @handicaps FROM tmp_user_account WHERE company_id = 3 and date_created <= DATE_SUB(revisiondate, INTERVAL 1 DAY);
SELECT COUNT(*) as active_handicap into @active_handicap FROM tmp_user_account WHERE company_id = 3 and status = 1 and date_created <= DATE_SUB(revisiondate, INTERVAL 1 DAY);
SELECT COUNT(*) as inactive_handicap into @inactive_handicap FROM tmp_user_account WHERE company_id = 3 and status = 0 and date_created <= DATE_SUB(revisiondate, INTERVAL 1 DAY);

SELECT COUNT(*) as new_handicaps into @new_handicaps FROM tmp_user_account WHERE company_id = 3 and date_created <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and date_created >= DATE_SUB(revisiondate, INTERVAL 7 DAY);
SELECT COUNT(*) as created_handicap into @created_handicap FROM tmp_user_account WHERE company_id = 3 and creation_type = 1 and date_created <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and date_created >= DATE_SUB(revisiondate, INTERVAL 7 DAY);
SELECT COUNT(*) as linked_handicap into @linked_handicap FROM tmp_user_account WHERE company_id = 3 and creation_type = 2 and date_created <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and date_created >= DATE_SUB(revisiondate, INTERVAL 7 DAY);

SELECT
IFNULL(SUM(IF(tg_has_access = 1,1,0)),0) AS handicap_consent,
IFNULL(SUM(IF(tg_has_access = 1 AND creation_type = 1,1,0)),0) AS consent_created,
IFNULL(SUM(IF(tg_has_access = 1 AND creation_type = 2,1,0)),0) AS consent_linked
INTO @handicap_consent, @consent_created, @consent_linked
FROM thegrint_grint.user_account;

set @total_active =  @active_all + @all_usga - @usga_membership_thegrint;

DROP TABLE IF EXISTS temp_table_name_2 ;
CREATE TEMPORARY TABLE temp_table_name_2 SELECT * FROM 
(select mp0.*, mp1.user_id as next_user_id, mp1.purchase_date as next_purchase_date, mp1.expiration_date as next_expiration_date_date,
mp1.membership_id as next_membership_id, mp1.membership_payment_id as next_membership_payment_id, mp1.membership_source_id as next_membership_source_id, mp1.source as next_source,
mp1.membership_type_id as next_membership_type_id, mp1.renewal_period as next_renewal_period, mp1.amount as next_amount, mp1.trial_period as next_trial_period, mp1.membership_profile_id as next_membership_profile_id
from 
(select mp.*, mt.*, ms.* FROM thegrint_grint.membership AS m
	INNER JOIN thegrint_grint.membership_payment AS mp ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id 
    INNER JOIN thegrint_grint.membership_type AS mt ON mt.membership_type_id = m.membership_type_id
	INNER JOIN thegrint_grint.membership_source AS ms ON ms.membership_source_id = m.membership_source_id 
    LEFT JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id WHERE mtc.company_id is NULL and mt.is_renewable = 1
    ) as mp0
LEFT JOIN 
( select mp.*, mt.*, ms.* FROM thegrint_grint.membership AS m
	INNER JOIN thegrint_grint.membership_payment AS mp ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id
    INNER JOIN thegrint_grint.membership_type AS mt ON mt.membership_type_id = m.membership_type_id
	INNER JOIN thegrint_grint.membership_source AS ms ON ms.membership_source_id = m.membership_source_id
    LEFT JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id WHERE mtc.company_id is NULL and mt.is_renewable = 1
    ) as mp1 
ON mp0.user_id = mp1.user_id and mp1.purchase_date = (select min(tm.purchase_date) from 
																(select mp_.user_id, mp_.purchase_date 
																FROM  thegrint_grint.membership AS m_ 
																INNER JOIN thegrint_grint.membership_payment AS mp_ ON mp_.membership_id = m_.membership_id AND mp_.user_id = m_.user_id 
																INNER JOIN thegrint_grint.membership_type AS mt_ ON mt_.membership_type_id = m_.membership_type_id
                                                                LEFT JOIN thegrint_grint.membership_type_company AS mtc_ ON m_.membership_type_id = mtc_.membership_type_id 
																WHERE mtc_.company_id is NULL and mt_.is_renewable = 1 and mp_.purchase_date < revisiondate) AS tm
													where mp0.purchase_date < tm.purchase_date and mp0.user_id = tm.user_id)) AS A 
                                                    WHERE A.purchase_date < revisiondate;
                                                    
                                                    
                                                    
SELECT count(distinct(nm.user_id)) as pro_from_trial_after_1_week into @pro_from_trial_after_1_week
FROM 
new_memberships as nm
LEFT JOIN
(SELECT * FROM temp_table_name_2 
		  WHERE trial_period = 1  
		  AND expiration_date < DATE_SUB(revisiondate, INTERVAL 7 DAY)
		  AND next_purchase_date >= DATE_SUB(revisiondate, INTERVAL 7 DAY) 
          AND next_purchase_date <= DATE_SUB(revisiondate, INTERVAL 7 DAY)) as tt
ON nm.user_id = tt.user_id
WHERE tt.user_id is not null;

select count(distinct(nm.user_id)) as pro_from_trial  into @pro_from_trial
FROM 
new_memberships as nm
LEFT JOIN
(SELECT * FROM temp_table_name_2 
		  WHERE trial_period = 1  
		  AND expiration_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY)
          AND expiration_date >= DATE_SUB(revisiondate, INTERVAL 7 DAY)
		  AND next_purchase_date IS NOT NULL) as tt
ON nm.user_id = tt.user_id
WHERE tt.user_id is not null and tt.user_id not in (@pro_from_trial_after_1_week);

select count(distinct(user_id)) as not_pro_from_trial into @not_pro_from_trial from temp_table_name_2 
where trial_period = 1 AND next_purchase_date IS NULL and expiration_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) and expiration_date >= DATE_SUB(revisiondate, INTERVAL 7 DAY);

select count(distinct(user_id)) as new_trial into @new_trial from temp_table_name_2 
where trial_period = 1 AND purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND purchase_date >=  DATE_SUB(revisiondate, INTERVAL 7 DAY);

select count(distinct(user_id)) as on_trial into @on_trial from temp_table_name_2 
where trial_period = 1 AND expiration_date > DATE_SUB(revisiondate, INTERVAL 1 DAY);

DROP TABLE IF EXISTS temp_table_name_3;
CREATE TEMPORARY TABLE temp_table_name_3
select mp.*, mt.*, ms.*, mtc.company_id FROM thegrint_grint.membership AS m
	INNER JOIN thegrint_grint.membership_payment AS mp ON mp.membership_id = m.membership_id AND mp.user_id = m.user_id 
    INNER JOIN thegrint_grint.membership_type AS mt ON mt.membership_type_id = m.membership_type_id
	INNER JOIN thegrint_grint.membership_source AS ms ON ms.membership_source_id = m.membership_source_id 
    LEFT JOIN thegrint_grint.membership_type_company AS mtc ON m.membership_type_id = mtc.membership_type_id WHERE mp.amount > 0 and mt.is_renewable = 1;

SELECT CASE WHEN count(distinct(user_id)) <> 0 THEN sum(amount) / count(distinct(user_id)) ELSE 0 END AS arpu_TheGrint_USGA INTO @arpu_TheGrint_USGA FROM temp_table_name_3 WHERE purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND  purchase_date >= DATE_SUB(revisiondate, INTERVAL 365 DAY) and company_id is null or company_id is not null;
SELECT CASE WHEN count(distinct(user_id)) <> 0 THEN sum(amount) / count(distinct(user_id)) ELSE 0 END AS arpu_USGA INTO @arpu_USGA FROM temp_table_name_3 WHERE purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND  purchase_date >= DATE_SUB(revisiondate, INTERVAL 365 DAY) and company_id IS NOT NULL;
SELECT CASE WHEN count(distinct(user_id)) <> 0 THEN sum(amount) / count(distinct(user_id)) ELSE 0 END AS arpu_TheGrint INTO @arpu_TheGrint FROM temp_table_name_3 WHERE purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND  purchase_date >= DATE_SUB(revisiondate, INTERVAL 365 DAY) and company_id IS NULL;
SELECT CASE WHEN count(distinct(user_id)) <> 0 THEN sum(amount) / count(distinct(user_id)) ELSE 0 END AS arpmu_TheGrint INTO @arpmu_TheGrint FROM temp_table_name_3 WHERE purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND  purchase_date >= DATE_SUB(revisiondate, INTERVAL 365 DAY) and company_id IS NULL AND renewal_period = 1;
SELECT CASE WHEN count(distinct(user_id)) <> 0 THEN sum(amount) / count(distinct(user_id)) ELSE 0 END AS arpyu_TheGrint INTO @arpyu_TheGrint FROM temp_table_name_3 WHERE purchase_date <= DATE_SUB(revisiondate, INTERVAL 1 DAY) AND  purchase_date >= DATE_SUB(revisiondate, INTERVAL 365 DAY) and company_id IS NULL AND renewal_period = 12;

SELECT count(*) AS mau INTO @mau FROM hooked_kpis WHERE revision_date = revisiondate and logins_1_month > 0;
SELECT count(*) AS wau INTO @wau FROM hooked_kpis WHERE revision_date = revisiondate and logins_1_week > 0;

select value as current_run_rate into @current_run_rate from score_metrics where id = 2 and date = revisiondate;
select value as last_year_run_rate into @last_year_run_rate from score_metrics where id = 3 and date = revisiondate;

SELECT DATE_ADD(revisiondate,  INTERVAL - 365 DAY)                as today_last_year     into @today_last_year;
SELECT MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY))-1,1) as first_day_last_year into @first_day_last_year;
SELECT MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY))  ,1) as first_day_this_year into @first_day_this_year;

DROP TEMPORARY TABLE IF EXISTS last_year_temp;
CREATE TEMPORARY TABLE last_year_temp AS
SELECT user_id, 1 as bought_ly, company_id, renewal_period FROM temp_table_name_3 WHERE purchase_date >= @first_day_last_year AND purchase_date < @today_last_year;

DROP TEMPORARY TABLE IF EXISTS this_year_temp;
CREATE TEMPORARY TABLE this_year_temp AS
SELECT user_id, 1 as bought_ty, company_id, renewal_period FROM temp_table_name_3 WHERE purchase_date >= @first_day_this_year AND purchase_date < revisiondate;

SELECT (sum(bought_ty)/sum(bought_ly))*100 AS last_year_this_year INTO @last_year_this_year
FROM (SELECT distinct(user_id), bought_ly FROM last_year_temp WHERE company_id IS NULL) AS ly LEFT JOIN (SELECT distinct(user_id), bought_ty FROM this_year_temp WHERE company_id IS NULL) AS ty ON ly.user_id = ty.user_id;

SELECT (sum(bought_ty)/sum(bought_ly))*100 AS last_year_this_year_annual INTO @last_year_this_year_annual
FROM (SELECT distinct(user_id), bought_ly FROM last_year_temp WHERE company_id IS NULL AND renewal_period = 12) AS ly LEFT JOIN (SELECT  distinct(user_id), bought_ty FROM this_year_temp WHERE company_id IS NULL AND renewal_period = 12) AS ty ON ly.user_id = ty.user_id;

SELECT (sum(bought_ty)/sum(bought_ly))*100 AS last_year_this_year_monthly INTO @last_year_this_year_monthly
FROM (SELECT distinct(user_id), bought_ly FROM last_year_temp WHERE company_id IS NULL AND renewal_period = 1) AS ly LEFT JOIN (SELECT distinct(user_id), bought_ty FROM this_year_temp WHERE company_id IS NULL  AND renewal_period = 1) AS ty ON ly.user_id = ty.user_id;

SELECT (sum(bought_ty)/sum(bought_ly))*100 AS last_year_this_year_any INTO @last_year_this_year_any
FROM (SELECT distinct(user_id), bought_ly FROM last_year_temp) AS ly LEFT JOIN (SELECT distinct(user_id), bought_ty FROM this_year_temp) AS ty ON ly.user_id = ty.user_id;

SELECT (sum(bought_ty)/sum(bought_ly))*100 AS last_year_this_year_any_annual INTO @last_year_this_year_any_annual
FROM (SELECT distinct(user_id), bought_ly FROM last_year_temp WHERE renewal_period = 12) AS ly LEFT JOIN (SELECT distinct(user_id), bought_ty FROM this_year_temp) AS ty ON ly.user_id = ty.user_id;

SELECT (sum(bought_ty)/sum(bought_ly))*100 AS last_year_this_year_any_monthly INTO @last_year_this_year_any_monthly
FROM (SELECT distinct(user_id), bought_ly FROM last_year_temp WHERE renewal_period = 1) AS ly LEFT JOIN (SELECT distinct(user_id), bought_ty FROM this_year_temp) AS ty ON ly.user_id = ty.user_id;
    
SELECT (sum(bought_ty)/sum(bought_ly))*100 AS last_year_this_year_USGA INTO @last_year_this_year_USGA
FROM (SELECT distinct(user_id), bought_ly FROM last_year_temp WHERE company_id IS NOT NULL) AS ly LEFT JOIN (SELECT distinct(user_id), bought_ty FROM this_year_temp WHERE company_id IS NOT NULL) AS ty ON ly.user_id = ty.user_id;

SELECT (sum(bought_ty)/sum(bought_ly))*100 AS last_year_this_year_USGA_any into @last_year_this_year_USGA_any
FROM 
(SELECT distinct(user_id), bought_ly FROM last_year_temp WHERE company_id IS NOT NULL) AS ly
LEFT JOIN 
(SELECT distinct(al_ty.user_id), 1 as bought_ty FROM
	(SELECT user_id FROM this_year_temp WHERE company_id IS NOT NULL 
		UNION 
	SELECT user_id FROM thegrint_grint.user_account WHERE STATUS = 1 AND company_id = 3) AS al_ty) as ty
ON ly.user_id = ty.user_id;

SELECT value AS current_run_rate INTO @current_run_rate FROM score_metrics WHERE DATE = revisiondate AND id = 2;
SELECT value AS last_year_run_rate INTO @last_year_run_rate FROM score_metrics WHERE DATE = revisiondate AND id = 3;

INSERT INTO kpis_report
  ( date, kpi, value )
VALUES
  (revisiondate, 0, @total_active),
  (revisiondate, 1, @active_all),
  (revisiondate, 2, @active_annual),
  (revisiondate, 3, @active_annual_pro),  
  (revisiondate, 4, @active_annual_pro_plus),  
  (revisiondate, 5, @active_monthly),
  (revisiondate, 6, @active_monthly_pro),
  (revisiondate, 7, @active_monthly_pro_plus),    
  (revisiondate, 8, @new_all),
  (revisiondate, 9, @new_pro),
  (revisiondate, 10, @downgraded_from_pro_plus),
  (revisiondate, 11, @upgrade_from_handicap_pro),
  (revisiondate, 12, @new_pro_plus),
  (revisiondate, 13, @upgraded_from_pro),
  (revisiondate, 14, @upgraded_from_handicap_pro_plus),
  (revisiondate, 15, @new_mem_android_),
  (revisiondate, 16, @new_mem_ios_),
  (revisiondate, 17, @new_mem_web_),
  (revisiondate, 18, @re_engaged),
  (revisiondate, 19, @Re_engaged_2_Months),
  (revisiondate, 20, @LAST_WEEK_RENEWAL),
  (revisiondate, 21, @churned_all),
  (revisiondate, 22, @churned_pro),
  (revisiondate, 23, @churned_pro_plus),
  (revisiondate, 24, @all_usga),
  (revisiondate, 25, @usga_membership_thegrint),
  (revisiondate, 26, @all_new_usga),
  (revisiondate, 27, @all_new_usga_new),
  (revisiondate, 28, @all_new_usga_trans),
  (revisiondate, 29, @total_users),
  (revisiondate, 30, @new_users),
  (revisiondate, 31, @new_ios_),
  (revisiondate, 32, @new_android_),
  (revisiondate, 33, @new_web_),
  (revisiondate, 34, @on_boarded),
  (revisiondate, 35, @engaged),
  (revisiondate, 36, @hooked),
  (revisiondate, 37, @handicaps),
  (revisiondate, 38, @active_handicap),
  (revisiondate, 39, @inactive_handicap),
  (revisiondate, 40, @new_handicaps),
  (revisiondate, 41, @created_handicap),
  (revisiondate, 42, @linked_handicap),
  (revisiondate, 43, @handicap_consent),
  (revisiondate, 44, @consent_created),
  (revisiondate, 45, @consent_linked),  
  (revisiondate, 46, @Last_week_monthly),
  (revisiondate, 47, @Last_week_annual),
  (revisiondate, 48, @Last_week),
  (revisiondate, 49, @MTD_monthly),
  (revisiondate, 50, @MTD_annual),
  (revisiondate, 51, @MTD),
  (revisiondate, 52, @YTD_monthly),
  (revisiondate, 53, @YTD_annual),
  (revisiondate, 54, @YTD),
  (revisiondate, 55, @YTD_pro),
  (revisiondate, 56, @YTD_pro_plus),
  (revisiondate,57, @active_monthly_pro_plus_gold),
  (revisiondate,58, @active_annual_pro_plus_gold),
  (revisiondate,59, @crossgrade_from_pro_to_pro_plus),
  (revisiondate,60, @new_trial),
  (revisiondate,61, @pro_from_trial),
  (revisiondate,62, @arpu_TheGrint),
  (revisiondate,63, @arpu_TheGrint_USGA),
  (revisiondate,64, @on_trial),
  (revisiondate,65, @not_pro_from_trial),
  (revisiondate,66, @pro_from_trial_after_1_week),
  (revisiondate,67, @usga_churned_thegrint),
  (revisiondate,68, @arpmu_TheGrint),
  (revisiondate,69, @arpyu_TheGrint),
  (revisiondate,70, @arpu_USGA),
  (revisiondate,71, @new_annual),
  (revisiondate,72, @new_monthly),
  (revisiondate,75, @last_year_this_year),
  (revisiondate,76, @last_year_this_year_annual),
  (revisiondate,77, @last_year_this_year_monthly),
  (revisiondate,78, @last_year_this_year_any),
  (revisiondate,79, @last_year_this_year_any_annual),
  (revisiondate,80, @last_year_this_year_any_monthly),
  (revisiondate,81, @last_year_this_year_USGA),
  (revisiondate,82, @last_year_this_year_USGA_any),
  (revisiondate,73, @current_run_rate),
  (revisiondate,74, @last_year_run_rate),
  (revisiondate,83, @wau),
  (revisiondate,84, @mau);
  
END