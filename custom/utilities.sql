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
CREATE FUNCTION App_Get_Allowance_Date()
   RETURNS DATE
BEGIN
   DECLARE tday DATE;
   DECLARE dindex INT;
   SELECT NOW(), WEEKDAY(tday) INTO tday, dindex;
   
   IF dindex > 0 THEN
      RETURN tday + INTERVAL 6-dindex DAY;
   ELSE
      RETURN tday;
   END IF;
END $$

-- --------------------------------------------
DROP FUNCTION IF EXISTS Get_Allowance_Amount $$
CREATE FUNCTION Get_Allowance_Amount(bday DATE)
   RETURNS DECIMAL(5,2)
BEGIN
   DECLARE sunday DATE DEFAULT App_Get_Allowance_Date();
   DECLARE years_old INTEGER DEFAULT App_Get_Years_Elapsed(bday, sunday);

   RETURN years_old - 3;
END $$


DELIMITER ;
