USE FBank;

DELIMITER $$

-- ---------------------------------------------
DROP FUNCTION IF EXISTS App_Get_Years_Elapsed $$
CREATE FUNCTION App_Get_Years_Elapsed(ref_date DATE, target_date DATE)
   RETURNS INT
BEGIN
   DECLARE ref_year    INTEGER DEFAULT YEAR(ref_date);
   DECLARE target_year INTEGER DEFAULT YEAR(target_date);
   DECLARE date_str    CHAR(10) DEFAULT CONCAT(target_year,'-',MONTH(ref_date),'-',DAYOFMONTH(ref_date));
   DECLARE anniversary DATE DEFAULT DATE(date_str);
   DECLARE diff_date   INTEGER DEFAULT DATEDIFF(anniversary, target_date);
   DECLARE year_end_elapsed INTEGER DEFAULT target_year - ref_year;

   IF diff_date > 0 THEN
      RETURN year_end_elapsed - 1;
   ELSE
      RETURN year_end_elapsed;
   END IF;
END $$

-- ----------------------------------------------
DROP FUNCTION IF EXISTS App_Get_Allowance_Date $$
-- CREATE FUNCTION App_Get_Allowance_Date()
--    RETURNS DATE
-- BEGIN
--    DECLARE tday DATE;
--    DECLARE dindex INT;
--    SELECT NOW(), WEEKDAY(tday) INTO tday, dindex;
   
--    IF dindex > 0 THEN
--       RETURN tday + INTERVAL 6-dindex DAY;
--    ELSE
--       RETURN tday;
--    END IF;
-- END $$

-- --------------------------------------------
DROP FUNCTION IF EXISTS App_Get_Allowance_Amount $$
CREATE FUNCTION App_Get_Allowance_Amount(edate DATETIME, bday DATE)
   RETURNS DECIMAL(5,2)
BEGIN
   DECLARE years_old INTEGER DEFAULT App_Get_Years_Elapsed(bday, edate);

   IF years_old > 3 AND years_old < 21 THEN
      RETURN years_old - 3;
   ELSE
      RETURN 0;
   END IF;
END $$

-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_Distribute_Allowances $$
CREATE PROCEDURE App_Distribute_Allowances(edate DATETIME)
BEGIN
   DECLARE rcount INT UNSIGNED;
   DECLARE newid INT UNSIGNED;

   INSERT INTO TAction
          (date_taction, trans_type, note)
   VALUES (edate, 'allowance', 'Allowance');

   IF ROW_COUNT() > 0 THEN
      SET newid = LAST_INSERT_ID();

      CALL App_TAction_Prepare_TLines_Temp();

      -- Make table of allowances
      INSERT INTO TLines_Temp
             (t_person, t_dorc, t_amount)
             SELECT t.*
             FROM (SELECT p.id,
                          0,
                          App_Get_Allowance_Amount(edate, p.bday) AS amt
                     FROM Person p) t
             WHERE t.amt > 0;

      -- Update balances, then add lines to transaction details:
      CALL App_TAction_Update_Balances_From_TLines_Temp();
      INSERT INTO TLine
             (id_taction, id_person, dorc, amount)
             SELECT newid, t_person, t_dorc, t_amount
               FROM TLines_Temp;

      CALL App_TAction_Cleanup_TLines_Temp();
   END IF;
END $$

-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_Grant_Allowances $$
CREATE PROCEDURE App_Grant_Allowances()
BEGIN
   CALL App_Distribute_Allowances(NOW());
END $$

-- ----------------------------------
-- DROP EVENT IF EXISTS grant_allowances
-- CREATE EVENT grant_allowances
--    ON SCHEDULE
--       EVERY 1 WEEK
--          STARTS CURRENT_DATE + INTERVAL 6 - WEEKDAY(CURRENT_DATE) DAY
--    DO CALL App_Grant_Allowances()  $$


DELIMITER ;
