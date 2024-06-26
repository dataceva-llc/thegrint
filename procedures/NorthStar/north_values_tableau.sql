CREATE DEFINER=`a@n8L$t1c44s`@`%` PROCEDURE `get_north_star_value_tableau`(IN `revision_date` DATE)
BEGIN

SELECT 
IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=1,value,0)),0) AS 'rounds_with_scores_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=1,value,0)),0) AS 'rounds_with_scores_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=1,value,0)),0) AS 'rounds_with_scores_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=1,value,0)),0) AS 'rounds_with_scores_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=2,value,0)),0) AS 'golfers_with_scores_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=2,value,0)),0) AS 'golfers_with_scores_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=2,value,0)),0) AS 'golfers_with_scores_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=2,value,0)),0) AS 'golfers_with_scores_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=3,value,0)),0) AS 'active_golfers_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=3,value,0)),0) AS 'active_golfers_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=3,value,0)),0) AS 'active_golfers_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=3,value,0)),0) AS 'active_golfers_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=4,value,0)),0) AS 'pasive_golfers_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=4,value,0)),0) AS 'pasive_golfers_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=4,value,0)),0) AS 'pasive_golfers_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=4,value,0)),0) AS 'pasive_golfers_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=5,value,0)),0) AS 'scores_per_golfer_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=5,value,0)),0) AS 'scores_per_golfer_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=5,value,0)),0) AS 'scores_per_golfer_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=5,value,0)),0) AS 'scores_per_golfer_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=6,value,0)),0) AS 'single_players_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=6,value,0)),0) AS 'single_players_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=6,value,0)),0) AS 'single_players_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=6,value,0)),0) AS 'single_players_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=7,value,0)),0) AS 'multiple_players_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=7,value,0)),0) AS 'multiple_players_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=7,value,0)),0) AS 'multiple_players_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=7,value,0)),0) AS 'multiple_players_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=8,value,0)),0) AS 'leaderboard_players_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=8,value,0)),0) AS 'leaderboard_players_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=8,value,0)),0) AS 'leaderboard_players_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=8,value,0)),0) AS 'leaderboard_players_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=9,value,0)),0) AS 'not_leaderboard_players_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=9,value,0)),0) AS 'not_leaderboard_players_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=9,value,0)),0) AS 'not_leaderboard_players_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=9,value,0)),0) AS 'not_leaderboard_players_last_year',


IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=10,value,0)),0) AS 'hole_by_hole_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=10,value,0)),0) AS 'hole_by_hole_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=10,value,0)),0) AS 'hole_by_hole_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=10,value,0)),0) AS 'hole_by_hole_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=11,value,0)),0) AS 'total_scores_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=11,value,0)),0) AS 'total_scores_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=11,value,0)),0) AS 'total_scores_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=11,value,0)),0) AS 'total_scores_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 7 and north_id=12,value,0)),0) AS 'picture_photo_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 7 and north_id=12,value,0)),0) AS 'picture_photo_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 7 and north_id=12,value,0)),0) AS 'picture_photo_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 7 and north_id=12,value,0)),0) AS 'picture_photo_last_year'

INTO

@rounds_with_scores_this_week, @rounds_with_scores_last_week, @rounds_with_scores_last_4_weeks, @rounds_with_scores_last_year,
@golfers_with_scores_this_week, @golfers_with_scores_last_week, @golfers_with_scores_last_4_weeks, @golfers_with_scores_last_year,
@active_golfers_this_week, @active_golfers_last_week, @active_golfers_last_4_weeks, @active_golfers_last_year,
@pasive_golfers_this_week, @pasive_golfers_last_week, @pasive_golfers_last_4_weeks, @pasive_golfers_last_year,
@scores_per_golfer_this_week, @scores_per_golfer_last_week, @scores_per_golfer_last_4_weeks, @scores_per_golfer_last_year,
@single_players_this_week, @single_players_last_week, @single_players_last_4_weeks, @single_players_last_year,
@multiple_players_this_week, @multiple_players_last_week, @multiple_players_last_4_weeks, @multiple_players_last_year,
@leaderboard_players_this_week, @leaderboard_players_last_week, @leaderboard_players_last_4_weeks, @leaderboard_players_last_year,
@not_leaderboard_players_this_week, @not_leaderboard_players_last_week, @not_leaderboard_players_last_4_weeks, @not_leaderboard_players_last_year,
@hole_by_hole_this_week, @hole_by_hole_last_week, @hole_by_hole_last_4_weeks, @hole_by_hole_last_year,
@total_scores_this_week, @total_scores_last_week, @total_scores_last_4_weeks, @total_scores_last_year,
@picture_photo_this_week, @picture_photo_last_week, @picture_photo_last_4_weeks, @picture_photo_last_year

FROM north_star_metrics;

INSERT INTO north_values_tableau
(date, range_days, rounds_with_scores_this_week, rounds_with_scores_last_week, rounds_with_scores_last_4_weeks, rounds_with_scores_last_year,
golfers_with_scores_this_week, golfers_with_scores_last_week, golfers_with_scores_last_4_weeks, golfers_with_scores_last_year,
active_golfers_this_week, active_golfers_last_week, active_golfers_last_4_weeks, active_golfers_last_year,
pasive_golfers_this_week, pasive_golfers_last_week, pasive_golfers_last_4_weeks, pasive_golfers_last_year,
scores_per_golfer_this_week, scores_per_golfer_last_week, scores_per_golfer_last_4_weeks, scores_per_golfer_last_year,
single_players_this_week, single_players_last_week, single_players_last_4_weeks, single_players_last_year,
multiple_players_this_week, multiple_players_last_week, multiple_players_last_4_weeks, multiple_players_last_year,
leaderboard_players_this_week, leaderboard_players_last_week, leaderboard_players_last_4_weeks, leaderboard_players_last_year,
not_leaderboard_players_this_week, not_leaderboard_players_last_week, not_leaderboard_players_last_4_weeks, not_leaderboard_players_last_year,
hole_by_hole_this_week, hole_by_hole_last_week, hole_by_hole_last_4_weeks, hole_by_hole_last_year,
total_scores_this_week, total_scores_last_week, total_scores_last_4_weeks, total_scores_last_year,
picture_photo_this_week, picture_photo_last_week, picture_photo_last_4_weeks, picture_photo_last_year)
VALUES
(revision_date, 7,@rounds_with_scores_this_week, @rounds_with_scores_last_week, @rounds_with_scores_last_4_weeks, @rounds_with_scores_last_year,
@golfers_with_scores_this_week, @golfers_with_scores_last_week, @golfers_with_scores_last_4_weeks, @golfers_with_scores_last_year,
@active_golfers_this_week, @active_golfers_last_week, @active_golfers_last_4_weeks, @active_golfers_last_year,
@pasive_golfers_this_week, @pasive_golfers_last_week, @pasive_golfers_last_4_weeks, @pasive_golfers_last_year,
@scores_per_golfer_this_week, @scores_per_golfer_last_week, @scores_per_golfer_last_4_weeks, @scores_per_golfer_last_year,
@single_players_this_week, @single_players_last_week, @single_players_last_4_weeks, @single_players_last_year,
@multiple_players_this_week, @multiple_players_last_week, @multiple_players_last_4_weeks, @multiple_players_last_year,
@leaderboard_players_this_week, @leaderboard_players_last_week, @leaderboard_players_last_4_weeks, @leaderboard_players_last_year,
@not_leaderboard_players_this_week, @not_leaderboard_players_last_week, @not_leaderboard_players_last_4_weeks, @not_leaderboard_players_last_year,
@hole_by_hole_this_week, @hole_by_hole_last_week, @hole_by_hole_last_4_weeks, @hole_by_hole_last_year,
@total_scores_this_week, @total_scores_last_week, @total_scores_last_4_weeks, @total_scores_last_year,
@picture_photo_this_week, @picture_photo_last_week, @picture_photo_last_4_weeks, @picture_photo_last_year);

SELECT 
IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=1,value,0)),0) AS 'rounds_with_scores_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=1,value,0)),0) AS 'rounds_with_scores_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=1,value,0)),0) AS 'rounds_with_scores_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=1,value,0)),0) AS 'rounds_with_scores_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=2,value,0)),0) AS 'golfers_with_scores_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=2,value,0)),0) AS 'golfers_with_scores_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=2,value,0)),0) AS 'golfers_with_scores_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=2,value,0)),0) AS 'golfers_with_scores_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=3,value,0)),0) AS 'active_golfers_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=3,value,0)),0) AS 'active_golfers_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=3,value,0)),0) AS 'active_golfers_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=3,value,0)),0) AS 'active_golfers_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=4,value,0)),0) AS 'pasive_golfers_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=4,value,0)),0) AS 'pasive_golfers_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=4,value,0)),0) AS 'pasive_golfers_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=4,value,0)),0) AS 'pasive_golfers_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=5,value,0)),0) AS 'scores_per_golfer_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=5,value,0)),0) AS 'scores_per_golfer_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=5,value,0)),0) AS 'scores_per_golfer_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=5,value,0)),0) AS 'scores_per_golfer_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=6,value,0)),0) AS 'single_players_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=6,value,0)),0) AS 'single_players_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=6,value,0)),0) AS 'single_players_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=6,value,0)),0) AS 'single_players_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=7,value,0)),0) AS 'multiple_players_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=7,value,0)),0) AS 'multiple_players_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=7,value,0)),0) AS 'multiple_players_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=7,value,0)),0) AS 'multiple_players_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=8,value,0)),0) AS 'leaderboard_players_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=8,value,0)),0) AS 'leaderboard_players_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=8,value,0)),0) AS 'leaderboard_players_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=8,value,0)),0) AS 'leaderboard_players_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=9,value,0)),0) AS 'not_leaderboard_players_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=9,value,0)),0) AS 'not_leaderboard_players_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=9,value,0)),0) AS 'not_leaderboard_players_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=9,value,0)),0) AS 'not_leaderboard_players_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=10,value,0)),0) AS 'hole_by_hole_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=10,value,0)),0) AS 'hole_by_hole_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=10,value,0)),0) AS 'hole_by_hole_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=10,value,0)),0) AS 'hole_by_hole_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=11,value,0)),0) AS 'total_scores_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=11,value,0)),0) AS 'total_scores_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=11,value,0)),0) AS 'total_scores_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=11,value,0)),0) AS 'total_scores_last_year',

IFNULL(SUM(IF(date = revision_date and range_days = 30 and north_id=12,value,0)),0) AS 'picture_photo_this_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 7 DAY) and range_days = 30 and north_id=12,value,0)),0) AS 'picture_photo_last_week',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 28 DAY) and range_days = 30 and north_id=12,value,0)),0) AS 'picture_photo_last_4_weeks',
IFNULL(SUM(IF(date = DATE_SUB(revision_date, INTERVAL 364 DAY) and range_days = 30 and north_id=12,value,0)),0) AS 'picture_photo_last_year'

INTO

@rounds_with_scores_this_week, @rounds_with_scores_last_week, @rounds_with_scores_last_4_weeks, @rounds_with_scores_last_year,
@golfers_with_scores_this_week, @golfers_with_scores_last_week, @golfers_with_scores_last_4_weeks, @golfers_with_scores_last_year,
@active_golfers_this_week, @active_golfers_last_week, @active_golfers_last_4_weeks, @active_golfers_last_year,
@pasive_golfers_this_week, @pasive_golfers_last_week, @pasive_golfers_last_4_weeks, @pasive_golfers_last_year,
@scores_per_golfer_this_week, @scores_per_golfer_last_week, @scores_per_golfer_last_4_weeks, @scores_per_golfer_last_year,
@single_players_this_week, @single_players_last_week, @single_players_last_4_weeks, @single_players_last_year,
@multiple_players_this_week, @multiple_players_last_week, @multiple_players_last_4_weeks, @multiple_players_last_year,
@leaderboard_players_this_week, @leaderboard_players_last_week, @leaderboard_players_last_4_weeks, @leaderboard_players_last_year,
@not_leaderboard_players_this_week, @not_leaderboard_players_last_week, @not_leaderboard_players_last_4_weeks, @not_leaderboard_players_last_year,
@hole_by_hole_this_week, @hole_by_hole_last_week, @hole_by_hole_last_4_weeks, @hole_by_hole_last_year,
@total_scores_this_week, @total_scores_last_week, @total_scores_last_4_weeks, @total_scores_last_year,
@picture_photo_this_week, @picture_photo_last_week, @picture_photo_last_4_weeks, @picture_photo_last_year

FROM north_star_metrics;

INSERT INTO north_values_tableau
(date, range_days, rounds_with_scores_this_week, rounds_with_scores_last_week, rounds_with_scores_last_4_weeks, rounds_with_scores_last_year,
golfers_with_scores_this_week, golfers_with_scores_last_week, golfers_with_scores_last_4_weeks, golfers_with_scores_last_year,
active_golfers_this_week, active_golfers_last_week, active_golfers_last_4_weeks, active_golfers_last_year,
pasive_golfers_this_week, pasive_golfers_last_week, pasive_golfers_last_4_weeks, pasive_golfers_last_year,
scores_per_golfer_this_week, scores_per_golfer_last_week, scores_per_golfer_last_4_weeks, scores_per_golfer_last_year,
single_players_this_week, single_players_last_week, single_players_last_4_weeks, single_players_last_year,
multiple_players_this_week, multiple_players_last_week, multiple_players_last_4_weeks, multiple_players_last_year,
leaderboard_players_this_week, leaderboard_players_last_week, leaderboard_players_last_4_weeks, leaderboard_players_last_year,
not_leaderboard_players_this_week, not_leaderboard_players_last_week, not_leaderboard_players_last_4_weeks, not_leaderboard_players_last_year,
hole_by_hole_this_week, hole_by_hole_last_week, hole_by_hole_last_4_weeks, hole_by_hole_last_year,
total_scores_this_week, total_scores_last_week, total_scores_last_4_weeks, total_scores_last_year,
picture_photo_this_week, picture_photo_last_week, picture_photo_last_4_weeks, picture_photo_last_year)
VALUES
(revision_date, 30, @rounds_with_scores_this_week, @rounds_with_scores_last_week, @rounds_with_scores_last_4_weeks, @rounds_with_scores_last_year,
@golfers_with_scores_this_week, @golfers_with_scores_last_week, @golfers_with_scores_last_4_weeks, @golfers_with_scores_last_year,
@active_golfers_this_week, @active_golfers_last_week, @active_golfers_last_4_weeks, @active_golfers_last_year,
@pasive_golfers_this_week, @pasive_golfers_last_week, @pasive_golfers_last_4_weeks, @pasive_golfers_last_year,
@scores_per_golfer_this_week, @scores_per_golfer_last_week, @scores_per_golfer_last_4_weeks, @scores_per_golfer_last_year,
@single_players_this_week, @single_players_last_week, @single_players_last_4_weeks, @single_players_last_year,
@multiple_players_this_week, @multiple_players_last_week, @multiple_players_last_4_weeks, @multiple_players_last_year,
@leaderboard_players_this_week, @leaderboard_players_last_week, @leaderboard_players_last_4_weeks, @leaderboard_players_last_year,
@not_leaderboard_players_this_week, @not_leaderboard_players_last_week, @not_leaderboard_players_last_4_weeks, @not_leaderboard_players_last_year,
@hole_by_hole_this_week, @hole_by_hole_last_week, @hole_by_hole_last_4_weeks, @hole_by_hole_last_year,
@total_scores_this_week, @total_scores_last_week, @total_scores_last_4_weeks, @total_scores_last_year,
@picture_photo_this_week, @picture_photo_last_week, @picture_photo_last_4_weeks, @picture_photo_last_year);

END