DELIMITER $$

CREATE DEFINER = `1bT12@uylp12`@`%` PROCEDURE thegrint_analytics.update_user_membership()
BEGIN
/**
* Update or create the user_membership table with the latest membership data.
*  This query should contain one row per user.
* 
* RUN TIME: ~120 seconds (2 minutes)
* 
* The user_membership table contains the following columns:
* - user_id: The user ID.
* - doj: The user's date of joining.
* - country: The user's country.
* - zipcode: The user's ZIP code.
* - last_login: The user's last login date.
* - verified: Whether the user is verified (1 for yes, 0 for no).
* - membership: The membership status (1 for active, 0 for inactive).
* - user_had_free_trial: Whether the user had a free trial (1 for yes, 0 for no).
* - has_had_pro_membership: Whether the user has had a Pro membership (1 for yes, 0 for no).
* - has_had_handicap_membership: Whether the user has had a Handicap membership (1 for yes, 0 for no).
*
* The procedure retrieves the latest membership data from the membership, membership_payment, membership_type, and membership_profile tables.
*
* On first create, run the following query to index the user_membership table:
*   CREATE INDEX user_membership_user_id ON thegrint_analytics.user_membership (user_id);
*/
    -- Create the user_membership table if it doesn't exist
    CREATE TABLE IF NOT EXISTS thegrint_analytics.user_membership (
        user_id INT PRIMARY KEY,
        doj DATE,
        country CHAR(2),
        zipcode VARCHAR(5),
        last_login DATE,
        verified TINYINT,
        membership TINYINT,
        user_had_free_trial TINYINT,
        has_had_pro_membership TINYINT,
        has_had_handicap_membership TINYINT
    );

    -- Insert or update the records
    INSERT INTO thegrint_analytics.user_membership (
        user_id, doj, country, zipcode, last_login, verified, membership, user_had_free_trial, has_had_pro_membership, has_had_handicap_membership
    )
    SELECT
        user.user_id,
        user.doj,
        user.country,
	    user.zipcode,
        user.last_login,
        user.verified,
        CASE WHEN membership.user_id IS NOT NULL THEN 1 ELSE 0 END AS membership,
        COALESCE(MAX(mp.trial_period), 0) AS user_had_free_trial,
        MAX(
            CASE
                WHEN mpf.profile_name LIKE 'pro%' AND mpf.profile_name <> 'pro_gift' AND mp.trial_period = 0 THEN 1
                ELSE 0
            END
        ) AS has_had_pro_membership,
        MAX(
            CASE
                WHEN mpf.profile_name = 'handicap' AND mp.trial_period = 0 THEN 1
                ELSE 0
            END
        ) AS has_had_handicap_membership
    FROM thegrint_grint.grint_user user
    LEFT JOIN thegrint_grint.membership AS membership
        ON user.user_id = membership.user_id
    LEFT JOIN thegrint_grint.membership_payment AS mp
        ON membership.user_id = mp.user_id AND membership.membership_id = mp.membership_id
    LEFT JOIN thegrint_grint.membership_type AS mt
        ON membership.membership_type_id = mt.membership_type_id
    LEFT JOIN thegrint_grint.membership_profile AS mpf
        ON mt.membership_profile_id = mpf.membership_profile_id
    GROUP BY
        user.user_id,
        user.doj,
        user.country,
	    user.zipcode,
        user.last_login,
        user.verified
    ON DUPLICATE KEY UPDATE
        doj = VALUES(doj),
        country = VALUES(country),
        zipcode = VALUES(zipcode),
        last_login = VALUES(last_login),
        verified = VALUES(verified),
        membership = VALUES(membership),
        user_had_free_trial = VALUES(user_had_free_trial),
        has_had_pro_membership = VALUES(has_had_pro_membership),
        has_had_handicap_membership = VALUES(has_had_handicap_membership);
END$$

DELIMITER ;
