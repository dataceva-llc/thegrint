CREATE DEFINER=`a@n8L$t1c44s`@`%` PROCEDURE `get_north_star_metrics`(IN `revision_date` DATE)
BEGIN

#18 Hole Scores and 9 Hole Scores
DROP TABLE IF EXISTS scores_9_holes;
CREATE TEMPORARY TABLE scores_9_holes 
SELECT usc.*, gs.group_id, sps.id_score_created AS pictute_score FROM
thegrint_grint.user_score_nine as usc
LEFT JOIN
thegrint_grint.group_score as gs
ON usc.scoreid = gs.scoreid
LEFT JOIN 
(SELECT * FROM thegrint_grint.sps_uploads WHERE type_score = 9) AS sps 
ON sps.id_score_created = usc.scoreid
JOIN
(SELECT user_id, doj, verified FROM thegrint_grint.grint_user) AS gu ON gu.user_id = usc.userid
WHERE usc.added_date < revision_date and usc.added_date >= DATE_SUB(revision_date, INTERVAL 7 DAY) and usc.short not in (2,3) AND (
																						(gu.verified = 2)
																						OR  (gu.verified != 2 AND usc.date >= gu.doj)
                                                                                        OR  (gu.verified != 2 AND usc.date < gu.doj AND usc.date >= cast(usc.added_date as date))
																					);

DROP TABLE IF EXISTS scores_18_holes;
CREATE TEMPORARY TABLE scores_18_holes
SELECT usc.*, gs.group_id, sps.id_score_created AS pictute_score FROM
thegrint_grint.user_score AS usc 
LEFT JOIN
thegrint_grint.group_score as gs
ON usc.scoreid = gs.scoreid
LEFT JOIN 
(SELECT * FROM thegrint_grint.sps_uploads WHERE type_score = 18) AS sps 
ON sps.id_score_created = usc.scoreid
JOIN
(SELECT user_id, doj, verified FROM thegrint_grint.grint_user) AS gu ON gu.user_id = usc.userid
WHERE usc.added_date < revision_date and usc.added_date >= DATE_SUB(revision_date, INTERVAL 7 DAY) and usc.short NOT IN (2,3) AND (
																						(gu.verified = 2)
																						OR  (gu.verified != 2 AND usc.date >= gu.doj)
                                                                                        OR  (gu.verified != 2 AND usc.date < gu.doj AND usc.date >= cast(usc.added_date as date))
																					);

DROP TABLE IF EXISTS scores;
CREATE TEMPORARY TABLE scores
SELECT scoreid, userid, group_id, leaderboard_ID, pictute_score ,creater, short FROM scores_18_holes
UNION
SELECT scoreid, userid, group_id, leaderboard_ID, pictute_score, creater, short FROM scores_9_holes;


#Single Playes Rounds, Multiple Players Rounds, Leaderboard Rounds, Not Leaderboard Rounds, hole by hole, total score
SELECT
IFNULL(sum(IF(sc.scoreid is not null,1,0)),0) AS rounds,
IFNULL(SUM(IF(sc.group_id is null,1,0)),0) AS single_player_rounds,
IFNULL(SUM(IF(sc.group_id is not null,1,0)),0) AS multiple_players_rounds,
IFNULL(SUM(IF(sc.leaderboard_ID is not null,1,0)),0) AS leaderboard,
IFNULL(SUM(IF(sc.leaderboard_ID is null,1,0)),0) AS not_leaderboard,
IFNULL(SUM(IF(sc.short = 0,1,0)),0) AS hole_by_hole,
IFNULL(SUM(IF(sc.short = 1,1,0)),0) AS total_score,
IFNULL(SUM(IF(sc.pictute_score is not null,1,0)),0) AS pictute_score
INTO @rounds, @single_player_rounds, @multiple_players_rounds, @leaderboard, @not_leaderboard, @hole_by_hole, @total_score, @pictute_score
FROM scores AS sc;

#Total Golfers ,Active Golfers, Pasive Golfers
SELECT count(distinct(usc.userid)) AS active_golfers into @active_golfers FROM scores AS usc WHERE usc.userid = usc.creater;
SELECT count(distinct(usc.userid)) AS total_golfers into @total_golfers FROM scores AS usc;
SELECT (@total_golfers - @active_golfers) as pasive_golfers into @pasive_golfers;


#Usga Scores
DROP TABLE IF EXISTS scores_usga;
CREATE TEMPORARY TABLE scores_usga
SELECT scoreid, userid FROM (SELECT * FROM thegrint_grint.user_score_nine as usc WHERE usc.added_date < revision_date and usc.added_date >= DATE_SUB(revision_date, INTERVAL 7 DAY) and usc.short = 3) AS scores_9
UNION
SELECT scoreid, userid FROM (SELECT * FROM thegrint_grint.user_score AS usc WHERE usc.added_date < revision_date and usc.added_date >= DATE_SUB(revision_date, INTERVAL 7 DAY) and usc.short = 3) AS scores_18;

SELECT count(*) AS usga into @usga from scores_usga;


INSERT INTO north_star_metrics
  ( date, north_id, value, range_days )
VALUES
  (revision_date, 1, @rounds, 7),
  (revision_date, 2, @total_golfers, 7),
  (revision_date, 3, @active_golfers, 7),
  (revision_date, 4, @pasive_golfers, 7),
  (revision_date, 5, @rounds/@total_golfers, 7), 
  (revision_date, 6, @single_player_rounds, 7), 
  (revision_date, 7, @multiple_players_rounds, 7),
  (revision_date, 8, @leaderboard, 7),
  (revision_date, 9, @not_leaderboard, 7),
  (revision_date, 10, @hole_by_hole, 7),
  (revision_date, 11, @total_score, 7),
  (revision_date, 12, @pictute_score, 7),
  (revision_date, 13, @usga, 7);
END