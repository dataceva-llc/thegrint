DELIMITER $$

CREATE DEFINER = `1bT12@uylp12`@`%` PROCEDURE `Activation_Dashboard_Dev`()
BEGIN

-- Actual Table for Tableau --
DROP TABLE IF EXISTS thegrint_analytics.activation_metrics;
CREATE TABLE thegrint_analytics.activation_metrics AS
SELECT
	user.doj,
	user.last_login,
	user.verified,
	members.membership,
	user.country,
	user.zipcode,

	SUM(members.user_had_free_trial) AS user_had_free_trial,
	SUM(members.has_had_pro_membership) AS has_had_pro_membership,
	SUM(members.has_had_handicap_membership) AS has_had_handicap_membership,

	COUNT(DISTINCT all_scores.score_id) AS scores,
	COUNT(DISTINCT CASE WHEN DATEDIFF(all_scores.added_date, user.doj) <= 60 THEN all_scores.score_id END) AS scores_60_days,

	COUNT(CASE WHEN
		DATEDIFF(all_scores.added_date, user.doj) <= 60
		AND members.user_had_free_trial = 1
	THEN 1 END) AS user_had_free_trial_60_days,

	COUNT(CASE WHEN
		DATEDIFF(all_scores.added_date, user.doj) <= 60
		AND members.has_had_pro_membership = 1
	THEN 1 END) AS has_had_pro_membership_60_days,

	COUNT(CASE WHEN
		DATEDIFF(all_scores.added_date, user.doj) <= 60
		AND members.has_had_handicap_membership = 1
	THEN 1 END) AS has_had_handicap_membership_60_days,

	COUNT(whs.user_id) AS whs_linked,
	COUNT(CASE WHEN
		DATEDIFF(all_scores.added_date, user.doj) <= 60
		AND whs.user_id IS NOT NULL
	THEN 1 END) AS whs_linked_60_days,
	
	SUM(friends.friends) AS friends,
	SUM(CASE WHEN DATEDIFF(all_scores.added_date, user.doj) <= 60 THEN friends.friends END) AS friends_60_days,

	COUNT(DISTINCT all_scores.user_id) AS users,
	COUNT(*) as rows,
	NULL AS scores_added_date,
	NULL AS scores_round_date
FROM (
	SELECT
        all_scores.scoreid AS score_id,
        all_scores.userid AS user_id,
        all_scores.added_date
    FROM (
            SELECT
                scoreid,
                userid,
                added_date
            FROM thegrint_analytics.user_score_replica
            UNION
            SELECT
                scoreid,
                userid,
                added_date
            FROM thegrint_analytics.user_score_nine_replica
        ) AS all_scores
) AS all_scores
JOIN thegrint_grint.grint_user AS user ON all_scores.user_id = user.user_id
LEFT JOIN (
	SELECT
		membership.user_id,
        CASE WHEN membership.user_id IS NOT NULL THEN 1 ELSE 0 END AS membership,
        COALESCE(MAX(mp.trial_period), 0) AS user_had_free_trial,
        MAX(
            CASE
                WHEN mpf.profile_name LIKE 'pro%' AND mpf.profile_name <> 'pro_gift' AND mp.trial_period = 0 THEN 1
                ELSE 0
            END
        ) AS has_had_pro_membership,
        MAX(
            CASE
                WHEN mpf.profile_name = 'handicap' AND mp.trial_period = 0 THEN 1
                ELSE 0
            END
        ) AS has_had_handicap_membership
    FROM thegrint_grint.membership AS membership
    LEFT JOIN thegrint_grint.membership_payment AS mp ON membership.user_id = mp.user_id AND membership.membership_id = mp.membership_id
    LEFT JOIN thegrint_grint.membership_type AS mt ON membership.membership_type_id = mt.membership_type_id
    LEFT JOIN thegrint_grint.membership_profile AS mpf ON mt.membership_profile_id = mpf.membership_profile_id
    GROUP BY membership.user_id
) AS members ON user.user_id = members.user_id
LEFT JOIN (
	SELECT
		user_id,
		COUNT(*) AS friends
	FROM thegrint_grint.friendship_participant
	GROUP BY user_id
) AS friends ON user.user_id = friends.user_id
LEFT JOIN thegrint_grint.whs_transition_user AS whs ON user.user_id = whs.user_id
GROUP BY
	user.doj,
	user.last_login,
	user.verified,
	members.membership,
	user.country,
	user.zipcode;

END$$

DELIMITER ;