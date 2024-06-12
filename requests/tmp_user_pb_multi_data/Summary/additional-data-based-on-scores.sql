-- Get detailed insights into golfers' performance across different handicap buckets
-- This query calculates various metrics to understand trends and performance
-- Run time: ~2 seconds

SELECT
    COALESCE(avg_handicap_bucket, 'Total') AS avg_handicap_bucket,
    number_of_users,
    avg_pb_score,
    stddev_pb_score,
    avg_next_round_score_diff,
    stddev_next_round_score_diff,
    avg_next5_round_score_diff,
    stddev_next5_round_score_diff,
    avg_time_between_pbs,
    stddev_time_between_pbs,
    avg_pb_diff,
    stddev_pb_diff,
    avg_handicap,
    stddev_handicap,
    avg_previous_round_diff,
    stddev_previous_round_diff,
    rounds_to_decrease_by_1_stroke
FROM (
    SELECT
        COUNT(*) AS number_of_users,
        AVG(pb_round_score) AS avg_pb_score,
        STDDEV(pb_round_score) AS stddev_pb_score,
        AVG(next_round_score - pb_score) AS avg_next_round_score_diff,
        STDDEV(next_round_score - pb_score) AS stddev_next_round_score_diff,
        AVG(avg_next5_round_score - pb_score) AS avg_next5_round_score_diff,
        STDDEV(avg_next5_round_score - pb_score) AS stddev_next5_round_score_diff,
        
        AVG(avg_time_between_pbs) AS avg_time_between_pbs,
        STDDEV(avg_time_between_pbs) AS stddev_time_between_pbs,
        
        AVG(avg_pb_diff) AS avg_pb_diff,
        STDDEV(avg_pb_diff) AS stddev_pb_diff,

        AVG(avg_handicap) AS avg_handicap,
        STDDEV(avg_handicap) AS stddev_handicap,

        AVG(avg_previous_round_diff) AS avg_previous_round_diff,
        STDDEV(avg_previous_round_diff) AS stddev_previous_round_diff,

        -- Calculate how many rounds the user has to play to decrease their score by 1 stroke
        (-1 / AVG(avg_previous_round_diff)) AS rounds_to_decrease_by_1_stroke,

        CASE
            WHEN avg_handicap < 4 THEN '<4'
            WHEN avg_handicap BETWEEN 5 AND 10 THEN '5_10'
            WHEN avg_handicap BETWEEN 10 AND 15 THEN '10_15'
            WHEN avg_handicap BETWEEN 15 AND 20 THEN '15_20'
            WHEN avg_handicap BETWEEN 20 AND 25 THEN '20_25'
            ELSE '25+'
        END AS avg_handicap_bucket
    FROM thegrint_analytics.user_pb_multi_data
    GROUP BY
        CASE
            WHEN avg_handicap < 4 THEN '<4'
            WHEN avg_handicap BETWEEN 5 AND 10 THEN '5_10'
            WHEN avg_handicap BETWEEN 10 AND 15 THEN '10_15'
            WHEN avg_handicap BETWEEN 15 AND 20 THEN '15_20'
            WHEN avg_handicap BETWEEN 20 AND 25 THEN '20_25'
            ELSE '25+'
        END
) subq
ORDER BY
    CASE
        WHEN avg_handicap_bucket = '<4' THEN 1
        WHEN avg_handicap_bucket = '5_10' THEN 2
        WHEN avg_handicap_bucket = '10_15' THEN 3
        WHEN avg_handicap_bucket = '15_20' THEN 4
        WHEN avg_handicap_bucket = '20_25' THEN 5
        WHEN avg_handicap_bucket = '25+' THEN 6
        ELSE 7
    END;
