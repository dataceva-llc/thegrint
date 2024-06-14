-- Get the user's data after their best round
-- Question: (ALT) What is the average difference above/below the next 5 rounds after a personal best
-- This query calculates the difference by handicap index NOT score
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
FROM thegrint_analytics.user_pb_multi_data AS subq2
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