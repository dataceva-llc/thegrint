DELIMITER $$

CREATE DEFINER = `1bT12@uylp12`@`%` PROCEDURE `Activation_Dashboard`() BEGIN

DROP TABLE IF EXISTS thegrint_analytics.tmp_all_scores;
CREATE TABLE thegrint_analytics.tmp_all_scores AS
SELECT
	A.*,
	G.doj
FROM
	(
		SELECT
			scoreid,
			userid,
			added_date AS added_date,
			CAST(date AS DATE) AS score_date
		FROM
			thegrint_analytics.user_score_replica
		UNION
		SELECT
			scoreid,
			userid,
			added_date AS added_date,
			CAST(date AS DATE) AS score_date
		FROM
			thegrint_analytics.user_score_nine_replica
	) A
	LEFT JOIN thegrint_grint.grint_user G ON A .userid = G.user_id;

-- Actual Table for Tableau --
DROP TABLE IF EXISTS thegrint_analytics.activation_metrics;
CREATE TABLE thegrint_analytics.activation_metrics AS
SELECT
	doj,
	last_login,
	verified,
	members.membership,
	SUM(members.user_had_free_trial) AS user_had_free_trial,
	SUM(members.has_had_pro_membership) AS has_had_pro_membership,
	SUM(members.has_had_handicap_membership) AS has_had_handicap_membership,
	SUM(members_60_days.user_had_free_trial) AS user_had_free_trial_60_days,
	SUM(members_60_days.has_had_pro_membership) AS has_had_pro_membership_60_days,
	SUM(members_60_days.has_had_handicap_membership) AS has_had_handicap_membership_60_days,
	SUM(whs.whs_linked) AS whs_linked,
	SUM(whs_60_days.whs_linked) AS whs_linked_60_days,
	friends_60_days,
	friends,
	scores_60_days,
	scores,
	country,
	zipcode,
	COUNT(DISTINCT grint_user.user_id) AS users,
	COUNT(*) as rows,
	NULL AS scores_added_date,
	NULL AS scores_round_date
FROM
	thegrint_grint.grint_user
	LEFT JOIN (
		SELECT
			m.user_id,
			1 AS membership,
			MAX(mp.trial_period) AS user_had_free_trial,
			MAX(
				CASE
					WHEN mpf.profile_name LIKE 'pro%'
					AND mpf.profile_name <> 'pro_gift'
					AND mp.trial_period = 0 THEN 1
					ELSE 0
				END
			) AS has_had_pro_membership,
			MAX(
				CASE
					WHEN mpf.profile_name = 'handicap'
					AND mp.trial_period = 0 THEN 1
					ELSE 0
				END
			) AS has_had_handicap_membership
		FROM
			thegrint_grint.membership m
			JOIN thegrint_grint.membership_payment mp on m.user_id = mp.user_id
			AND m.membership_id = mp.membership_id
			JOIN thegrint_grint.membership_type mt on m.membership_type_id = mt.membership_type_id
			JOIN thegrint_grint.membership_profile mpf on mt.membership_profile_id = mpf.membership_profile_id
		GROUP BY
			m.user_id
	) AS members ON grint_user.user_id = members.user_id
	LEFT JOIN (
		SELECT
			m.user_id,
			1 AS membership,
			MAX(mp.trial_period) AS user_had_free_trial,
			MAX(
				CASE
					WHEN mpf.profile_name LIKE 'pro%'
					AND mpf.profile_name <> 'pro_gift'
					AND mp.trial_period = 0 THEN 1
					ELSE 0
				END
			) AS has_had_pro_membership,
			MAX(
				CASE
					WHEN mpf.profile_name = 'handicap'
					AND mp.trial_period = 0 THEN 1
					ELSE 0
				END
			) AS has_had_handicap_membership
		FROM
			thegrint_grint.membership m
			JOIN thegrint_analytics.tmp_all_scores s ON m.user_id = s.userid
			JOIN thegrint_grint.membership_payment mp on m.user_id = mp.user_id
			AND m.membership_id = mp.membership_id
			JOIN thegrint_grint.membership_type mt on m.membership_type_id = mt.membership_type_id
			JOIN thegrint_grint.membership_profile mpf on mt.membership_profile_id = mpf.membership_profile_id
		WHERE
			DATEDIFF(s.added_date, s.doj) <= 60
		GROUP BY
			m.user_id
	) AS members_60_days ON grint_user.user_id = members.user_id
	LEFT JOIN (
		SELECT
			f.user_id,
			COUNT(*) AS friends_60_days
		FROM
			thegrint_grint.friendship_participant AS f
			INNER JOIN thegrint_grint.grint_user AS g ON f.user_id = g.user_id
		WHERE
			DATEDIFF(f.created_at, g.doj) <= 60
		GROUP BY
			f.user_id
	) AS friends_60_days ON grint_user.user_id = friends_60_days.user_id
	LEFT JOIN (
		SELECT
			f.user_id,
			COUNT(*) AS friends
		FROM
			thegrint_grint.friendship_participant AS f
			INNER JOIN thegrint_grint.grint_user AS g ON f.user_id = g.user_id
		GROUP BY
			f.user_id
	) AS friends ON grint_user.user_id = friends.user_id
	LEFT JOIN (
		SELECT
			userid,
			COUNT(DISTINCT scoreid) AS scores_60_days
		FROM
			thegrint_analytics.tmp_all_scores
		WHERE
			DATEDIFF(added_date, doj) <= 60
		GROUP BY
			userid
	) scores_60_days ON grint_user.user_id = scores_60_days.userid
	LEFT JOIN (
		SELECT
			userid,
			COUNT(DISTINCT scoreid) AS scores
		FROM
			thegrint_analytics.tmp_all_scores
		GROUP BY
			userid
	) scores ON grint_user.user_id = scores.userid
	LEFT JOIN (
		SELECT
			user_id AS userid,
			1 AS whs_linked
		FROM
			thegrint_grint.whs_transition_user
		WHERE user_id IS NOT NULL
		GROUP BY
			user_id
	) whs ON grint_user.user_id = whs.userid
	LEFT JOIN (
		SELECT
			user_id AS userid,
			1 AS whs_linked
		FROM
			thegrint_grint.whs_transition_user
		JOIN thegrint_analytics.tmp_all_scores s ON user_id = s.userid
		WHERE
			user_id IS NOT NULL
			AND DATEDIFF(s.added_date, s.doj) <= 60
		GROUP BY
			user_id
	) whs_60_days ON grint_user.user_id = whs.userid
GROUP BY
	doj,
	last_login,
	verified,
	members.membership,
	friends,
	country,
	zipcode;

END$$

DELIMITER ;