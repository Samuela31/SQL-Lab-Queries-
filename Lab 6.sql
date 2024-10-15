CONNECT sys/123@//localhost:1521/xepdb1 AS SYSDBA;
CREATE USER sam IDENTIFIED BY 123;
GRANT CREATE TABLE, ALTER ANY TABLE, CREATE VIEW, CREATE TRIGGER, UPDATE ANY TABLE TO sam;
COMMIT;
GRANT CREATE SESSION TO sam;
COMMIT;
GRANT UNLIMITED TABLESPACE TO sam;
COMMIT;
GRANT CREATE PROCEDURE TO sam;
COMMIT;
CONNECT sam/123@//localhost:1521/xepdb1;



CREATE TABLE studd (
  Reg_no INT PRIMARY KEY,
  Name VARCHAR(50) NOT NULL,
  Tamil INT CHECK (Tamil >= 0 AND Tamil <= 200),
  English INT CHECK (English >= 0 AND English <= 200),
  Maths INT CHECK (Maths >= 0 AND Maths <= 200),
  Physics INT CHECK (Physics >= 0 AND Physics <= 200),
  Chemistry INT CHECK (Chemistry >= 0 AND Chemistry <= 200),
  Biology INT CHECK (Biology >= 0 AND Biology <= 200),
  Total INT NULL,
  Cut_off INT CHECK (Cut_off >= 0 AND Cut_off <= 200),
  Status VARCHAR(4) CHECK (Status IN ('Pass', 'Fail')),
  Rank INT
);

--Before inserting data into the studd table, the trigger ensures that the Total and Cut_off are calculated, and the Status is set as either "Pass" or "Fail" based on the marks
CREATE OR REPLACE TRIGGER calculate_marks_cutoff
BEFORE INSERT ON studd
FOR EACH ROW
BEGIN
    :NEW.Total := COALESCE(:NEW.Tamil, 0)
                 + COALESCE(:NEW.English, 0)
                 + COALESCE(:NEW.Maths, 0)
                 + COALESCE(:NEW.Physics, 0)
                 + COALESCE(:NEW.Chemistry, 0)
                 + COALESCE(:NEW.Biology, 0);

    :NEW.Cut_off := :NEW.Total / 6;

    IF (:NEW.Tamil < 75 OR
        :NEW.English < 75 OR
        :NEW.Maths < 75 OR
        :NEW.Physics < 75 OR
        :NEW.Chemistry < 75 OR
        :NEW.Biology < 75) THEN
        :NEW.Status := 'Fail';
    ELSE
        :NEW.Status := 'Pass';
    END IF;
END;
/

--If any subject marks are invalid (i.e., negative), the trigger prevents the insertion or update and throws an error, ensuring that only valid marks are stored in the table.
CREATE OR REPLACE TRIGGER check_subject_marks
BEFORE INSERT OR UPDATE ON studd
FOR EACH ROW
BEGIN
    IF (:NEW.Tamil < 0 OR
        :NEW.English < 0 OR
        :NEW.Maths < 0 OR
        :NEW.Physics < 0 OR
        :NEW.Chemistry < 0 OR
        :NEW.Biology < 0) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid Marks');
    END IF;
END;
/

--When update_rank_proc is executed, it assigns ranks to all students who passed, with rank 1 going to the student with the highest total marks
CREATE OR REPLACE PROCEDURE update_rank_proc AS
    v_rank NUMBER := 1;
BEGIN
    FOR rec IN (SELECT Reg_No, Total
                FROM studd
                WHERE Status = 'Pass'
                ORDER BY Total DESC)
    LOOP
        UPDATE studd
        SET Rank = v_rank
        WHERE Reg_No = rec.Reg_No;
        
        v_rank := v_rank + 1;
    END LOOP;
END;
/


INSERT INTO studd(Reg_No, Name, Tamil, English, Maths, Physics, Chemistry, Biology)
VALUES (1, 'John Doe', 85, 90, 95, 80, 87, 92);
INSERT INTO studd(Reg_No, Name, Tamil, English, Maths, Physics, Chemistry, Biology)
VALUES (2, 'Judy Y', 75, 94, 85, 80, 87, 92);
INSERT INTO studd(Reg_No, Name, Tamil, English, Maths, Physics, Chemistry, Biology)
VALUES (3, 'Vlad', 74, 94, 85, 80, 87, 92);
INSERT INTO studd(Reg_No, Name, Tamil, English, Maths, Physics, Chemistry, Biology)
VALUES (4, 'Shelia', 94, 94, 85, 90, 97, 92);
SELECT * FROM studd;

EXEC update_rank_proc;
SELECT * FROM studd;


CREATE TABLE student_log (
  Reg_No NUMBER,
  Name VARCHAR2(50),
  Deleted_Date DATE
);

--Whenever a student is deleted from the studd table, the deleted student's registration number, name, and deletion date are logged in the student_log table
CREATE OR REPLACE TRIGGER delete_student_trigger
AFTER DELETE ON studd
FOR EACH ROW
BEGIN

    INSERT INTO student_log(Reg_No, Name, Deleted_Date)
    VALUES (:OLD.Reg_No, :OLD.Name, SYSDATE);
END;
/

DELETE FROM studd
WHERE Status = 'Fail';
SELECT * FROM studd;
SELECT * FROM student_log;


CREATE VIEW Marks AS
SELECT Reg_no, Name, Cut_off
FROM studd;

SELECT * FROM Marks;


CREATE VIEW Rank AS
SELECT Reg_no, Rank
FROM studd;

SELECT * FROM Rank;
