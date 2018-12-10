USE FBank;
DELIMITER $$

-- ----------------------------------------
DROP PROCEDURE IF EXISTS App_Person_List $$
CREATE PROCEDURE App_Person_List(id INT UNSIGNED)
BEGIN
   SELECT p.id,
          p.name,
          p.bday,
          p.balance
     FROM Person p
    WHERE (id IS NULL OR p.id = id);
END  $$


-- ---------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Add $$
CREATE PROCEDURE App_Person_Add(name VARCHAR(20),
                                bday DATE,
                                balance NUMERIC(5,2))
BEGIN
   DECLARE newid INT UNSIGNED;
   DECLARE rcount INT UNSIGNED;

   INSERT INTO Person
          (name, 
           bday, 
           balance)
   VALUES (name, 
           bday, 
           balance);

   SELECT ROW_COUNT() INTO rcount;
   IF rcount > 0 THEN
      SET newid = LAST_INSERT_ID();
      CALL App_Person_List(newid);
   END IF;
END  $$


-- ----------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Read $$
CREATE PROCEDURE App_Person_Read(id INT UNSIGNED)
BEGIN
   SELECT p.id,
          p.name,
          p.bday,
          p.balance
     FROM Person p
    WHERE (id IS NULL OR p.id = id);
END  $$


-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Value $$
CREATE PROCEDURE App_Person_Value(id INT UNSIGNED)
BEGIN
   SELECT p.id,
          p.name,
          p.bday,
          p.balance
     FROM Person p
    WHERE p.id = id;
END $$


-- ------------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Update $$
CREATE PROCEDURE App_Person_Update(id INT UNSIGNED,
                                   name VARCHAR(20),
                                   bday DATE,
                                   balance NUMERIC(5,2))
BEGIN
   UPDATE Person p
      SET p.name = name,
          p.bday = bday,
          p.balance = balance
    WHERE p.id = id;

   IF ROW_COUNT() > 0 THEN
      CALL App_Person_List(id);
   END IF;
END $$



-- ------------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Delete $$
CREATE PROCEDURE App_Person_Delete(id INT UNSIGNED)
BEGIN
   DELETE
     FROM p USING Person AS p
    WHERE p.id = id;

   SELECT ROW_COUNT() AS deleted;
END  $$

-- ----------------------------------------------
DROP PROCEDURE IF EXISTS App_Reconcile_Balances $$
CREATE PROCEDURE App_Reconcile_Balances()
BEGIN
   UPDATE Person p
          INNER JOIN (
             SELECT id_person,
                    SUM(CASE WHEN NOT(dorc)
                             THEN amount
                             ELSE 0
                         END) AS debit,
                    SUM(CASE WHEN dorc
                             THEN amount
                             ELSE 0
                         END) AS credit
               FROM TLine
               GROUP BY id_person) s ON s.id_person = p.id
      SET balance = s.debit - s.credit;

      CALL App_Person_List();
END $$

DELIMITER ;
