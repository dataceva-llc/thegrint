CREATE DEFINER=`1bT12@uylp12`@`%` PROCEDURE `User_Score_nine_Replica_RowByRow`()
BEGIN
    
	DECLARE done INT DEFAULT FALSE;
   
	DECLARE cur_scoreid  int(10) ;
	DECLARE cur_userid  int(11) ;
	DECLARE cur_creater  int(11) ;
	DECLARE cur_creater_status  int(11) ;
	DECLARE cur_added_date  date ;
	DECLARE cur_date  date ;
	DECLARE cur_course  varchar(255)  ;
	DECLARE cur_tees  varchar(255)  ;
	DECLARE cur_m_l  varchar(255)  ;
	DECLARE cur_event_id  int(11)  DEFAULT '0';
	DECLARE cur_tour_id  int(11)  DEFAULT '0';
	DECLARE cur_short  tinyint(4) ;
	DECLARE cur_scH1  int(11) ;
	DECLARE cur_scH2  int(11) ;
	DECLARE cur_scH3  int(11) ;
	DECLARE cur_scH4  int(11) ;
	DECLARE cur_scH5  int(11) ;
	DECLARE cur_scH6  int(11) ;
	DECLARE cur_scH7  int(11) ;
	DECLARE cur_scH8  int(11) ;
	DECLARE cur_scH9  int(11) ;
	DECLARE cur_scH10  int(11) ;
	DECLARE cur_scH11  int(11) ;
	DECLARE cur_scH12  int(11) ;
	DECLARE cur_scH13  int(11) ;
	DECLARE cur_scH14  int(11) ;
	DECLARE cur_scH15  int(11) ;
	DECLARE cur_scH16  int(11) ;
	DECLARE cur_scH17  int(11) ;
	DECLARE cur_scH18  int(11) ;
	DECLARE cur_par1  int(10) ;
	DECLARE cur_par2  int(10) ;
	DECLARE cur_par3  int(10) ;
	DECLARE cur_par4  int(10) ;
	DECLARE cur_par5  int(10) ;
	DECLARE cur_par6  int(10) ;
	DECLARE cur_par7  int(10) ;
	DECLARE cur_par8  int(10) ;
	DECLARE cur_par9  int(10) ;
	DECLARE cur_par10  int(10) ;
	DECLARE cur_par11  int(10) ;
	DECLARE cur_par12  int(10) ;
	DECLARE cur_par13  int(10) ;
	DECLARE cur_par14  int(10) ;
	DECLARE cur_par15  int(10) ;
	DECLARE cur_par16  int(10) ;
	DECLARE cur_par17  int(10) ;
	DECLARE cur_par18  int(10) ;
	DECLARE cur_yardage1  int(10) ;
	DECLARE cur_yardage2  int(10) ;
	DECLARE cur_yardage3  int(10) ;
	DECLARE cur_yardage4  int(10) ;
	DECLARE cur_yardage5  int(10) ;
	DECLARE cur_yardage6  int(10) ;
	DECLARE cur_yardage7  int(10) ;
	DECLARE cur_yardage8  int(10) ;
	DECLARE cur_yardage9  int(10) ;
	DECLARE cur_yardage10  int(10) ;
	DECLARE cur_yardage11  int(10) ;
	DECLARE cur_yardage12  int(10) ;
	DECLARE cur_yardage13  int(10) ;
	DECLARE cur_yardage14  int(10) ;
	DECLARE cur_yardage15  int(10) ;
	DECLARE cur_yardage16  int(10) ;
	DECLARE cur_yardage17  int(10) ;
	DECLARE cur_yardage18  int(10) ;
	DECLARE cur_scround  int(11) ;
	DECLARE cur_ptH1  int(11) ;
	DECLARE cur_ptH2  int(11) ;
	DECLARE cur_ptH3  int(11) ;
	DECLARE cur_ptH4  int(11) ;
	DECLARE cur_ptH5  int(11) ;
	DECLARE cur_ptH6  int(11) ;
	DECLARE cur_ptH7  int(11) ;
	DECLARE cur_ptH8  int(11) ;
	DECLARE cur_ptH9  int(11) ;
	DECLARE cur_ptH10  int(11) ;
	DECLARE cur_ptH11  int(11) ;
	DECLARE cur_ptH12  int(11) ;
	DECLARE cur_ptH13  int(11) ;
	DECLARE cur_ptH14  int(11) ;
	DECLARE cur_ptH15  int(11) ;
	DECLARE cur_ptH16  int(11) ;
	DECLARE cur_ptH17  int(11) ;
	DECLARE cur_ptH18  int(11) ;
	DECLARE cur_round_putt  int(11) ;
	DECLARE cur_pH1  varchar(11)  ;
	DECLARE cur_pH2  varchar(11)  ;
	DECLARE cur_pH3  varchar(11)  ;
	DECLARE cur_pH4  varchar(11)  ;
	DECLARE cur_pH5  varchar(11)  ;
	DECLARE cur_pH6  varchar(11)  ;
	DECLARE cur_pH7  varchar(11)  ;
	DECLARE cur_pH8  varchar(11)  ;
	DECLARE cur_pH9  varchar(11)  ;
	DECLARE cur_pH10  varchar(11)  ;
	DECLARE cur_pH11  varchar(11)  ;
	DECLARE cur_pH12  varchar(11)  ;
	DECLARE cur_pH13  varchar(11)  ;
	DECLARE cur_pH14  varchar(11)  ;
	DECLARE cur_pH15  varchar(11)  ;
	DECLARE cur_pH16  varchar(11)  ;
	DECLARE cur_pH17  varchar(11)  ;
	DECLARE cur_pH18  varchar(11)  ;
	DECLARE cur_escH1  int(255) ;
	DECLARE cur_escH2  int(255) ;
	DECLARE cur_escH3  int(255) ;
	DECLARE cur_escH4  int(255) ;
	DECLARE cur_escH5  int(255) ;
	DECLARE cur_escH6  int(255) ;
	DECLARE cur_escH7  int(255) ;
	DECLARE cur_escH8  int(255) ;
	DECLARE cur_escH9  int(255) ;
	DECLARE cur_escH10  int(255) ;
	DECLARE cur_escH11  int(255) ;
	DECLARE cur_escH12  int(255) ;
	DECLARE cur_escH13  int(255) ;
	DECLARE cur_escH14  int(255) ;
	DECLARE cur_escH15  int(255) ;
	DECLARE cur_escH16  int(255) ;
	DECLARE cur_escH17  int(255) ;
	DECLARE cur_escH18  int(255) ;
	DECLARE cur_escround  int(11) ;
	DECLARE cur_course_hcp  float(10,0) ;
	DECLARE cur_hcp_diff  float(10,1) ;
	DECLARE cur_handicap_index  float(10,1) ;
	DECLARE cur_slope  int(11) ;
	DECLARE cur_rating  float(10,2) ;
	DECLARE cur_girH1  int(11) ;
	DECLARE cur_girH2  int(11) ;
	DECLARE cur_girH3  int(11) ;
	DECLARE cur_girH4  int(11) ;
	DECLARE cur_girH5  int(11) ;
	DECLARE cur_girH6  int(11) ;
	DECLARE cur_girH7  int(11) ;
	DECLARE cur_girH8  int(11) ;
	DECLARE cur_girH9  int(11) ;
	DECLARE cur_girH10  int(11) ;
	DECLARE cur_girH11  int(11) ;
	DECLARE cur_girH12  int(11) ;
	DECLARE cur_girH13  int(11) ;
	DECLARE cur_girH14  int(11) ;
	DECLARE cur_girH15  int(11) ;
	DECLARE cur_girH16  int(11) ;
	DECLARE cur_girH17  int(11) ;
	DECLARE cur_girH18  int(11) ;
	DECLARE cur_fH1  tinyint(4) ;
	DECLARE cur_fH2  tinyint(4) ;
	DECLARE cur_fH3  tinyint(4) ;
	DECLARE cur_fH4  tinyint(4) ;
	DECLARE cur_fH5  tinyint(4) ;
	DECLARE cur_fH6  tinyint(4) ;
	DECLARE cur_fH7  tinyint(4) ;
	DECLARE cur_fH8  tinyint(4) ;
	DECLARE cur_fH9  tinyint(4) ;
	DECLARE cur_fH10  tinyint(4) ;
	DECLARE cur_fH11  tinyint(4) ;
	DECLARE cur_fH12  tinyint(4) ;
	DECLARE cur_fH13  tinyint(4) ;
	DECLARE cur_fH14  tinyint(4) ;
	DECLARE cur_fH15  tinyint(4) ;
	DECLARE cur_fH16  tinyint(4) ;
	DECLARE cur_fH17  tinyint(4) ;
	DECLARE cur_fH18  tinyint(4) ;
	DECLARE cur_scimage  varchar(150)  ;
	DECLARE cur_scthumb  varchar(150)  ;
	DECLARE cur_is_editable  tinyint(4)  DEFAULT '1';
    DECLARE cur_nine_hole_type enum('back','front')  DEFAULT NULL;
	DECLARE cur_leaderboard_ID  int(10) unsigned DEFAULT NULL;
	DECLARE cur_leaderboard_participant  int(11) DEFAULT NULL;
	DECLARE cur_is_incomplete  tinyint(1) DEFAULT NULL;
	DECLARE cur_website_uploaded  int(1)  DEFAULT '0';
	DECLARE cur_club_tournament  int(1) unsigned DEFAULT '0';
	DECLARE cur_private  int(1) DEFAULT '0';
	DECLARE cur_practice  int(1) unsigned DEFAULT '0';


    DECLARE max_scoreid INT DEFAULT 0;

 

    -- cursor 
    DECLARE score_cursor CURSOR FOR 
    SELECT	u.scoreid,
		u.userid,
		u.creater,
		u.creater_status,
		cast(u.added_date as date),
		u.date,
		u.course,
		u.tees,
		u.m_l,
		u.event_id,
		u.tour_id,
		u.short,
		u.scH1,
		u.scH2,
		u.scH3,
		u.scH4,
		u.scH5,
		u.scH6,
		u.scH7,
		u.scH8,
		u.scH9,
		u.scH10,
		u.scH11,
		u.scH12,
		u.scH13,
		u.scH14,
		u.scH15,
		u.scH16,
		u.scH17,
		u.scH18,
		u.par1,
		u.par2,
		u.par3,
		u.par4,
		u.par5,
		u.par6,
		u.par7,
		u.par8,
		u.par9,
		u.par10,
		u.par11,
		u.par12,
		u.par13,
		u.par14,
		u.par15,
		u.par16,
		u.par17,
		u.par18,
		u.yardage1,
		u.yardage2,
		u.yardage3,
		u.yardage4,
		u.yardage5,
		u.yardage6,
		u.yardage7,
		u.yardage8,
		u.yardage9,
		u.yardage10,
		u.yardage11,
		u.yardage12,
		u.yardage13,
		u.yardage14,
		u.yardage15,
		u.yardage16,
		u.yardage17,
		u.yardage18,
		u.scround,
		u.ptH1,
		u.ptH2,
		u.ptH3,
		u.ptH4,
		u.ptH5,
		u.ptH6,
		u.ptH7,
		u.ptH8,
		u.ptH9,
		u.ptH10,
		u.ptH11,
		u.ptH12,
		u.ptH13,
		u.ptH14,
		u.ptH15,
		u.ptH16,
		u.ptH17,
		u.ptH18,
		u.round_putt,
		u.pH1,
		u.pH2,
		u.pH3,
		u.pH4,
		u.pH5,
		u.pH6,
		u.pH7,
		u.pH8,
		u.pH9,
		u.pH10,
		u.pH11,
		u.pH12,
		u.pH13,
		u.pH14,
		u.pH15,
		u.pH16,
		u.pH17,
		u.pH18,
		u.escH1,
		u.escH2,
		u.escH3,
		u.escH4,
		u.escH5,
		u.escH6,
		u.escH7,
		u.escH8,
		u.escH9,
		u.escH10,
		u.escH11,
		u.escH12,
		u.escH13,
		u.escH14,
		u.escH15,
		u.escH16,
		u.escH17,
		u.escH18,
		u.escround,
		u.course_hcp,
		u.hcp_diff,
		u.handicap_index,
		u.slope,
		u.rating,
		u.girH1,
		u.girH2,
		u.girH3,
		u.girH4,
		u.girH5,
		u.girH6,
		u.girH7,
		u.girH8,
		u.girH9,
		u.girH10,
		u.girH11,
		u.girH12,
		u.girH13,
		u.girH14,
		u.girH15,
		u.girH16,
		u.girH17,
		u.girH18,
		u.fH1,
		u.fH2,
		u.fH3,
		u.fH4,
		u.fH5,
		u.fH6,
		u.fH7,
		u.fH8,
		u.fH9,
		u.fH10,
		u.fH11,
		u.fH12,
		u.fH13,
		u.fH14,
		u.fH15,
		u.fH16,
		u.fH17,
		u.fH18,
		u.scimage,
		u.scthumb,
		u.is_editable,
        u.nine_hole_type,
		u.leaderboard_ID,
		u.leaderboard_participant,
		u.is_incomplete,
		u.website_uploaded,
		u.club_tournament,
		u.private,
		u.practice

		 FROM thegrint_grint.user_score_nine u
        WHERE scoreid > max_scoreid;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
   -- get max scoreid in the replica table
    SELECT COALESCE(MAX(scoreid), 0) INTO max_scoreid FROM thegrint_analytics.user_score_nine_replica;
    OPEN score_cursor;

    read_loop: LOOP
        FETCH score_cursor INTO
				cur_scoreid,
				cur_userid,
				cur_creater,
				cur_creater_status,
				cur_added_date,
				cur_date,
				cur_course,
				cur_tees,
				cur_m_l,
				cur_event_id,
				cur_tour_id,
				cur_short,
				cur_scH1,
				cur_scH2,
				cur_scH3,
				cur_scH4,
				cur_scH5,
				cur_scH6,
				cur_scH7,
				cur_scH8,
				cur_scH9,
				cur_scH10,
				cur_scH11,
				cur_scH12,
				cur_scH13,
				cur_scH14,
				cur_scH15,
				cur_scH16,
				cur_scH17,
				cur_scH18,
				cur_par1,
				cur_par2,
				cur_par3,
				cur_par4,
				cur_par5,
				cur_par6,
				cur_par7,
				cur_par8,
				cur_par9,
				cur_par10,
				cur_par11,
				cur_par12,
				cur_par13,
				cur_par14,
				cur_par15,
				cur_par16,
				cur_par17,
				cur_par18,
				cur_yardage1,
				cur_yardage2,
				cur_yardage3,
				cur_yardage4,
				cur_yardage5,
				cur_yardage6,
				cur_yardage7,
				cur_yardage8,
				cur_yardage9,
				cur_yardage10,
				cur_yardage11,
				cur_yardage12,
				cur_yardage13,
				cur_yardage14,
				cur_yardage15,
				cur_yardage16,
				cur_yardage17,
				cur_yardage18,
				cur_scround,
				cur_ptH1,
				cur_ptH2,
				cur_ptH3,
				cur_ptH4,
				cur_ptH5,
				cur_ptH6,
				cur_ptH7,
				cur_ptH8,
				cur_ptH9,
				cur_ptH10,
				cur_ptH11,
				cur_ptH12,
				cur_ptH13,
				cur_ptH14,
				cur_ptH15,
				cur_ptH16,
				cur_ptH17,
				cur_ptH18,
				cur_round_putt,
				cur_pH1,
				cur_pH2,
				cur_pH3,
				cur_pH4,
				cur_pH5,
				cur_pH6,
				cur_pH7,
				cur_pH8,
				cur_pH9,
				cur_pH10,
				cur_pH11,
				cur_pH12,
				cur_pH13,
				cur_pH14,
				cur_pH15,
				cur_pH16,
				cur_pH17,
				cur_pH18,
				cur_escH1,
				cur_escH2,
				cur_escH3,
				cur_escH4,
				cur_escH5,
				cur_escH6,
				cur_escH7,
				cur_escH8,
				cur_escH9,
				cur_escH10,
				cur_escH11,
				cur_escH12,
				cur_escH13,
				cur_escH14,
				cur_escH15,
				cur_escH16,
				cur_escH17,
				cur_escH18,
				cur_escround,
				cur_course_hcp,
				cur_hcp_diff,
				cur_handicap_index,
				cur_slope,
				cur_rating,
				cur_girH1,
				cur_girH2,
				cur_girH3,
				cur_girH4,
				cur_girH5,
				cur_girH6,
				cur_girH7,
				cur_girH8,
				cur_girH9,
				cur_girH10,
				cur_girH11,
				cur_girH12,
				cur_girH13,
				cur_girH14,
				cur_girH15,
				cur_girH16,
				cur_girH17,
				cur_girH18,
				cur_fH1,
				cur_fH2,
				cur_fH3,
				cur_fH4,
				cur_fH5,
				cur_fH6,
				cur_fH7,
				cur_fH8,
				cur_fH9,
				cur_fH10,
				cur_fH11,
				cur_fH12,
				cur_fH13,
				cur_fH14,
				cur_fH15,
				cur_fH16,
				cur_fH17,
				cur_fH18,
				cur_scimage,
				cur_scthumb,
				cur_is_editable,
                cur_nine_hole_type,
				cur_leaderboard_ID,
				cur_leaderboard_participant,
				cur_is_incomplete,
				cur_website_uploaded,
				cur_club_tournament,
				cur_private,
				cur_practice;

            
        IF done THEN
            LEAVE read_loop;
        END IF;
        
         INSERT INTO thegrint_analytics.user_score_nine_replica (
            scoreid,
			userid,
			creater,
			creater_status,
			added_date,
			date,
			course,
			tees,
			m_l,
			event_id,
			tour_id,
			short,
			scH1,
			scH2,
			scH3,
			scH4,
			scH5,
			scH6,
			scH7,
			scH8,
			scH9,
			scH10,
			scH11,
			scH12,
			scH13,
			scH14,
			scH15,
			scH16,
			scH17,
			scH18,
			par1,
			par2,
			par3,
			par4,
			par5,
			par6,
			par7,
			par8,
			par9,
			par10,
			par11,
			par12,
			par13,
			par14,
			par15,
			par16,
			par17,
			par18,
			yardage1,
			yardage2,
			yardage3,
			yardage4,
			yardage5,
			yardage6,
			yardage7,
			yardage8,
			yardage9,
			yardage10,
			yardage11,
			yardage12,
			yardage13,
			yardage14,
			yardage15,
			yardage16,
			yardage17,
			yardage18,
			scround,
			ptH1,
			ptH2,
			ptH3,
			ptH4,
			ptH5,
			ptH6,
			ptH7,
			ptH8,
			ptH9,
			ptH10,
			ptH11,
			ptH12,
			ptH13,
			ptH14,
			ptH15,
			ptH16,
			ptH17,
			ptH18,
			round_putt,
			pH1,
			pH2,
			pH3,
			pH4,
			pH5,
			pH6,
			pH7,
			pH8,
			pH9,
			pH10,
			pH11,
			pH12,
			pH13,
			pH14,
			pH15,
			pH16,
			pH17,
			pH18,
			escH1,
			escH2,
			escH3,
			escH4,
			escH5,
			escH6,
			escH7,
			escH8,
			escH9,
			escH10,
			escH11,
			escH12,
			escH13,
			escH14,
			escH15,
			escH16,
			escH17,
			escH18,
			escround,
			course_hcp,
			hcp_diff,
			handicap_index,
			slope,
			rating,
			girH1,
			girH2,
			girH3,
			girH4,
			girH5,
			girH6,
			girH7,
			girH8,
			girH9,
			girH10,
			girH11,
			girH12,
			girH13,
			girH14,
			girH15,
			girH16,
			girH17,
			girH18,
			fH1,
			fH2,
			fH3,
			fH4,
			fH5,
			fH6,
			fH7,
			fH8,
			fH9,
			fH10,
			fH11,
			fH12,
			fH13,
			fH14,
			fH15,
			fH16,
			fH17,
			fH18,
			scimage,
			scthumb,
			is_editable,
            nine_hole_type ,
			leaderboard_ID,
			leaderboard_participant,
			is_incomplete,
			website_uploaded,
			club_tournament,
			private,
			practice

        ) VALUES (
            cur_scoreid,
				cur_userid,
				cur_creater,
				cur_creater_status,
				cur_added_date,
				cur_date,
				cur_course,
				cur_tees,
				cur_m_l,
				cur_event_id,
				cur_tour_id,
				cur_short,
				cur_scH1,
				cur_scH2,
				cur_scH3,
				cur_scH4,
				cur_scH5,
				cur_scH6,
				cur_scH7,
				cur_scH8,
				cur_scH9,
				cur_scH10,
				cur_scH11,
				cur_scH12,
				cur_scH13,
				cur_scH14,
				cur_scH15,
				cur_scH16,
				cur_scH17,
				cur_scH18,
				cur_par1,
				cur_par2,
				cur_par3,
				cur_par4,
				cur_par5,
				cur_par6,
				cur_par7,
				cur_par8,
				cur_par9,
				cur_par10,
				cur_par11,
				cur_par12,
				cur_par13,
				cur_par14,
				cur_par15,
				cur_par16,
				cur_par17,
				cur_par18,
				cur_yardage1,
				cur_yardage2,
				cur_yardage3,
				cur_yardage4,
				cur_yardage5,
				cur_yardage6,
				cur_yardage7,
				cur_yardage8,
				cur_yardage9,
				cur_yardage10,
				cur_yardage11,
				cur_yardage12,
				cur_yardage13,
				cur_yardage14,
				cur_yardage15,
				cur_yardage16,
				cur_yardage17,
				cur_yardage18,
				cur_scround,
				cur_ptH1,
				cur_ptH2,
				cur_ptH3,
				cur_ptH4,
				cur_ptH5,
				cur_ptH6,
				cur_ptH7,
				cur_ptH8,
				cur_ptH9,
				cur_ptH10,
				cur_ptH11,
				cur_ptH12,
				cur_ptH13,
				cur_ptH14,
				cur_ptH15,
				cur_ptH16,
				cur_ptH17,
				cur_ptH18,
				cur_round_putt,
				cur_pH1,
				cur_pH2,
				cur_pH3,
				cur_pH4,
				cur_pH5,
				cur_pH6,
				cur_pH7,
				cur_pH8,
				cur_pH9,
				cur_pH10,
				cur_pH11,
				cur_pH12,
				cur_pH13,
				cur_pH14,
				cur_pH15,
				cur_pH16,
				cur_pH17,
				cur_pH18,
				cur_escH1,
				cur_escH2,
				cur_escH3,
				cur_escH4,
				cur_escH5,
				cur_escH6,
				cur_escH7,
				cur_escH8,
				cur_escH9,
				cur_escH10,
				cur_escH11,
				cur_escH12,
				cur_escH13,
				cur_escH14,
				cur_escH15,
				cur_escH16,
				cur_escH17,
				cur_escH18,
				cur_escround,
				cur_course_hcp,
				cur_hcp_diff,
				cur_handicap_index,
				cur_slope,
				cur_rating,
				cur_girH1,
				cur_girH2,
				cur_girH3,
				cur_girH4,
				cur_girH5,
				cur_girH6,
				cur_girH7,
				cur_girH8,
				cur_girH9,
				cur_girH10,
				cur_girH11,
				cur_girH12,
				cur_girH13,
				cur_girH14,
				cur_girH15,
				cur_girH16,
				cur_girH17,
				cur_girH18,
				cur_fH1,
				cur_fH2,
				cur_fH3,
				cur_fH4,
				cur_fH5,
				cur_fH6,
				cur_fH7,
				cur_fH8,
				cur_fH9,
				cur_fH10,
				cur_fH11,
				cur_fH12,
				cur_fH13,
				cur_fH14,
				cur_fH15,
				cur_fH16,
				cur_fH17,
				cur_fH18,
				cur_scimage,
				cur_scthumb,
				cur_is_editable,
                cur_nine_hole_type,
				cur_leaderboard_ID,
				cur_leaderboard_participant,
				cur_is_incomplete,
				cur_website_uploaded,
				cur_club_tournament,
				cur_private,
				cur_practice
        );
        
  
        END LOOP;

    CLOSE score_cursor;
    
-- to delete score_id from "thegrint_analytics.user_score_nine_replica" which are not present in "thegrint_grint.user_score_nine"
	DELETE FROM thegrint_analytics.user_score_nine_replica
	WHERE NOT EXISTS (
	SELECT 1 FROM thegrint_grint.user_score_nine
	WHERE user_score_nine.scoreId = user_score_nine_replica.scoreId
);
END