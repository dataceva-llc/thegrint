CREATE DEFINER=`1bT12@uylp12`@`%` PROCEDURE `Activation_Dashboard`()
BEGIN

DROP TABLE IF EXISTS thegrint_analytics.all_scores;
CREATE TEMPORARY TABLE thegrint_analytics.all_scores AS
SELECT A.*, G.doj FROM (
SELECT scoreid, userid, added_date AS added_date, CAST(date AS DATE) AS score_date FROM thegrint_analytics.user_score_replica
UNION
SELECT scoreid, userid, added_date AS added_date, CAST(date AS DATE) AS score_date FROM thegrint_analytics.user_score_nine_replica) A
LEFT JOIN thegrint_grint.grint_user G ON
A.userid = G.user_id;
-- Duplicate Temporary Table for reuse --

DROP TABLE IF EXISTS thegrint_analytics.all_scores_dup;
CREATE TEMPORARY TABLE thegrint_analytics.all_scores_dup AS SELECT * FROM thegrint_analytics.all_scores;
-- Actual Table for Tableau --

DROP TABLE IF EXISTS thegrint_analytics.activation_metrics ;
CREATE TABLE thegrint_analytics.activation_metrics AS
SELECT doj, last_login, verified, members.membership, friends_60_days, friends, scores_60_days, scores,
country, zipcode, COUNT(DISTINCT grint_user.user_id) AS users, COUNT(*) as rows,
NULL AS  scores_added_date,
NULL AS scores_round_date
FROM thegrint_grint.grint_user
LEFT JOIN (SELECT DISTINCT user_id AS user_id, 1 AS membership FROM thegrint_grint.membership) AS members
ON grint_user.user_id = members.user_id

LEFT JOIN (SELECT f.user_id, COUNT(*) AS friends_60_days
	FROM thegrint_grint.friendship_participant AS f
	INNER JOIN thegrint_grint.grint_user AS g ON f.user_id = g.user_id
	WHERE DATEDIFF(f.created_at, g.doj) <= 60
	GROUP BY f.user_id) AS friends_60_days
ON grint_user.user_id = friends_60_days.user_id

LEFT JOIN (SELECT f.user_id, COUNT(*) AS friends
	FROM thegrint_grint.friendship_participant AS f
	INNER JOIN thegrint_grint.grint_user AS g ON f.user_id = g.user_id
	GROUP BY f.user_id) AS friends
ON grint_user.user_id = friends.user_id


LEFT JOIN (SELECT userid, COUNT(DISTINCT scoreid) AS scores_60_days FROM thegrint_analytics.all_scores WHERE DATEDIFF(added_date, doj) <= 60 GROUP BY userid) scores_60_days
ON grint_user.user_id = scores_60_days.userid
LEFT JOIN (SELECT userid, COUNT(DISTINCT scoreid) AS scores FROM thegrint_analytics.all_scores_dup  GROUP BY userid) scores
ON grint_user.user_id = scores.userid
GROUP BY doj, last_login, verified, members.membership, friends, country, zipcode;

END