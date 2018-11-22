SET default_storage_engine=InnoDB;

CREATE TABLE IF NOT EXISTS Person
(
   id      INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   name    VARCHAR(20),
   bday    DATE,
   balance DECIMAL(5,2) DEFAULT 0
);

-- Transaction table
CREATE TABLE IF NOT EXISTS TAction
(
   id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   date_taction DATETIME,
   note         VARCHAR(128)
);

-- Transaction Line table
CREATE TABLE IF NOT EXISTS TLine
(
   id_taction   INT UNSIGNED NOT NULL,
   id_person    INT UNSIGNED NOT NULL,
   amount       DECIMAL(5,2),

   INDEX(id_taction),
   INDEX(id_person)
);


-- Two tables to stage pending transactions until complete
-- Pending transaction table
CREATE TABLE IF NOT EXISTS PAction
(
   id      INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   started DATETIME,
   note    VARCHAR(128)
);

-- Pending transaction line table
CREATE TABLE IF NOT EXISTS PLine
(
   id_paction INT UNSIGNED NOT NULL,
   id_person  INT UNSIGNED NOT NULL,
   amount     DECIMAL(5,2),

   INDEX(id_paction)
);
