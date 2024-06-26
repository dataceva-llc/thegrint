DELIMITER $$

CREATE DEFINER = `1bT12@uylp12`@`%` PROCEDURE thegrint_analytics.update_user_all_scores_data()
BEGIN
/**
* Update or create the user_all_scores table with the latest score data for both 18 and 9 holes.
* RUN TIME: ~120 seconds (2 minutes)
*
* The user_all_scores table contains the following columns:
* - score_id: The score ID.
* - user_id: The user ID.
* - added_date: The date the score was added.
* - score_date: The date the score was played.
* - handicap_index: The user's handicap index.
* - scround: The score round (18 or 9 holes).
*
* The procedure retrieves the latest score data from the user_score_replica and user_score_nine_replica tables.
*
* On first create, run the following query to index the user_all_scores_data table:
*   CREATE INDEX user_all_scores_score_id ON thegrint_analytics.user_all_scores_data (score_id);
*   CREATE INDEX user_all_scores_user_id ON thegrint_analytics.user_all_scores_data (user_id);
*/

    -- Drop the user_membership table if it exist
    DROP TABLE IF EXISTS thegrint_analytics.user_all_scores_data;

    -- Create the table and insert the records
    CREATE TABLE thegrint_analytics.user_all_scores_data AS
    SELECT
        all_scores.scoreid AS score_id,
        all_scores.userid AS user_id,
        all_scores.added_date,
        all_scores.score_date,
        all_scores.handicap_index,
        all_scores.scround
    FROM (
            SELECT
                scoreid,
                userid,
                added_date AS added_date,
                date AS score_date,
                handicap_index,
                scround
            FROM thegrint_analytics.user_score_replica
            UNION
            SELECT
                scoreid,
                userid,
                added_date AS added_date,
                date AS score_date,
                handicap_index,
                scround
            FROM thegrint_analytics.user_score_nine_replica
        ) AS all_scores;

    CREATE INDEX user_all_scores_score_id ON thegrint_analytics.user_all_scores_data (score_id);
    CREATE INDEX user_all_scores_user_id ON thegrint_analytics.user_all_scores_data (user_id);
END$$

DELIMITER ;
