USE FBank;
DELIMITER $$

-- --------------------------------------
DROP PROCEDURE IF EXISTS App_PLine_Add $$
CREATE PROCEDURE App_PLine_Add(id_paction INT UNSIGNED,
                               id_person INT UNSIGNED,
                               amount NUMERIC(5,2))
BEGIN
   DECLARE newid INT UNSIGNED;
   DECLARE rcount INT UNSIGNED;

   INSERT INTO PLine
          (id_paction, 
           id_person, 
           amount)
   VALUES (id_paction, 
           id_person, 
           amount);

   SELECT ROW_COUNT() INTO rcount;
   IF rcount > 0 THEN
      SET newid = LAST_INSERT_ID();
      CALL App_PLine_List(newid);
   END IF;
END  $$


-- ----------------------------------------
DROP PROCEDURE IF EXISTS App_PLine_Value $$
CREATE PROCEDURE App_PLine_Value(id_paction INT UNSIGNED,
                                 id_person INT UNSIGNED)
BEGIN
   SELECT p.id_paction,
          p.id_person,
          p.amount
     FROM PLine p
    WHERE p.id_paction = id_paction
      AND p.id_person = id_person;
END $$


-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_PLine_Update $$
CREATE PROCEDURE App_PLine_Update(id_paction INT UNSIGNED,
                                  id_person INT UNSIGNED,
                                  amount NUMERIC(5,2),
                                  c_id_paction INT UNSIGNED,
                                  c_id_person INT UNSIGNED)
BEGIN
   UPDATE PLine p
      SET p.id_paction = id_paction,
          p.id_person = id_person,
          p.amount = amount
    WHERE p.id_paction = c_id_paction
      AND p.id_person = c_id_person;
END $$



-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_PLine_Delete $$
CREATE PROCEDURE App_PLine_Delete(id_paction INT UNSIGNED,
                                  id_person INT UNSIGNED)
BEGIN
   DELETE
     FROM p USING PLine AS p
    WHERE p.id_paction = id_paction
      AND p.id_person = id_person;

   SELECT ROW_COUNT() AS deleted;
END  $$

DELIMITER ;
