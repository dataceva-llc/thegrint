DELIMITER $$

CREATE DEFINER = `1bT12@uylp12`@`%` PROCEDURE `Activation_Dashboard_Dev`()
BEGIN

-- Call the update_user_membership procedure to update the thegrint_analytics.user_membership table
CALL thegrint_analytics.update_user_membership();

-- Call the update_user_all_scores_data procedure to update the thegrint_analytics.user_all_scores_data table
CALL thegrint_analytics.update_user_all_scores_data();

-- Actual Table for Tableau --
DROP TABLE IF EXISTS thegrint_analytics.activation_metrics;
CREATE TABLE thegrint_analytics.activation_metrics AS
SELECT
	members.doj,
	members.last_login,
	members.verified,
	members.membership,
	members.country,
	members.zipcode,

	SUM(members.user_had_free_trial) AS user_had_free_trial,
	SUM(members.has_had_pro_membership) AS has_had_pro_membership,
	SUM(members.has_had_handicap_membership) AS has_had_handicap_membership,

	COUNT(DISTINCT all_scores.score_id) AS scores,
	COUNT(DISTINCT CASE WHEN DATEDIFF(all_scores.added_date, members.doj) <= 60 THEN all_scores.score_id END) AS scores_60_days,

	COUNT(CASE WHEN
		DATEDIFF(all_scores.added_date, members.doj) <= 60
		AND members.user_had_free_trial = 1
	THEN 1 END) AS user_had_free_trial_60_days,

	COUNT(CASE WHEN
		DATEDIFF(all_scores.added_date, members.doj) <= 60
		AND members.has_had_pro_membership = 1
	THEN 1 END) AS has_had_pro_membership_60_days,

	COUNT(CASE WHEN
		DATEDIFF(all_scores.added_date, members.doj) <= 60
		AND members.has_had_handicap_membership = 1
	THEN 1 END) AS has_had_handicap_membership_60_days,

	COUNT(whs.user_id) AS whs_linked,
	COUNT(CASE WHEN
		DATEDIFF(all_scores.added_date, members.doj) <= 60
		AND whs.user_id IS NOT NULL
	THEN 1 END) AS whs_linked_60_days,
	
	SUM(friends.friends) AS friends,
	SUM(CASE WHEN DATEDIFF(all_scores.added_date, members.doj) <= 60 THEN friends.friends END) AS friends_60_days,

	COUNT(DISTINCT all_scores.user_id) AS users,
	COUNT(*) as rows,
	NULL AS scores_added_date,
	NULL AS scores_round_date
FROM thegrint_analytics.user_all_scores_data AS all_scores
JOIN thegrint_analytics.user_membership AS members ON all_scores.user_id = members.user_id
LEFT JOIN (
	SELECT
		user_id,
		COUNT(*) AS friends
	FROM thegrint_grint.friendship_participant
	GROUP BY user_id
) AS friends ON all_scores.user_id = friends.user_id
LEFT JOIN thegrint_grint.whs_transition_user AS whs ON all_scores.user_id = whs.user_id
GROUP BY
	members.doj,
	members.last_login,
	members.verified,
	members.membership,
	members.country,
	members.zipcode;

END$$

DELIMITER ;