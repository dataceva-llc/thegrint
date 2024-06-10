-- RUN TIME: ~120 seconds

-- Create a temp table to store user data
CREATE TEMPORARY TABLE IF NOT EXISTS thegrint_analytics.tmp_user_score_data AS
SELECT
    userid,
    MAX(total_rounds) AS total_rounds,
    MAX(pb_score) AS pb_score,
    
    MAX(next_round_handicap) AS next_round_handicap,
    AVG(next5_round_handicap) AS avg_next5_round_handicap,

    MAX(next_round_score) AS next_round_score,
    AVG(next5_round_score) AS avg_next5_round_score,
    
    MAX(handicap_index) AS max_handicap,
    MIN(handicap_index) AS min_handicap,
    AVG(handicap_index) AS avg_handicap,

    MAX(scround) AS max_score,
    MIN(scround) AS min_score,
    AVG(scround) AS avg_score
FROM (
    SELECT
        userid,
        pb_score,
        scround,
        total_rounds,
        @seq := IF (
            @prev_user = users_filtered.userid
            AND @is_pb_round = 1,
            @seq + 1, -- Add 1 to the sequence if the user is the same and this is the round after their best round
            1 -- Reset the sequence to 1 if the user is different or this is not the round after their best round
        ) AS tmp_seq,

        -- Set the variable to keep track of the user's best round
        @is_pb_round := IF(
            users_filtered.pb_score = users_filtered.scround
            AND @is_pb_round = 0
            AND @prev_user = users_filtered.userid,
            1,
            @is_pb_round
        ) AS is_pb_round,
        users_filtered.handicap_index,


        -- Keep the is pb round variable for the next row if the user is the same
        @is_pb_round := IF(@prev_user = users_filtered.userid, @is_pb_round, 0) AS is_pb_var,

        -- Get the handicap index for the next round if this is the round after the user's best round
        CASE WHEN @is_pb_round AND @seq = 2
            THEN users_filtered.handicap_index
            ELSE NULL
        END AS next_round_handicap,

        CASE WHEN @is_pb_round AND @seq = 2
            THEN users_filtered.scround
            ELSE NULL
        END AS next_round_score,

        -- Get the score for the next 5 rounds if this is the round after the user's best round
        CASE WHEN @is_pb_round AND @seq BETWEEN 2 AND 6
            THEN users_filtered.handicap_index
            ELSE NULL
        END AS next5_round_handicap,

        CASE WHEN @is_pb_round AND @seq BETWEEN 2 AND 6
            THEN users_filtered.scround
            ELSE NULL
        END AS next5_round_score,

        @prev_user := users_filtered.userid
    FROM thegrint_analytics.users_filtered_with_pb_data users_filtered
    CROSS JOIN (SELECT @seq := 0, @prev_user := NULL, @is_pb_round := 0) vars
) AS subq
GROUP BY userid;
CREATE INDEX idx_userid ON thegrint_analytics.tmp_user_score_data (userid);
-- SELECT * FROM thegrint_analytics.tmp_user_score_data;

-- Get the user's data after their best round
SELECT
    COUNT(*) AS number_of_users,
    CASE
        WHEN total_rounds BETWEEN 50 AND 100 THEN '50_100'
        WHEN total_rounds BETWEEN 100 AND 150 THEN '100_150'
        WHEN total_rounds BETWEEN 150 AND 200 THEN '150_200'
        WHEN total_rounds BETWEEN 200 AND 250 THEN '200_250'
        WHEN total_rounds BETWEEN 250 AND 500 THEN '250_500'
        ELSE '500+'
    END AS total_rounds_bucket,
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
        WHEN next_round_handicap < 4 THEN '<4'
        WHEN next_round_handicap BETWEEN 5 AND 10 THEN '5_10'
        WHEN next_round_handicap BETWEEN 10 AND 15 THEN '10_15'
        WHEN next_round_handicap BETWEEN 15 AND 20 THEN '15_20'
        WHEN next_round_handicap BETWEEN 20 AND 25 THEN '20_25'
        ELSE '25+'
    END AS next_round_handicap_bucket,
    CASE
        WHEN avg_next5_round_handicap < 4 THEN '<4'
        WHEN avg_next5_round_handicap BETWEEN 5 AND 10 THEN '5_10'
        WHEN avg_next5_round_handicap BETWEEN 10 AND 15 THEN '10_15'
        WHEN avg_next5_round_handicap BETWEEN 15 AND 20 THEN '15_20'
        WHEN avg_next5_round_handicap BETWEEN 20 AND 25 THEN '20_25'
        ELSE '25+'
    END AS avg_next5_round_handicap_bucket
FROM thegrint_analytics.tmp_user_score_data AS subq2
GROUP BY
    CASE
        WHEN total_rounds BETWEEN 50 AND 100 THEN '50_100'
        WHEN total_rounds BETWEEN 100 AND 150 THEN '100_150'
        WHEN total_rounds BETWEEN 150 AND 200 THEN '150_200'
        WHEN total_rounds BETWEEN 200 AND 250 THEN '200_250'
        WHEN total_rounds BETWEEN 250 AND 500 THEN '250_500'
        ELSE '500+'
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
        WHEN next_round_handicap < 4 THEN '<4'
        WHEN next_round_handicap BETWEEN 5 AND 10 THEN '5_10'
        WHEN next_round_handicap BETWEEN 10 AND 15 THEN '10_15'
        WHEN next_round_handicap BETWEEN 15 AND 20 THEN '15_20'
        WHEN next_round_handicap BETWEEN 20 AND 25 THEN '20_25'
        ELSE '25+'
    END,
    CASE
        WHEN avg_next5_round_handicap < 4 THEN '<4'
        WHEN avg_next5_round_handicap BETWEEN 5 AND 10 THEN '5_10'
        WHEN avg_next5_round_handicap BETWEEN 10 AND 15 THEN '10_15'
        WHEN avg_next5_round_handicap BETWEEN 15 AND 20 THEN '15_20'
        WHEN avg_next5_round_handicap BETWEEN 20 AND 25 THEN '20_25'
        ELSE '25+'
    END