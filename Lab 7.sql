CREATE TABLE stud(
regno INT PRIMARY KEY, 
name VARCHAR(50) NOT NULL, 
tamil INT CHECK(tamil>0 AND tamil<=200) NOT NULL,
english INT CHECK(english>0 AND english<=200) NOT NULL, 
maths INT CHECK(maths>0 AND maths<=200) NOT NULL, 
physics INT CHECK(physics>0 AND physics<=200) NOT NULL,
chemistry INT CHECK(chemistry>0 AND chemistry<=200) NOT NULL,
biology INT CHECK(biology>0 AND biology<=200) NOT NULL,
total INT NULL,
cutoff INT  CHECK(cutoff>0 AND cutoff<=200),
status VARCHAR(4) CHECK(status='pass' OR status='fail'),
rank VARCHAR(1)
);



--Before inserting or updating a student record, the trigger ensures that the total marks, cutoff, pass/fail status, and rank are calculated and assigned based on the provided data.
CREATE OR REPLACE TRIGGER stu_marks
BEFORE INSERT OR UPDATE ON stud
FOR EACH ROW
BEGIN
   :NEW.total := (:NEW.tamil+ :NEW.english+ :NEW.maths+ :NEW.physics+ :NEW.chemistry+ :NEW.biology)/6;

   :NEW.cutoff := (:NEW.maths+ :NEW.physics+ :NEW.chemistry)/3;

   IF (:NEW.tamil<75 OR :NEW.english<75 OR :NEW.maths<75 OR :NEW.physics<75 OR :NEW.chemistry<75 OR :NEW.biology<75) THEN
   :NEW.status:='fail';
   ELSE :NEW.status:='pass';

   END IF;
   
   IF (:NEW.total>180) THEN :NEW.rank:='O';
   END IF;
   IF (:NEW.total>150 AND :NEW.total<=180) THEN :NEW.rank:='A';
   END IF;
   IF (:NEW.total<=150) THEN :NEW.rank:='B';
   END IF;
END;
/

INSERT INTO stud(regno, name, tamil, english, maths, physics, chemistry, biology) VALUES(71701,'sam',200,199,198,200,197,200);
SELECT * FROM stud;

INSERT INTO stud(regno, name, tamil, english, maths, physics, chemistry, biology) VALUES(71702,'sam',200,199,198,200,197,200);
SELECT * FROM stud;

INSERT INTO stud(regno, name, tamil, english, maths, physics, chemistry, biology) VALUES(71703,'shelly',99,199,98,200,97,200);
SELECT * FROM stud;



--After a student record is deleted, the system outputs a message showing the registration number of the deleted student. This message is printed to the server's output.
CREATE OR REPLACE TRIGGER stu_del
AFTER DELETE ON stud
FOR EACH ROW
DECLARE 
   reg NUMBER; 
BEGIN
    reg:=:OLD.regno;
    DBMS_OUTPUT.PUT_LINE('Record of ' || reg || ' is deleted');
END;
/
SET SERVEROUTPUT ON;
DELETE FROM stud WHERE regno=71702;
SELECT * FROM stud;



--Before inserting or updating a student record, the trigger ensures that all subject marks are greater than 0. If any invalid marks are detected, the insertion or update is blocked, and an error message is raised.
CREATE OR REPLACE TRIGGER zero_error
BEFORE INSERT OR UPDATE ON stud
FOR EACH ROW
BEGIN
    IF (:NEW.tamil<=0 OR :NEW.english<=0 OR :NEW.maths<=0 OR :NEW.physics<=0 OR :NEW.chemistry<=0 OR :NEW.biology<=0) THEN
    RAISE_APPLICATION_ERROR(-20001,'Invalid Marks');
   END IF; 
END;
/

INSERT INTO stud(regno, name, tamil, english, maths, physics, chemistry, biology) VALUES(71703,'sam',0,-19,198,200,197,200);




CREATE VIEW cutmarks AS
SELECT regno, name, cutoff
FROM stud;
SELECT * FROM cutmarks;




CREATE VIEW crank AS
SELECT regno, rank
FROM stud;
SELECT * FROM crank;




UPDATE stud SET tamil=150 
WHERE regno=71703;
SELECT * FROM cutmarks;
SELECT * FROM crank;
