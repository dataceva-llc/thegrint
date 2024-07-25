CREATE DEFINER=`1bT12@uylp12`@`%` PROCEDURE `Activation_Dashboard`()
BEGIN

DROP TABLE IF EXISTS thegrint_analytics.all_scores;
CREATE TEMPORARY TABLE thegrint_analytics.all_scores AS
SELECT
	A.*,
	G.doj
FROM (
	SELECT scoreid, userid, added_date AS added_date, date AS score_date FROM thegrint_analytics.user_score_replica
	UNION
	SELECT scoreid, userid, added_date AS added_date, date AS score_date FROM thegrint_analytics.user_score_nine_replica
) A
LEFT JOIN thegrint_grint.grint_user G ON A.userid = G.user_id;
-- Duplicate Temporary Table for reuse --

DROP TABLE IF EXISTS thegrint_analytics.activation_metrics ;
CREATE TABLE thegrint_analytics.activation_metrics AS
SELECT
	grint_user.doj,
	grint_user.last_login,
	grint_user.verified,
	grint_user.country,
	grint_user.zipcode,
	members.membership,
	friends.friends_60_days,
	friends.friends,
	scores.scores_60_days,
	scores.scores,
	SUM(members.user_had_free_trial) AS user_had_free_trial,
	SUM(members.user_had_free_trial_60_days) AS user_had_free_trial_60_days,
	SUM(members.has_had_pro_membership) AS has_had_pro_membership,
	SUM(members.has_had_pro_membership_60_days) AS has_had_pro_membership_60_days,
	SUM(members.has_had_handicap_membership) AS has_had_handicap_membership,
	SUM(members.has_had_handicap_membership_60_days) AS has_had_handicap_membership_60_days,
	
	SUM(whs.whs_user) AS whs_linked,
	SUM(whs.whs_user_60_days) AS whs_linked_60_days,
	COUNT(DISTINCT grint_user.user_id) AS users,
	COUNT(*) as rows,
	NULL AS  scores_added_date,
	NULL AS scores_round_date
FROM thegrint_grint.grint_user
	LEFT JOIN (
		SELECT
			membership.user_id,
			1 AS membership,
			user.doj,

			MAX(CASE
				WHEN mp.trial_period >= 1 THEN 1
				ELSE 0
			END) AS user_had_free_trial,

			MAX(CASE
				WHEN DATEDIFF(mp.purchase_date, user.doj) <= 60
				AND mp.trial_period >= 1 THEN 1
				ELSE 0
			END) AS user_had_free_trial_60_days,

			MAX(CASE
				WHEN mt.reporting_group_id IN (1,2,3,4,5,6,10) 
				AND mp.trial_period = 0 THEN 1
				ELSE 0
			END) AS has_had_pro_membership,

			MAX(CASE
				WHEN DATEDIFF(mp.purchase_date, user.doj) <= 60
				AND mt.reporting_group_id IN (1,2,3,4,5,6,10)
				AND mp.trial_period = 0 THEN 1
				ELSE 0
			END) AS has_had_pro_membership_60_days,

			MAX(CASE
				WHEN mt.reporting_group_id IN (7,8,9,10)
				AND mp.trial_period = 0 THEN 1
				ELSE 0
			END) AS has_had_handicap_membership,

			MAX(CASE
				WHEN DATEDIFF(mp.purchase_date, user.doj) <= 60
				AND mt.reporting_group_id IN (7,8,9,10)
				AND mp.trial_period = 0 THEN 1
				ELSE 0
			END) AS has_had_handicap_membership_60_days

		FROM thegrint_grint.membership AS membership
			INNER JOIN thegrint_grint.grint_user AS user ON membership.user_id = user.user_id
			LEFT JOIN thegrint_grint.membership_payment AS mp ON membership.user_id = mp.user_id AND membership.membership_id = mp.membership_id
			LEFT JOIN thegrint_grint.membership_type AS mt ON membership.membership_type_id = mt.membership_type_id
			LEFT JOIN thegrint_grint.membership_profile AS mpf ON mt.membership_profile_id = mpf.membership_profile_id
		GROUP BY membership.user_id
	) AS members ON grint_user.user_id = members.user_id

	LEFT JOIN (
		SELECT
			j_gu.user_id,
			1 AS whs_user,
			CASE WHEN DATEDIFF(CAST(j_ua.date_created AS DATE), j_gu.doj) <= 60 THEN 1 ELSE 0 END AS whs_user_60_days
		FROM thegrint_grint.grint_user AS j_gu
		JOIN thegrint_grint.user_account AS j_ua ON j_gu.user_id = j_ua.user_id AND j_ua.company_id = 3
		GROUP BY j_gu.user_id
	) AS whs ON grint_user.user_id = whs.user_id

	LEFT JOIN (
		SELECT
			f.user_id,
			COUNT(*) AS friends,
			COUNT(CASE WHEN DATEDIFF(f.created_at, g.doj) <= 60 THEN f.user_id END) AS friends_60_days
		FROM thegrint_grint.friendship_participant AS f
			INNER JOIN thegrint_grint.grint_user AS g ON f.user_id = g.user_id
		GROUP BY f.user_id
	) AS friends ON grint_user.user_id = friends.user_id

	LEFT JOIN (
		SELECT
			userid,
			COUNT(DISTINCT scoreid) AS scores,
			COUNT(DISTINCT CASE
						   WHEN DATEDIFF(added_date, doj) <= 60 THEN scoreid
			END) AS scores_60_days
		FROM thegrint_analytics.all_scores
		GROUP BY userid
	) scores ON grint_user.user_id = scores.userid

GROUP BY
	grint_user.doj,
	grint_user.last_login,
	grint_user.verified,
	grint_user.country,
	grint_user.zipcode,
	members.membership,
	friends.friends;

END