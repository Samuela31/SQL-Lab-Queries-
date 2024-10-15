CREATE TABLE students(
      name varchar(225) NOT NULL,
      gender varchar(225) NOT NULL,
      marks INT NOT NULL,
      grade varchar(55) NOT NULL
);

INSERT INTO students(name, gender, marks, grade) VALUES('sam', 'F', 95, 'pass');
INSERT INTO students(name, gender, marks, grade) VALUES('anne', 'F', 89, 'pass');
INSERT INTO students(name, gender, marks, grade) VALUES('austin', 'M', 88, 'pass');
INSERT INTO students(name, gender, marks, grade) VALUES('max', 'M', 49, 'fail');
INSERT INTO students(name, gender, marks, grade) VALUES('ally', 'F', 75, 'pass');
INSERT INTO students(name, gender, marks, grade) VALUES('kevin', 'M', 91, 'pass');
INSERT INTO students(name, gender, marks, grade) VALUES('ara', 'F', 99, 'pass');
INSERT INTO students(name, gender, marks, grade) VALUES('heli', 'M', 90, 'pass');




CREATE VIEW FMarks AS
SELECT name, marks
FROM students
WHERE gender = 'F';

SELECT * FROM FMarks;




DROP PROCEDURE fstudentList;  

--This procedure deletes the student(s) whose marks equal the value passed in as a parameter
CREATE PROCEDURE fstudentList(marks NUMBER) AS
   fnumber NUMBER;
   BEGIN
      DELETE FROM students
      WHERE students.marks = fstudentList.marks;
   fnumber  :=fnumber  - 1;
   END;
/
--to execute procedure
EXEC fstudentList(75);  

SELECT * FROM students;




DROP TRIGGER afins;  

--The trigger uses the DBMS_OUTPUT.PUT_LINE function to output the message 'Inserted' every time a new record is successfully inserted into the students table
CREATE TRIGGER afins
AFTER INSERT ON students
FOR EACH ROW
BEGIN
 DBMS_OUTPUT.PUT_LINE('Inserted');
END;
/
