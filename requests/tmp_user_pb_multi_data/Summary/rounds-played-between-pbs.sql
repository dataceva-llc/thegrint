-- Get the user's data after their best round
-- Question: Frequency (number of rounds played) between personal bests by handicap bracket
-- Calculates the average number of rounds played between personal bests by handicap bracket
-- Run time: ~1 second
SELECT
    number_of_users,
    avg_time_between_pbs,
    COALESCE(avg_handicap_bucket, 'Total') AS avg_handicap_bucket
FROM (
    SELECT
        COUNT(*) AS number_of_users,
        AVG(avg_time_between_pbs) AS avg_time_between_pbs,
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
            WHEN avg_handicap < 4 THEN '<4'
            WHEN avg_handicap BETWEEN 5 AND 10 THEN '5_10'
            WHEN avg_handicap BETWEEN 10 AND 15 THEN '10_15'
            WHEN avg_handicap BETWEEN 15 AND 20 THEN '15_20'
            WHEN avg_handicap BETWEEN 20 AND 25 THEN '20_25'
            ELSE '25+'
        END WITH ROLLUP
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