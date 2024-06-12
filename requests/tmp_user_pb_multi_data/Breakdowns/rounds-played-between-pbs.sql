-- Get the user's data after their best round
-- Question: Frequency (number of rounds played) between personal bests by handicap bracket
-- Calculates the average number of rounds played between personal bests by handicap bracket
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
FROM thegrint_analytics.user_pb_multi_data AS subq2
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