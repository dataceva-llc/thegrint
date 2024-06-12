-- Create this table with the user data for all other SQL scripts in this folder
-- Create a temp table to store user data and pb's data for each user
-- ETA: ~420 seconds (7 minutes)
DROP TABLE IF EXISTS thegrint_analytics.user_pb_multi_data;
CREATE TABLE IF NOT EXISTS thegrint_analytics.user_pb_multi_data AS
SELECT
    userid,
    MAX(total_rounds) AS total_rounds,
    MAX(pb_score) AS pb_score,

    MAX(CASE WHEN pb_round_handicap BETWEEN -30 AND 100 THEN pb_round_handicap END) AS pb_round_handicap,
    MAX(CASE WHEN next_round_handicap BETWEEN -30 AND 100 THEN next_round_handicap END) AS next_round_handicap,
    AVG(CASE WHEN next5_round_handicap BETWEEN -30 AND 100 THEN next5_round_handicap END) AS avg_next5_round_handicap,

    MAX(CASE WHEN pb_round_score BETWEEN -30 AND 175 THEN pb_round_score END) AS pb_round_score,
    MAX(CASE WHEN next_round_score BETWEEN -30 AND 175 THEN next_round_score END) AS next_round_score,
    AVG(CASE WHEN next5_round_score BETWEEN -30 AND 175 THEN next5_round_score END) AS avg_next5_round_score,

    MAX(CASE WHEN time_between_pbs BETWEEN 0 AND 1000 THEN time_between_pbs END) AS max_time_between_pbs,
    MIN(CASE WHEN time_between_pbs BETWEEN 0 AND 1000 THEN time_between_pbs END) AS min_time_between_pbs,
    AVG(CASE WHEN time_between_pbs BETWEEN 0 AND 1000 THEN time_between_pbs END) AS avg_time_between_pbs,

    MAX(CASE WHEN pb_diff BETWEEN -30 AND 0 THEN pb_diff END) AS max_pb_diff,
    MIN(CASE WHEN pb_diff BETWEEN -30 AND 0 THEN pb_diff END) AS min_pb_diff,
    AVG(CASE WHEN pb_diff BETWEEN -30 AND 0 THEN pb_diff END) AS avg_pb_diff,
    
    MAX(CASE WHEN previous_round_diff BETWEEN -50 AND 50 THEN previous_round_diff END) AS max_previous_round_diff,
    MIN(CASE WHEN previous_round_diff BETWEEN -50 AND 50 THEN previous_round_diff END) AS min_previous_round_diff,
    AVG(CASE WHEN previous_round_diff BETWEEN -50 AND 50 THEN previous_round_diff END) AS avg_previous_round_diff,
    
    MAX(CASE WHEN handicap_index BETWEEN -30 AND 100 THEN handicap_index END) AS max_handicap,
    MIN(CASE WHEN handicap_index BETWEEN -30 AND 100 THEN handicap_index END) AS min_handicap,
    AVG(CASE WHEN handicap_index BETWEEN -30 AND 100 THEN handicap_index END) AS avg_handicap,

    MAX(CASE WHEN scround BETWEEN -30 AND 175 THEN scround END) AS max_score,
    MIN(CASE WHEN scround BETWEEN -30 AND 175 THEN scround END) AS min_score,
    AVG(CASE WHEN scround BETWEEN -30 AND 175 THEN scround END) AS avg_score
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

        IF (
            users_filtered.userid = @prev_user,
            users_filtered.scround - @previous_round,
            NULL
        ) AS previous_round_diff,

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

        @previous_round AS previous_round,
        @previous_round := users_filtered.scround AS ignore_previous_round,

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

        -- Set the variable to keep track of the user's best round
        @tmp_user := users_filtered.userid,
        @is_pb_round := IF(@prev_user <> users_filtered.userid AND @tmp_user = users_filtered.userid, 0, @is_pb_round) AS is_pb_var_tmp,
        @seq_pb := IF(@prev_user <> users_filtered.userid AND @tmp_user = users_filtered.userid, 1, @seq_pb) AS seq_pb_tmp,

        @is_pb_round := IF(
            users_filtered.pb_score = users_filtered.scround
            AND @is_pb_round = 0
            AND @tmp_user = users_filtered.userid,
            1,
            @is_pb_round
        ) AS is_pb_round,

        -- Increment the global PB sequence if the user is the same and this is the round after their best round
        @seq_pb := IF (
            @tmp_user = users_filtered.userid
            AND @is_pb_round = 1,
            @seq_pb + 1, -- Add 1 to the sequence if the user is the same and this is the round after their best round
            1 -- Reset the sequence to 1 if the user is different or this is not the round after their best round
        ) AS tmp_seq,

        -- Keep the is pb round variable for the next row if the user is the same
        -- @is_pb_round := IF(@prev_user = users_filtered.userid, @is_pb_round, 0) AS is_pb_var,

        -- Get the handicap index for the next round if this is the round after the user's best round
        CASE WHEN @is_pb_round AND @seq_pb = 2
            THEN users_filtered.handicap_index
            ELSE NULL
        END AS pb_round_handicap,

        CASE WHEN @is_pb_round AND @seq_pb = 2
            THEN users_filtered.scround
            ELSE NULL
        END AS pb_round_score,

        CASE WHEN @is_pb_round AND @seq_pb = 3
            THEN users_filtered.handicap_index
            ELSE NULL
        END AS next_round_handicap,

        CASE WHEN @is_pb_round AND @seq_pb = 3
            THEN users_filtered.scround
            ELSE NULL
        END AS next_round_score,

        -- Get the score for the next 5 rounds if this is the round after the user's best round
        CASE WHEN @is_pb_round AND @seq_pb BETWEEN 3 AND 7
            THEN users_filtered.handicap_index
            ELSE NULL
        END AS next5_round_handicap,

        CASE WHEN @is_pb_round AND @seq_pb BETWEEN 3 AND 7
            THEN users_filtered.scround
            ELSE NULL
        END AS next5_round_score,

        -- Set the previous user var to the current user for future processing
        @prev_user := users_filtered.userid
    FROM thegrint_analytics.users_filtered_with_pb_data users_filtered
    CROSS JOIN (SELECT
        @seq := 0,
        @seq_pb := 0,
        @prev_user := NULL,
        @tmp_user := NULL,
        @previous_best_round := 9999,
        @previous_round := 9999,
        @since_last_pb := 0,
        @is_pb_round := 0
    ) vars
) AS subq
GROUP BY userid;
CREATE INDEX idx_userid ON thegrint_analytics.user_pb_multi_data (userid);
-- SELECT * FROM thegrint_analytics.user_pb_multi_data;