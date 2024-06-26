CREATE DEFINER=`a@n8L$t1c44s`@`%` PROCEDURE `get_score_metrics`(in `revisiondate` DATE)
BEGIN

select DATE_ADD(revisiondate,  INTERVAL - 365 DAY)                as today_last_year     into @today_last_year;
select MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY))-1,1) as first_day_last_year into @first_day_last_year;
select MAKEDATE(year(DATE_SUB(revisiondate, INTERVAL 1 DAY))  ,1) as first_day_this_year into @first_day_this_year;

SELECT 
IFNULL(sum(IF(added_date >= @first_day_last_year and added_date < @today_last_year,1,0)),0) AS rounds_last_year,
IFNULL(sum(IF(added_date >= @first_day_this_year and added_date < revisiondate,1,0)),0) AS rounds_this_year,
ROUND(IFNULL((sum(IF(added_date >= @first_day_this_year and added_date < revisiondate,1,0))/(DATEDIFF(revisiondate,@first_day_this_year)))*365,0)) as current_run_rate,
ROUND(IFNULL((sum(IF(added_date >= @first_day_last_year and added_date < @today_last_year,1,0))/(DATEDIFF(@today_last_year,@first_day_last_year)))*365,0)) as last_year_run_rate
INTO
@rounds_last_year, @rounds_this_year, @current_run_rate, @last_year_run_rate

FROM
(
(SELECT scoreid, userid, added_date 
FROM thegrint_grint.user_score_nine as sc_nine 
FORCE index (added_date)
LEFT JOIN (SELECT user_id, doj, verified from thegrint_grint.grint_user) as gu
ON gu.user_id = sc_nine.userid
WHERE sc_nine.added_date >= @first_day_last_year AND sc_nine.short not in (2,3) AND (
																						(gu.verified = 2)
																						OR  (gu.verified != 2 AND sc_nine.date >= gu.doj)
                                                                                        OR  (gu.verified != 2 AND sc_nine.date < gu.doj AND sc_nine.date >= cast(sc_nine.added_date as date))
																					)
)
Union
(Select scoreid, userid, added_date 
FROM thegrint_grint.user_score as sc_eight
force index (added_date)
LEFT JOIN (SELECT user_id, doj, verified from thegrint_grint.grint_user) as gu
ON gu.user_id = sc_eight.userid
WHERE 
sc_eight.added_date >= @first_day_last_year AND sc_eight.short NOT IN (2,3) AND (
																						(gu.verified = 2)
																						OR  (gu.verified != 2 AND sc_eight.date >= gu.doj)
                                                                                        OR  (gu.verified != 2 AND sc_eight.date < gu.doj AND sc_eight.date >= cast(sc_eight.added_date as date))
																					))
) AS tabla;

INSERT INTO score_metrics
(date, id, value)
values
(revisiondate, 0, @rounds_last_year),
(revisiondate, 1, @rounds_this_year),
(revisiondate, 2, @current_run_rate),
(revisiondate, 3, @last_year_run_rate);

END