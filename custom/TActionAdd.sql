USE FBank;
DELIMITER $$

-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_List $$
CREATE PROCEDURE App_TAction_List(id INT UNSIGNED)
BEGIN
   SELECT t.id,
          t.date_taction,
          t.note
     FROM TAction t
    WHERE (id IS NULL OR t.id = id);
END  $$

-- ------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Get_Lines $$
CREATE PROCEDURE App_TAction_Get_Lines(taction_id INT UNSIGNED)
BEGIN
   SELECT p.id, p.name, l.amount
     FROM TLine l
          INNER JOIN Person p ON p.id = l.id_person
    WHERE TLine.id_taction = taction_id;
END $$

-- --------------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Person_Lookup $$
CREATE PROCEDURE App_TAction_Person_Lookup()
BEGIN
   SELECT id, name
     FROM People;
END $$


-- ------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Value $$
CREATE PROCEDURE App_TAction_Value(id INT UNSIGNED)
BEGIN
   SELECT t.id,
          t.date_taction,
          t.note
     FROM TAction t
    WHERE t.id = id;

   CALL App_TAction_Get_Lines(id);
   CALL App_TAction_Person_Lookup();
END $$


-- -------------------------------------------
DROP PROCEDURE IF EXISTS App_TAction_Update $$
CREATE PROCEDURE App_TAction_Update(id INT UNSIGNED,
                                    date_taction DATETIME,
                                    note VARCHAR(128))
BEGIN
   UPDATE TAction t
      SET t.date_taction = date_taction,
          t.note = note
    WHERE t.id = id;

   IF ROW_COUNT() > 0 THEN
      CALL App_TAction_List(id);
   END IF;
END $$


DELIMITER ;
