-- Create a temp table to store user data and pb's data for each user
-- ETA: ~250 seconds
CREATE TEMPORARY TABLE IF NOT EXISTS thegrint_analytics.tmp_user_pb_multi_data AS
SELECT
    userid,
    MAX(total_rounds) AS total_rounds,
    MAX(pb_score) AS pb_score,

    MAX(time_between_pbs) AS max_time_between_pbs,
    MIN(time_between_pbs) AS min_time_between_pbs,
    AVG(time_between_pbs) AS avg_time_between_pbs,

    MAX(pb_diff) AS max_pb_diff,
    MIN(pb_diff) AS min_pb_diff,
    AVG(pb_diff) AS avg_pb_diff,
    
    MAX(handicap_index) AS max_handicap,
    MIN(handicap_index) AS min_handicap,
    AVG(handicap_index) AS avg_handicap,

    MAX(scround) AS max_score,
    MIN(scround) AS min_score,
    AVG(scround) AS avg_score
FROM (
    SELECT
        users_filtered.userid,
        users_filtered.pb_score,
        users_filtered.scround,
        users_filtered.total_rounds,
        users_filtered.handicap_index,

        -- Increment the times since the user's best round if the current round is not the user's best round
        IF(
            users_filtered.userid = @prev_user,
            @since_last_pb + 1,
            0
        ) AS since_last_pb,

        IF (
            users_filtered.userid = @prev_user
            AND users_filtered.scround < @previous_best_round,
            @since_last_pb + 1,
            NULL
        ) AS time_between_pbs,

        IF (
            users_filtered.userid = @prev_user
            AND users_filtered.scround < @previous_best_round,
            users_filtered.scround - @previous_best_round,
            NULL
        ) AS pb_diff,

        @since_last_pb := IF(
            users_filtered.scround < @previous_best_round,
            0,
            @since_last_pb + 1
        ) AS ignore_since_last_pb,

        -- Set the previous best round score for the user if the current score is less than the previous best round score
        @previous_best_round := IF(
            users_filtered.scround < @previous_best_round,
            CAST(users_filtered.scround AS CHAR),
            CAST(@previous_best_round AS CHAR)
        ) AS ignore_previous_best_round,

        -- Increment the sequence if the user is the same and this is the round after their best round
        @seq := IF (
            @prev_user = users_filtered.userid,
            @seq + 1,
            1
        ) AS ignore_seq,

        -- Set to the first round's score if this is the first round for the user
        @previous_best_round := IF(
            @seq = 1,
            CAST(users_filtered.scround AS CHAR),
            CAST(@previous_best_round AS CHAR)
        ) AS previous_best_round,

        -- Reset the since last pb variable if this is the first round for the user
        @since_last_pb := IF(
            @seq = 1,
            0,
            @since_last_pb
        ) AS ignore_since_last_pb2,

        -- Set the previous user var to the current user for future processing
        @prev_user := users_filtered.userid
    FROM thegrint_analytics.users_filtered_with_pb_data users_filtered
    CROSS JOIN (SELECT
        @seq := 0,
        @prev_user := NULL,
        @previous_best_round := 9999,
        @since_last_pb := 0
    ) vars
) AS subq
GROUP BY userid;
CREATE INDEX idx_userid ON thegrint_analytics.tmp_user_pb_multi_data (userid);
-- SELECT * FROM thegrint_analytics.tmp_user_pb_multi_data;

-- Get the user's data after their best round
-- Run time: ~1 second
SELECT
    COUNT(*) AS number_of_users,
    CASE
        WHEN (avg_time_between_pbs) > 5 THEN '<5'
        WHEN (avg_time_between_pbs) BETWEEN 5 AND 10 THEN '5_10'
        WHEN (avg_time_between_pbs) BETWEEN 10 AND 15 THEN '10_15'
        WHEN (avg_time_between_pbs) BETWEEN 15 AND 20 THEN '15_20'
        ELSE '20+'
    END AS avg_time_between_pbs_bucket,
    CASE
        WHEN pb_score BETWEEN 60 AND 65 THEN '60_65'
        WHEN pb_score BETWEEN 65 AND 70 THEN '65_70'
        WHEN pb_score BETWEEN 70 AND 75 THEN '70_75'
        WHEN pb_score BETWEEN 75 AND 80 THEN '75_80'
        WHEN pb_score BETWEEN 80 AND 85 THEN '80_85'
        WHEN pb_score BETWEEN 85 AND 90 THEN '85_90'
        WHEN pb_score BETWEEN 90 AND 95 THEN '90_95'
        WHEN pb_score BETWEEN 95 AND 100 THEN '95_100'
        ELSE '100+'
    END AS pb_score_bucket,
    CASE
        WHEN avg_handicap < 4 THEN '<4'
        WHEN avg_handicap BETWEEN 5 AND 10 THEN '5_10'
        WHEN avg_handicap BETWEEN 10 AND 15 THEN '10_15'
        WHEN avg_handicap BETWEEN 15 AND 20 THEN '15_20'
        WHEN avg_handicap BETWEEN 20 AND 25 THEN '20_25'
        ELSE '25+'
    END AS avg_handicap_bucket
FROM thegrint_analytics.tmp_user_pb_multi_data AS subq2
GROUP BY
    CASE
        WHEN (avg_time_between_pbs) > 5 THEN '<5'
        WHEN (avg_time_between_pbs) BETWEEN 5 AND 10 THEN '5_10'
        WHEN (avg_time_between_pbs) BETWEEN 10 AND 15 THEN '10_15'
        WHEN (avg_time_between_pbs) BETWEEN 15 AND 20 THEN '15_20'
        ELSE '20+'
    END,
    CASE
        WHEN pb_score BETWEEN 60 AND 65 THEN '60_65'
        WHEN pb_score BETWEEN 65 AND 70 THEN '65_70'
        WHEN pb_score BETWEEN 70 AND 75 THEN '70_75'
        WHEN pb_score BETWEEN 75 AND 80 THEN '75_80'
        WHEN pb_score BETWEEN 80 AND 85 THEN '80_85'
        WHEN pb_score BETWEEN 85 AND 90 THEN '85_90'
        WHEN pb_score BETWEEN 90 AND 95 THEN '90_95'
        WHEN pb_score BETWEEN 95 AND 100 THEN '95_100'
        ELSE '100+'
    END,
    CASE
        WHEN avg_handicap < 4 THEN '<4'
        WHEN avg_handicap BETWEEN 5 AND 10 THEN '5_10'
        WHEN avg_handicap BETWEEN 10 AND 15 THEN '10_15'
        WHEN avg_handicap BETWEEN 15 AND 20 THEN '15_20'
        WHEN avg_handicap BETWEEN 20 AND 25 THEN '20_25'
        ELSE '25+'
    END