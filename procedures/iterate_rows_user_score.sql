CREATE DEFINER=`1bT12@uylp12`@`%` PROCEDURE `iterate_rows_user_score`()
BEGIN
    DECLARE row_count INT DEFAULT 0;
    DECLARE max_rows INT;
	DECLARE cur_scoreid int(10) ;
	DECLARE cur_userid int(11) ;
	DECLARE cur_creater int(11) ;
	DECLARE cur_creater_status int(11) ;
	DECLARE cur_added_date datetime ;
	DECLARE cur_date date ;
	DECLARE cur_course varchar(255);
	DECLARE cur_tees varchar(255) ;
	DECLARE cur_m_l varchar(255) ;
	DECLARE cur_event_id int(11) DEFAULT '0';
	DECLARE cur_tour_id int(11)  DEFAULT '0';
	DECLARE cur_short tinyint(4) ;
	DECLARE cur_round_putt int(11) ;
	DECLARE cur_escround int(11) ;
	DECLARE cur_course_hcp float(10,0);
	DECLARE cur_hcp_diff float(10,1) ;
	DECLARE cur_handicap_index float(10,1) ;
	DECLARE cur_slope int(11) ;
	DECLARE cur_rating float(10,2) ;
	DECLARE cur_scimage varchar(150) ;
	DECLARE cur_scthumb varchar(150)  ;
	DECLARE cur_is_editable tinyint(4) DEFAULT '1';
	DECLARE cur_leaderboard_ID int(10) unsigned DEFAULT NULL;
	DECLARE cur_leaderboard_participant int(11) DEFAULT NULL;
	DECLARE cur_is_incomplete tinyint(1) DEFAULT NULL;
	DECLARE cur_website_uploaded int(1)  DEFAULT '0';
	DECLARE cur_club_tournament int(1) unsigned DEFAULT '0';
	DECLARE cur_private int(1) DEFAULT '0';
	DECLARE cur_practice int(1) unsigned DEFAULT '0';

    -- Get the total number of rows in the thegrint_grint.user_score
    SELECT COUNT(*) INTO max_rows FROM thegrint_grint.user_score;


    SET row_count = 0;

    -- Fetch rows one by one and insert into the new table
    WHILE row_count < 100000 AND row_count < max_rows DO

		SELECT	u.scoreid  ,
				u.userid ,
				u.creater ,
				u.creater_status ,
				u.added_date ,
				u.date ,
				u.course ,
				u.tees ,
				u.m_l ,
				u.event_id ,
				u.tour_id ,
				u.short , 
				u.round_putt ,
				u.escround ,
				u.course_hcp ,
				u.hcp_diff ,
				u.handicap_index,
				u.slope ,
				u.rating ,
				u.scimage ,
				u.scthumb ,
				u.is_editable ,
				u.leaderboard_ID ,
				u.leaderboard_participant ,
				u.is_incomplete ,
				u.website_uploaded ,
				u.club_tournament ,
				u.private,
				u.practice 
				
		INTO	
				cur_scoreid  ,
				cur_userid ,
				cur_creater ,
				cur_creater_status ,
				cur_added_date ,
				cur_date ,
				cur_course ,
				cur_tees ,
				cur_m_l ,
				cur_event_id ,
				cur_tour_id ,
				cur_short , 
				cur_round_putt ,
				cur_escround ,
				cur_course_hcp ,
				cur_hcp_diff ,
				cur_handicap_index,
				cur_slope ,
				cur_rating ,
				cur_scimage ,
				cur_scthumb ,
				cur_is_editable ,
				cur_leaderboard_ID ,
				cur_leaderboard_participant ,
				cur_is_incomplete ,
				cur_website_uploaded ,
				cur_club_tournament ,
				cur_private,
				cur_practice 
        FROM thegrint_grint.user_score u
        ORDER BY scoreid
        LIMIT row_count, 1;

        INSERT INTO thegrint_analytics.new_user_score (
						scoreid  ,
						userid ,
						creater ,
						creater_status ,
						added_date ,
						date ,
						course ,
						tees ,
						m_l ,
						event_id ,
						tour_id ,
						short , 
						round_putt ,
						escround ,
						course_hcp ,
						hcp_diff ,
						handicap_index,
						slope ,
						rating ,
						scimage ,
						scthumb ,
						is_editable ,
						leaderboard_ID ,
						leaderboard_participant ,
						is_incomplete ,
						website_uploaded ,
						club_tournament ,
						private,
						practice 
		)
        VALUES (
				cur_scoreid  ,
				cur_userid ,
				cur_creater ,
				cur_creater_status ,
				cur_added_date ,
				cur_date ,
				cur_course ,
				cur_tees ,
				cur_m_l ,
				cur_event_id ,
				cur_tour_id ,
				cur_short , 
				cur_round_putt ,
				cur_escround ,
				cur_course_hcp ,
				cur_hcp_diff ,
				cur_handicap_index,
				cur_slope ,
				cur_rating ,
				cur_scimage ,
				cur_scthumb ,
				cur_is_editable ,
				cur_leaderboard_ID ,
				cur_leaderboard_participant ,
				cur_is_incomplete ,
				cur_website_uploaded ,
				cur_club_tournament ,
				cur_private,
				cur_practice 
		);

        SET row_count = row_count + 1;
    END WHILE;
END