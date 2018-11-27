USE FBank;
DELIMITER $$

-- -------------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Prepare_TLines_Temp $$
CREATE PROCEDURE App_TAction_Prepare_TLines_Temp()
BEGIN
   DROP TABLE IF EXISTS TLines_Temp;

   CREATE TEMPORARY TABLE TLines_Temp
   (
      t_person INT UNSIGNED,
      t_dorc BOOLEAN,
      t_amount DECIMAL(5,2)
    );

END $$

-- --------------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Cleanup_TLines_Temp $$
CREATE PROCEDURE App_TAction_Cleanup_TLines_Temp()
BEGIN
   DROP TABLE IF EXISTS TLines_Temp;
END $$

-- ---------------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Add_To_TLines_Temp $$
CREATE PROCEDURE App_TAction_Add_To_TLines_Temp(person INT UNSIGNED,
                                                dorc INT UNSIGNED,
                                                amount DECIMAL(5,2))
BEGIN
   -- IF amount IS NOT NULL AND NOT (amount=0) THEN
   IF amount <> 0 THEN
      INSERT INTO TLines_Temp
      (t_person, t_dorc, t_amount)
      VALUES(person, dorc, amount);
   END IF;
END $$

-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Parse_To_TLines_Temp $$
CREATE PROCEDURE App_TAction_Parse_To_TLines_Temp(linestxt TEXT)
BEGIN
   DECLARE TOK_LINE  CHAR(1);
   DECLARE TOK_FIELD CHAR(1);

   DECLARE REM_LINES  TEXT;
   DECLARE REM_FIELDS TEXT;
   DECLARE CUR_FIELD  TEXT;
   DECLARE NDX_FIELD  INT UNSIGNED;

   DECLARE PERSON_ID INT UNSIGNED;
   DECLARE DORC      BOOLEAN;
   DECLARE AMOUNT    DECIMAL(5,2);

   SELECT ';', '|' INTO TOK_LINE, TOK_FIELD;

   SET REM_LINES = linestxt;

   WHILE LENGTH(REM_LINES) > 0 DO
      SET REM_FIELDS = SUBSTRING_INDEX(REM_LINES, TOK_LINE, 1);
      SET REM_LINES = SUBSTRING(REM_LINES, LENGTH(REM_FIELDS)+2);

      SET NDX_FIELD = 0;
      SET PERSON_ID = NULL;
      SET DORC = 0;
      SET AMOUNT = NULL;

      WHILE LENGTH(REM_FIELDS) > 0 DO
         SET CUR_FIELD = SUBSTRING_INDEX(REM_FIELDS, TOK_FIELD, 1);
         SET REM_FIELDS = SUBSTRING(REM_FIELDS, LENGTH(CUR_FIELD)+2);

         CASE NDX_FIELD
            WHEN 0 THEN SET PERSON_ID = CUR_FIELD;
            WHEN 1 THEN SET DORC = CUR_FIELD;
            WHEN 2 THEN SET AMOUNT = CUR_FIELD;
         END CASE;

         SET NDX_FIELD = NDX_FIELD + 1;

      END WHILE;

      IF PERSON_ID IS NOT NULL AND AMOUNT IS NOT NULL THEN
         INSERT INTO TLines_Temp
            (t_person, t_dorc, t_amount)
            VALUES(PERSON_ID, DORC, AMOUNT);
      END IF;

   END WHILE;

END $$

-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Update_Balances_From_TLines_Temp $$
CREATE PROCEDURE App_TAction_Update_Balances_From_TLines_Temp()
BEGIN
   DROP TABLE IF EXISTS pdiff;

   -- Create and populate summed debits/credits table:
   CREATE TEMPORARY TABLE pdiff
   (
      p_person INT UNSIGNED,
      p_debits DECIMAL(5,2) DEFAULT 0,
      p_credits DECIMAL(5,2) DEFAULT 0
   );

   INSERT INTO pdiff
          (p_person, p_debits, p_credits)
          SELECT t_person,
                 SUM(CASE WHEN NOT(t_dorc)
                          THEN t_amount
                          ELSE 0
                      END),
                 SUM(CASE WHEN t_dorc
                          THEN t_amount
                          ELSE 0
                       END)
            FROM TLines_Temp
           GROUP BY t_person;

   -- Update with summed debits/credits table
   UPDATE Person p
      INNER JOIN pdiff d ON p.id = d.p_person
      SET p.balance = p.balance + d.p_debits - d.p_credits;

   DROP TABLE pdiff;
      
END $$

-- ------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Get_Lines $$
CREATE PROCEDURE App_TAction_Get_Lines(taction_id INT UNSIGNED)
BEGIN
   SELECT p.id, p.name, l.amount
     FROM TLine l
          INNER JOIN Person p ON p.id = l.id_person
    WHERE l.id_taction = taction_id;
END $$

-- --------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Person_Lookup $$
CREATE PROCEDURE App_TAction_Person_Lookup()
BEGIN
   SELECT id, name
     FROM Person;
END $$

-- ----------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Add_Setup $$
CREATE PROCEDURE App_TAction_Add_Setup(id INT UNSIGNED)
BEGIN
   CALL App_TAction_Get_Lines(NULL);
   CALL App_TAction_Person_Lookup();

   IF id IS NOT NULL THEN
      SELECT id AS person;
   END IF;
END $$

-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_List $$
CREATE PROCEDURE App_TAction_List(id INT UNSIGNED)
BEGIN
   SELECT t.id,
          t.date_taction,
          t.note
     FROM TAction t
    WHERE (id IS NULL OR t.id = id);
END $$

-- ----------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Add $$
CREATE PROCEDURE App_TAction_Add(tlines TEXT,
                                 person INT UNSIGNED,
                                 dorc INT UNSIGNED,
                                 amount DECIMAL(5,2),
                                 tnote TEXT)
BEGIN
   DECLARE newid INT UNSIGNED;
   DECLARE rcount INT UNSIGNED;

   -- Create a temp table with submitted transaction lines:
   CALL App_TAction_Prepare_TLines_Temp();
   CALL App_TAction_Parse_To_TLines_Temp(tlines);
   CALL App_TAction_Add_To_TLines_Temp(person,dorc,amount);

   SELECT COUNT(*) INTO rcount
     FROM TLines_Temp;

   -- Only create a transaction record if there are transaction lines:
   IF rcount > 0 THEN
      INSERT INTO TAction
             (date_taction,
              note)
      VALUES (NOW(), 
              tnote);

      -- Reuse rcount variable now that it served its gatekeeper role:
      SELECT ROW_COUNT() INTO rcount;
      IF rcount > 0 THEN
         SET newid = LAST_INSERT_ID();

         INSERT INTO
            TLine (id_taction, id_person, dorc, amount)
            SELECT newid, t_person, t_dorc, t_amount
              FROM TLines_Temp;

         CALL App_TAction_Update_Balances_From_TLines_Temp();

         -- for update result:
         CALL App_TAction_List(newid);

      END IF;
   END IF;

   CALL App_TAction_Cleanup_TLines_Temp();
END  $$


-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Read $$
CREATE PROCEDURE App_TAction_Read(id INT UNSIGNED)
BEGIN
   SELECT t.id,
          t.date_taction,
          t.note
     FROM TAction t
    WHERE (id IS NULL OR t.id = id);

   CALL App_TAction_Get_Lines(id);
   CALL App_TAction_Person_Lookup();
END  $$

DELIMITER ;
