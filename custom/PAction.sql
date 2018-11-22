USE FBank;
DELIMITER $$

-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_PAction_Initialize $$
CREATE PROCEDURE App_PAction_Initialize(OUT id INT UNSIGNED)
BEGIN
   INSERT INTO PAction 
          ( started, note )
   VALUES ( NOW(), NULL);

   IF ROW_COUNT() > 0 THEN
      SELECT LAST_INSERT_ID() INTO id;
   ELSE
      SELECT NULL INTO id;
   END IF;
END $$

-- ----------------------------------------------
DROP PROCEDURE IF EXISTS App_PAction_Get_Lines $$
CREATE PROCEDURE App_PAction_Get_Lines(paction_id INT UNSIGNED)
BEGIN
   SELECT p.id, p.name, l.amount
     FROM PLine l
          INNER JOIN Person p ON l.id_person = p.id
    WHERE l.id_paction = paction_id;
END $$

-- -----------------------------------------------
DROP PROCEDURE IF EXISTS App_PAction_Get_Lookup $$
CREATE PROCEDURE App_PAction_Get_Lookup()
BEGIN
   SELECT p.id, p.name
     FROM Person p;
END $$

-- ------------------------------------------
DROP PROCEDURE IF EXISTS App_PAction_Value $$
CREATE PROCEDURE App_PAction_Value()
BEGIN

   DECLARE id INT UNSIGNED;
   CALL App_PAction_Initialize(id);

   IF id IS NOT NULL THEN
      SELECT p.id,
             p.note,
             NULL AS alist
        FROM PAction p
       WHERE p.id = id;

      CALL App_PAction_Get_Lookup();

      CALL App_PAction_Get_Lines(id);
   END IF;
END $$

-- -------------------------------------------
DROP PROCEDURE IF EXISTS App_PAction_Update $$
CREATE PROCEDURE App_PAction_Update(id INT UNSIGNED,
                                    note VARCHAR(128),
                                    alist INT UNSIGNED)
BEGIN
   UPDATE PAction p
      SET p.note = note
    WHERE p.id = id;

   IF ROW_COUNT() > 0 THEN
      CALL App_PAction_List(id);
   END IF;
END $$


DELIMITER ;
