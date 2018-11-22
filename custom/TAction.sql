USE FBank;
DELIMITER $$

-- -------------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Prepare_TLines_Temp $$
CREATE PROCEDURE App_TAction_Prepare_TLines_Temp()
BEGIN
   DROP TABLE IF EXISTS TLines_Temp;

   CREATE TEMPORARY TABLE TLines_Temp
   (
      id_person INT UNSIGNED,
      amount DECIMAL(5,2)
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
   DECLARE tamount DECIMAL(5,2);
   IF dorc=1 THEN
      SET tamount = amount;
   ELSE
      SET tamount = -amount;
   END IF;

   IF amount IS NOT NULL AND NOT (amount=0) THEN
      INSERT INTO TLines_Temp
      (id_person, amount)
      VALUES(person, tamount);
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
   DECLARE AMOUNT    DECIMAL(5,2);

   SELECT ';', '|' INTO TOK_LINE, TOK_FIELD;

   SET REM_LINES = linestxt;

   WHILE LENGTH(REM_LINES) > 0 DO
      SET REM_FIELDS = SUBSTRING_INDEX(REM_LINES, TOK_LINE, 1);
      SET REM_LINES = SUBSTRING(REM_LINES, LENGTH(REM_FIELDS)+2);

      SET NDX_FIELD = 0;
      SET PERSON_ID = NULL;
      SET AMOUNT = NULL;

      WHILE LENGTH(REM_FIELDS) > 0 DO
         SET CUR_FIELD = SUBSTRING_INDEX(REM_FIELDS, TOK_FIELD, 1);
         SET REM_FIELDS = SUBSTRING(REM_FIELDS, LENGTH(CUR_FIELD)+2);

         CASE NDX_FIELD
            WHEN 0 THEN SET PERSON_ID = CUR_FIELD;
            WHEN 1 THEN SET AMOUNT = CUR_FIELD;
         END CASE;

         SET NDX_FIELD = NDX_FIELD + 1;

      END WHILE;

      IF PERSON_ID IS NOT NULL AND AMOUNT IS NOT NULL THEN
         INSERT INTO TLines_Temp
            (id_person, amount)
            VALUES(PERSON_ID, AMOUNT);
      END IF;

   END WHILE;

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
   CALL App_TAction_Add_To_TLines_Temp(person,dorc,amount);
   CALL App_TAction_Parse_To_TLines_Temp(tlines);

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
            TLine (id_taction, id_person, amount)
            SELECT newid, id_person, amount
              FROM TLines_Temp;

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
