DELIMITER $$

CREATE DEFINER = `1bT12@uylp12` @`%` PROCEDURE `tableau_scores`() BEGIN -- Drop the final table if it exists
DROP TABLE IF EXISTS thegrint_analytics.tableau_scores;

-- START 18 hole scores --
CREATE TABLE thegrint_analytics.tableau_scores AS
SELECT
  `grint_user`.`address` AS `address`,
  `grint_user`.`admin` AS `admin`,
  `grint_user`.`app_type` AS `app_type`,
  `grint_user`.`avg_logins` AS `avg_logins`,
  `grint_user`.`bestFairway` AS `bestFairway`,
  `grint_user`.`bestGIR` AS `bestGIR`,
  `grint_user`.`bestPutts` AS `bestPutts`,
  `grint_user`.`bestScore` AS `bestScore`,
  `grint_user`.`country` AS `country`,
  `grint_user`.`default_filter` AS `default_filter`,
  `grint_user`.`default_filter_round` AS `default_filter_round`,
  `grint_user`.`doj` AS `doj`,
  `grint_user`.`fav_course` AS `fav_course`,
  `grint_user`.`fb_id` AS `fb_id`,
  `grint_user`.`gender` AS `gender`,
  `grint_user`.`grint_network` AS `grint_network`,
  `grint_user`.`handicap_index` AS `handicap_index`,
  CASE
		WHEN `grint_user`.`handicap_index` < 4 THEN '<4'
		WHEN `grint_user`.`handicap_index` BETWEEN 5 AND 10 THEN '5_10'
		WHEN `grint_user`.`handicap_index` BETWEEN 10 AND 15 THEN '10_15'
		WHEN `grint_user`.`handicap_index` BETWEEN 15 AND 20 THEN '15_20'
		WHEN `grint_user`.`handicap_index` BETWEEN 20 AND 25 THEN '20_25'
		ELSE '25+'
	END AS handicap_index_bucket,
  `grint_user`.`handicap_n` AS `handicap_n`,
  `grint_user`.`hdcp_card` AS `hdcp_card`,
  `grint_user`.`hybrids` AS `hybrids`,
  `grint_user`.`image` AS `image`,
  `grint_user`.`inactive` AS `inactive`,
  `grint_user`.`is_winter_state` AS `is_winter_state`,
  `grint_user`.`last_login` AS `last_login`,
  `grint_user`.`life_logins` AS `life_logins`,
  `grint_user`.`map_full_access` AS `map_full_access`,
  `grint_user`.`member_period` AS `member_period`,
  `grint_user`.`member_type` AS `member_type`,
  `grint_user`.`newsletter` AS `newsletter`,
  `grint_user`.`official_hcp_index` AS `official_hcp_index`,
  `grint_user`.`official_index` AS `official_index`,
  `grint_user`.`official_index_n` AS `official_index_n`,
  `grint_user`.`password` AS `password`,
  `grint_user`.`payment` AS `payment`,
  `grint_user`.`purchase_date` AS `purchase_date`,
  `grint_user`.`purchase_expired` AS `purchase_expired`,
  `grint_user`.`purchase_period` AS `purchase_period`,
  SUBSTRING(`grint_user`.`receipt_no`, 1, 1024) AS `receipt_no`,
  `grint_user`.`referrer` AS `referrer`,
  `grint_user`.`registration_source` AS `registration_source`,
  `grint_user`.`remember_login` AS `remember_login`,
  `grint_user`.`score_admin` AS `score_admin`,
  `grint_user`.`showwelcome` AS `showwelcome`,
  `grint_user`.`showwelcome_app` AS `showwelcome_app`,
  `grint_user`.`sps_counter` AS `sps_counter`,
  `grint_user`.`sps_trial_counter` AS `sps_trial_counter`,
  `grint_user`.`super_admin` AS `super_admin`,
  `grint_user`.`user_bag` AS `user_bag`,
  `grint_user`.`user_ball` AS `user_ball`,
  `grint_user`.`user_dob` AS `user_dob`,
  `grint_user`.`user_driver` AS `user_driver`,
  `grint_user`.`user_email` AS `user_email`,
  `grint_user`.`user_fairwaywood` AS `user_fairwaywood`,
  `grint_user`.`user_fname` AS `user_fname`,
  `grint_user`.`user_hand` AS `user_hand`,
  `grint_user`.`user_homecourse` AS `user_homecourse`,
  `grint_user`.`user_id` AS `user_id`,
  `grint_user`.`user_irons` AS `user_irons`,
  `grint_user`.`user_lname` AS `user_lname`,
  `grint_user`.`user_putter` AS `user_putter`,
  `grint_user`.`user_username` AS `user_username`,
  `grint_user`.`verification_code` AS `verification_code`,
  `grint_user`.`verified` AS `verified`,
  `grint_user`.`website_registered` AS `website_registered`,
  `grint_user`.`wedges` AS `wedges`,
  `grint_user`.`welcome_club` AS `welcome_club`,
  `grint_user`.`zipcode` AS `zipcode`,
  wca.name AS Golf_Association,
  scorestable.userid AS scores_user_id,
  scorestable.score_type,
  scorestable.rounds,
  CASE WHEN scorestable.rounds >= 3 THEN 1 ELSE 0 END AS equal_or_more_than_3_rounds,
  scorestable.added_date,
  scorestable.players,
  scorestable.leaderboard,
  scorestable.short,
  scorestable.SPS_Round,
  scorestable.Golfer_Type
FROM
  (
    SELECT
      USN.userid,
      CASE
        WHEN USN.added_date <= '2022-12-31' THEN '2022-12-31'
        ELSE USN.added_date
      END AS added_date,
      '18 Holes' AS `score_type`,
      players,
      USN.short,
      CASE
        WHEN USN.userid = USN.creater THEN 'Active'
        ELSE 'Passive'
      END AS Golfer_Type,
      CASE
        WHEN leaderboard_id IS NOT NULL THEN 'Leaderboard Round'
        ELSE 'Non Leaderboard Round'
      END AS leaderboard,
      CASE
        WHEN SPS.scoreid IS NOT NULL THEN 'SPS'
        ELSE 'Non SPS Round'
      END AS SPS_Round,
      COUNT(DISTINCT USN.scoreid) AS Rounds,
      COUNT(*) AS Rows
    FROM
      thegrint_analytics.user_score_replica USN
      LEFT JOIN (
        SELECT
          scoreid,
          players
        FROM
          thegrint_grint.group_score GS
          LEFT JOIN (
            SELECT
              group_id,
              COUNT(*) AS count,
              COUNT(DISTINCT scoreid) AS players
            FROM
              thegrint_grint.group_score
            GROUP BY
              group_id
          ) GSR ON GS.group_id = GSR.group_id
      ) AS GSP ON USN.scoreid = GSP.scoreid
      LEFT JOIN thegrint_grint.sps_uploads SPS ON USN.scoreid = SPS.scoreid
      AND type_score = 18
    GROUP BY
      USN.userid,
      CASE
        WHEN USN.added_date <= '2022-12-31' THEN '2022-12-31'
        ELSE USN.added_date
      END,
      '18 Holes',
      players,
      USN.short,
      CASE
        WHEN SPS.scoreid IS NOT NULL THEN 'SPS'
        ELSE 'Non SPS Round'
      END,
      CASE
        WHEN USN.userid = USN.creater THEN 'Active'
        ELSE 'Passive'
      END,
      CASE
        WHEN leaderboard_id IS NOT NULL THEN 'Leaderboard Round'
        ELSE 'Normal Round'
      END
  ) AS scorestable
  LEFT JOIN thegrint_grint.grint_user ON scorestable.userid = grint_user.user_id
  LEFT JOIN thegrint_grint.whs_club_association_zipcode AS wcaz ON grint_user.zipcode = wcaz.zipcode
  LEFT JOIN thegrint_grint.whs_club_association AS wca ON wcaz.whs_association_id = wca.whs_association_id;

-- END 18 hole scores --
-- START 9 hole scores --
INSERT INTO
  thegrint_analytics.tableau_scores
SELECT
  `grint_user`.`address` AS `address`,
  `grint_user`.`admin` AS `admin`,
  `grint_user`.`app_type` AS `app_type`,
  `grint_user`.`avg_logins` AS `avg_logins`,
  `grint_user`.`bestFairway` AS `bestFairway`,
  `grint_user`.`bestGIR` AS `bestGIR`,
  `grint_user`.`bestPutts` AS `bestPutts`,
  `grint_user`.`bestScore` AS `bestScore`,
  `grint_user`.`country` AS `country`,
  `grint_user`.`default_filter` AS `default_filter`,
  `grint_user`.`default_filter_round` AS `default_filter_round`,
  `grint_user`.`doj` AS `doj`,
  `grint_user`.`fav_course` AS `fav_course`,
  `grint_user`.`fb_id` AS `fb_id`,
  `grint_user`.`gender` AS `gender`,
  `grint_user`.`grint_network` AS `grint_network`,
  `grint_user`.`handicap_index` AS `handicap_index`,
  CASE
		WHEN `grint_user`.`handicap_index` < 4 THEN '<4'
		WHEN `grint_user`.`handicap_index` BETWEEN 5 AND 10 THEN '5_10'
		WHEN `grint_user`.`handicap_index` BETWEEN 10 AND 15 THEN '10_15'
		WHEN `grint_user`.`handicap_index` BETWEEN 15 AND 20 THEN '15_20'
		WHEN `grint_user`.`handicap_index` BETWEEN 20 AND 25 THEN '20_25'
		ELSE '25+'
	END AS handicap_index_bucket,
  `grint_user`.`handicap_n` AS `handicap_n`,
  `grint_user`.`hdcp_card` AS `hdcp_card`,
  `grint_user`.`hybrids` AS `hybrids`,
  `grint_user`.`image` AS `image`,
  `grint_user`.`inactive` AS `inactive`,
  `grint_user`.`is_winter_state` AS `is_winter_state`,
  `grint_user`.`last_login` AS `last_login`,
  `grint_user`.`life_logins` AS `life_logins`,
  `grint_user`.`map_full_access` AS `map_full_access`,
  `grint_user`.`member_period` AS `member_period`,
  `grint_user`.`member_type` AS `member_type`,
  `grint_user`.`newsletter` AS `newsletter`,
  `grint_user`.`official_hcp_index` AS `official_hcp_index`,
  `grint_user`.`official_index` AS `official_index`,
  `grint_user`.`official_index_n` AS `official_index_n`,
  `grint_user`.`password` AS `password`,
  `grint_user`.`payment` AS `payment`,
  `grint_user`.`purchase_date` AS `purchase_date`,
  `grint_user`.`purchase_expired` AS `purchase_expired`,
  `grint_user`.`purchase_period` AS `purchase_period`,
  SUBSTRING(`grint_user`.`receipt_no`, 1, 1024) AS `receipt_no`,
  `grint_user`.`referrer` AS `referrer`,
  `grint_user`.`registration_source` AS `registration_source`,
  `grint_user`.`remember_login` AS `remember_login`,
  `grint_user`.`score_admin` AS `score_admin`,
  `grint_user`.`showwelcome` AS `showwelcome`,
  `grint_user`.`showwelcome_app` AS `showwelcome_app`,
  `grint_user`.`sps_counter` AS `sps_counter`,
  `grint_user`.`sps_trial_counter` AS `sps_trial_counter`,
  `grint_user`.`super_admin` AS `super_admin`,
  `grint_user`.`user_bag` AS `user_bag`,
  `grint_user`.`user_ball` AS `user_ball`,
  `grint_user`.`user_dob` AS `user_dob`,
  `grint_user`.`user_driver` AS `user_driver`,
  `grint_user`.`user_email` AS `user_email`,
  `grint_user`.`user_fairwaywood` AS `user_fairwaywood`,
  `grint_user`.`user_fname` AS `user_fname`,
  `grint_user`.`user_hand` AS `user_hand`,
  `grint_user`.`user_homecourse` AS `user_homecourse`,
  `grint_user`.`user_id` AS `user_id`,
  `grint_user`.`user_irons` AS `user_irons`,
  `grint_user`.`user_lname` AS `user_lname`,
  `grint_user`.`user_putter` AS `user_putter`,
  `grint_user`.`user_username` AS `user_username`,
  `grint_user`.`verification_code` AS `verification_code`,
  `grint_user`.`verified` AS `verified`,
  `grint_user`.`website_registered` AS `website_registered`,
  `grint_user`.`wedges` AS `wedges`,
  `grint_user`.`welcome_club` AS `welcome_club`,
  `grint_user`.`zipcode` AS `zipcode`,
  wca.name AS Golf_Association,
  scorestable.userid AS scores_user_id,
  scorestable.score_type,
  scorestable.rounds,
  CASE WHEN scorestable.rounds >= 3 THEN 1 ELSE 0 END AS equal_or_more_than_3_rounds,
  scorestable.added_date,
  scorestable.players,
  scorestable.leaderboard,
  scorestable.short,
  scorestable.SPS_Round,
  scorestable.Golfer_Type
FROM
  (
    SELECT
      USN.userid,
      CASE
        WHEN USN.added_date <= '2022-12-31' THEN '2022-12-31'
        ELSE USN.added_date
      END AS added_date,
      '9 Holes' AS `score_type`,
      players,
      USN.short,
      CASE
        WHEN USN.userid = USN.creater THEN 'Active'
        ELSE 'Passive'
      END AS Golfer_Type,
      CASE
        WHEN leaderboard_id IS NOT NULL THEN 'Leaderboard Round'
        ELSE 'Non Leaderboard Round'
      END AS leaderboard,
      CASE
        WHEN SPS.scoreid IS NOT NULL THEN 'SPS'
        ELSE 'Non SPS Round'
      END AS SPS_Round,
      COUNT(DISTINCT USN.scoreid) AS Rounds,
      COUNT(*) AS Rows
    FROM
      thegrint_analytics.user_score_nine_replica USN
      LEFT JOIN (
        SELECT
          scoreid,
          players
        FROM
          thegrint_grint.group_score GS
          LEFT JOIN (
            SELECT
              group_id,
              COUNT(*) AS count,
              COUNT(DISTINCT scoreid) AS players
            FROM
              thegrint_grint.group_score
            GROUP BY
              group_id
          ) GSR ON GS.group_id = GSR.group_id
      ) AS GSP ON USN.scoreid = GSP.scoreid
      LEFT JOIN thegrint_grint.sps_uploads SPS ON USN.scoreid = SPS.scoreid
      AND type_score = 9
    GROUP BY
      USN.userid,
      CASE
        WHEN USN.added_date <= '2022-12-31' THEN '2022-12-31'
        ELSE USN.added_date
      END,
      '9 Holes',
      players,
      USN.short,
      CASE
        WHEN SPS.scoreid IS NOT NULL THEN 'SPS'
        ELSE 'Non SPS Round'
      END,
      CASE
        WHEN USN.userid = USN.creater THEN 'Active'
        ELSE 'Passive'
      END,
      CASE
        WHEN leaderboard_id IS NOT NULL THEN 'Leaderboard Round'
        ELSE 'Normal Round'
      END
  ) AS scorestable
  LEFT JOIN thegrint_grint.grint_user ON scorestable.userid = grint_user.user_id
  LEFT JOIN thegrint_grint.whs_club_association_zipcode AS wcaz ON grint_user.zipcode = wcaz.zipcode
  LEFT JOIN thegrint_grint.whs_club_association AS wca ON wcaz.whs_association_id = wca.whs_association_id;

-- Create indexes on the final table
CREATE INDEX idx_scores_user_id ON thegrint_analytics.tableau_scores (scores_user_id);
CREATE INDEX idx_score_type ON thegrint_analytics.tableau_scores (score_type);
CREATE INDEX idx_added_date ON thegrint_analytics.tableau_scores (added_date);

END$$

DELIMITER ;