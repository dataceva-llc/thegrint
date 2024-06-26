CREATE DEFINER=`a@n8L$t1c44s`@`%` PROCEDURE `hooked_kpis`(IN `revision_date` DATE)
BEGIN

DECLARE finished INTEGER DEFAULT 0; 
DECLARE userId INTEGER UNSIGNED; 

DECLARE cur_users CURSOR FOR
SELECT u.user_id
FROM thegrint_grint.grint_user AS u 
WHERE u.doj <= revision_date;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1; OPEN cur_users;

get_pilot_users: LOOP 
	FETCH cur_users INTO userId; 
	IF(finished = 1) 
		THEN LEAVE get_pilot_users; 
	END IF;

	#USER 18-HOLE scores_tracked
	SELECT 
	IFNULL(SUM(IF(s18.added_date < revision_date,1,0)),0) AS scores_tracked
	INTO @scores_tracked
	FROM thegrint_grint.user_score AS s18
	WHERE s18.userid=userId and s18.creater = userId;
    
    
	#USER 9-HOLE scores_tracked
	SELECT
	IFNULL(SUM(IF(s9.added_date < revision_date,1,0)),0) AS scores_tracked_nine
	INTO @scores_tracked_nine
	FROM thegrint_grint.user_score_nine AS s9
	WHERE s9.userid=userId and s9.creater = userId;

    
	#USER 18-HOLE SCORES LAST YEAR, TOTAL SCORES
	SELECT 
	IFNULL(SUM(IF(s18.added_date BETWEEN DATE_SUB(revision_date, INTERVAL 365 DAY) AND revision_date,1,0)),0) AS scores_last_year,  
	IFNULL(SUM(IF(s18.added_date < revision_date,1,0)),0) AS total_score
	INTO @scores_last_year, @total_score
	FROM thegrint_grint.user_score AS s18
	WHERE s18.userid=userId;
	
	#USER 9-HOLE SCORES LAST YEAR, TOTAL SCORES
	SELECT
	IFNULL(SUM(IF(s9.added_date BETWEEN DATE_SUB(revision_date, INTERVAL 365 DAY) AND revision_date,1,0)),0) AS scores_last_year,  
	IFNULL(SUM(IF(s9.added_date < revision_date,1,0)),0) AS total_score
	INTO @scores_last_year_nine, @total_score_nine
	FROM thegrint_grint.user_score_nine AS s9
	WHERE s9.userid=userId;
	
	#USER LOGIN LAST MONTH AND LAST 3 MONTHS
	SELECT 
	IFNULL(SUM(IF(vl.login_time BETWEEN DATE_SUB(revision_date, INTERVAL 7 DAY) AND revision_date,1,0)),0) AS logins_1_week,
	IFNULL(SUM(IF(vl.login_time BETWEEN DATE_SUB(revision_date, INTERVAL 30 DAY) AND revision_date,1,0)),0) AS logins_1_month,
    IFNULL(SUM(IF(vl.login_time BETWEEN DATE_SUB(revision_date, INTERVAL 90 DAY) AND revision_date,1,0)),0) AS logins_3_months
	INTO @logins_1_week, @logins_1_month, @logins_3_months
	FROM thegrint_grint.visit_logs AS vl
	WHERE vl.user_id=userId;
    
	#TOTAL PAYMENTS
    SELECT 
    IFNULL(count(*),0) as total_payments
	INTO @total_payments
	FROM thegrint_grint.membership_payment AS mp
	WHERE mp.user_id=userId AND mp.purchase_date <= revision_date;
    
	#TOTAL SPENT LAST YEAR
    SELECT 
    IFNULL(SUM(mp.amount),0) as total_spent_last_year
	INTO @total_spent_last_year
	FROM thegrint_grint.membership_payment AS mp
	WHERE mp.user_id=userId and mp.purchase_date BETWEEN DATE_SUB(revision_date, INTERVAL 365 DAY) AND revision_date;
    
    #NUMBER OF REFERRALS
    SELECT
    IFNULL(COUNT(*),0) as referees
    INTO @referees
    FROM thegrint_grint.grint_user
    WHERE referrer = CONCAT('',userId) and doj<= revision_date;
    
    #NUMBER OF FRIENDS
    SELECT
    IFNULL(COUNT(*),0) as friends
    INTO @friends
    FROM thegrint_grint.friendship_participant AS fp
    WHERE fp.user_id = userId and (fp.created_at is null or fp.created_at <= revision_date); 
    
    #TOTAL LEADERBOARDS LAST YEAR
    SELECT
    IFNULL(COUNT(*),0) as total_leaderboards_created_last_year
    INTO @total_leaderboards_created_last_year
    FROM thegrint_grint.grint_leaderboard AS tl
    WHERE tl.owner_ID = userId and (tl.date BETWEEN DATE_SUB(revision_date, INTERVAL 365 DAY) AND revision_date); 
    
    #HANDICAP
	SELECT 
	CASE WHEN COUNT(*) > 0 then 1 ELSE 0 END AS HANDICAP INTO @HANDICAP
	FROM 
	(SELECT user, date, CASE WHEN handicap_company_id IS NULL THEN 3 WHEN handicap_company_id = 3 THEN 3 Else 7 END AS handicap_company_id FROM thegrint_grint.handicap_revisions) AS HR
	INNER JOIN
	(SELECT * FROM thegrint_grint.default_handicap_provider) AS DF 
	ON HR.USER = DF.user_id and HR.handicap_company_id = DF.company_id AND HR.user = userId AND HR.DATE <= revision_date;
    
	INSERT INTO hooked_kpis VALUES (revision_date, userId, @scores_last_year+@scores_last_year_nine, @friends, @total_score+@total_score_nine, @logins_3_months, @logins_1_month,@HANDICAP,@referees,@scores_tracked + @scores_tracked_nine,0,@total_leaderboards_created_last_year,@total_payments, @total_spent_last_year,@logins_1_week);    
end loop;



END