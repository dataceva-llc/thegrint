-- Step 1. Create a temporary table with the basic user filtering and the user's best round
-- Only to include users with at least 50 rounds and a personal best score of 60 or higher
-- DROP TABLE IF EXISTS thegrint_analytics.tmp_user_ids;
CREATE TEMPORARY TABLE IF NOT EXISTS thegrint_analytics.tmp_user_ids AS
SELECT
    COUNT(*) AS total_rounds,
    MIN(user_score.scround) AS pb_score,
    user_score.userid
FROM thegrint_analytics.user_score_replica AS user_score
GROUP BY userid
HAVING 
    COUNT(*) >= 50
    AND MIN(scround) >= 60;
CREATE INDEX idx_userid ON thegrint_analytics.tmp_user_ids (userid);
CREATE INDEX idx_total_rounds ON thegrint_analytics.tmp_user_ids (total_rounds);
CREATE INDEX idx_pb_score ON thegrint_analytics.tmp_user_ids (pb_score);

-- Step 2. Filter the user scores to only include the users in the table
-- DROP TABLE IF EXISTS thegrint_analytics.tmp_user_filtered;
CREATE TEMPORARY TABLE IF NOT EXISTS thegrint_analytics.tmp_user_filtered AS
SELECT
    ids.total_rounds,
    ids.pb_score,
    usr.*
FROM thegrint_analytics.user_score_replica usr
JOIN thegrint_analytics.tmp_user_ids ids ON usr.userid = ids.userid
ORDER BY
    usr.userid,
    usr.date,
    usr.scround;
CREATE INDEX idx_userid ON thegrint_analytics.tmp_user_filtered (userid);
CREATE INDEX idx_date ON thegrint_analytics.tmp_user_filtered (date);
CREATE INDEX idx_scround ON thegrint_analytics.tmp_user_filtered (scround);

-- Step 3. Add the user's best score date to the table
-- DROP TABLE IF EXISTS thegrint_analytics.tmp_user_pb_score_date;
CREATE TEMPORARY TABLE IF NOT EXISTS thegrint_analytics.tmp_user_pb_score_date AS
SELECT
    user_score.userid,
    MIN(user_score.date) AS pb_score_date
FROM thegrint_analytics.tmp_user_filtered usr
JOIN thegrint_analytics.user_score_replica user_score
    ON usr.userid = user_score.userid
    AND usr.pb_score = user_score.scround
GROUP BY user_score.userid
ORDER BY user_score.userid;
CREATE INDEX idx_userid ON thegrint_analytics.tmp_user_pb_score_date (userid);
CREATE INDEX idx_pb_score_date ON thegrint_analytics.tmp_user_pb_score_date (pb_score_date);

-- Step 4. Get the final table with filtered and extra data applied
-- DROP TABLE IF EXISTS thegrint_analytics.users_filtered_with_pb_data;
CREATE TABLE IF NOT EXISTS thegrint_analytics.users_filtered_with_pb_data AS
SELECT
    pb_date.pb_score_date,
    usr.*
FROM thegrint_analytics.tmp_user_filtered usr
JOIN thegrint_analytics.tmp_user_pb_score_date pb_date ON usr.userid = pb_date.userid
ORDER BY usr.userid, usr.date, usr.scround;
CREATE INDEX idx_userid ON thegrint_analytics.users_filtered_with_pb_data (userid);
CREATE INDEX idx_date ON thegrint_analytics.users_filtered_with_pb_data (date);
CREATE INDEX idx_scround ON thegrint_analytics.users_filtered_with_pb_data (scround);
CREATE INDEX idx_pb_score_date ON thegrint_analytics.users_filtered_with_pb_data (pb_score_date);
CREATE INDEX idx_scoreid ON thegrint_analytics.users_filtered_with_pb_data (scoreid);
CREATE INDEX idx_handicap_index ON thegrint_analytics.users_filtered_with_pb_data (handicap_index);
