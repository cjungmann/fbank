SET default_storage_engine=InnoDB;

CREATE TABLE IF NOT EXISTS Person
(
   id      INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   name    VARCHAR(20),
   bday    DATE,
   balance DECIMAL(6,2) DEFAULT 0
);

-- Transaction table
CREATE TABLE IF NOT EXISTS TAction
(
   id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   date_taction DATETIME,
   trans_type   ENUM('generic','allowance','fine','transfer'),
   note         VARCHAR(128)
);

-- Transaction Line table
CREATE TABLE IF NOT EXISTS TLine
(
   id_taction   INT UNSIGNED NOT NULL,
   id_person    INT UNSIGNED NOT NULL,
   dorc         BOOLEAN,   -- Debit=0 Credit=1
   amount       DECIMAL(6,2),

   INDEX(id_taction),
   INDEX(id_person)
);


