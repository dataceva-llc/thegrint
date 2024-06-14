CREATE DEFINER=`1bT12@uylp12`@`%` PROCEDURE `iterate_rows`()
BEGIN
    DECLARE row_count INT DEFAULT 0;
    DECLARE max_rows INT;
    DECLARE cur_id int;
    DECLARE cur_value varchar(20);

    -- Get the total number of rows in the north_star_ids
    SELECT COUNT(*) INTO max_rows FROM north_star_ids;


    SET row_count = 0;

    -- Fetch rows one by one and insert into the new table
    WHILE row_count < 1000 AND row_count < max_rows DO
        SELECT n.north_id, n.value
        INTO cur_id,cur_value
        FROM north_star_ids n
        ORDER BY north_id
        LIMIT row_count, 1;

        INSERT INTO iterable1 (n_id, valuee)
        VALUES (cur_id, cur_value);

        SET row_count = row_count + 1;
    END WHILE;
END