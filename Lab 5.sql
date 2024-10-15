CREATE TABLE book(
      title varchar(225) NOT NULL,
      price INT NOT NULL
);

INSERT INTO book(title, price) VALUES('DSA', 400);
INSERT INTO book(title, price) VALUES('ML', 300);
INSERT INTO book(title, price) VALUES('Web Tech', 250);
INSERT INTO book(title, price) VALUES('DS', 450);
INSERT INTO book(title, price) VALUES('DBMS', 400);
INSERT INTO book(title, price) VALUES('AI', 200);
INSERT INTO book(title, price) VALUES('JAVA', 100);

--exactly 4 other books have a price greater than the current book's price (5th expensive book)
SELECT b.title FROM book b
WHERE (SELECT COUNT(*) FROM book t
WHERE t.price>b.price)=4;

--5th least cost book
SELECT b.title FROM book b
WHERE (SELECT COUNT(*) FROM book t
WHERE t.price<b.price)<4
ORDER BY b.price;

--4th least expensive
SELECT b.title FROM book b
WHERE (SELECT COUNT(*) FROM book t
WHERE t.price<b.price)=3;

--6th expensive
SELECT b.title FROM book b
WHERE (SELECT COUNT(*) FROM book t
WHERE t.price>b.price)=5;

SELECT b.title FROM book b
WHERE (SELECT COUNT(*) FROM book t
WHERE t.price>b.price)<3
ORDER BY b.price DESC;

CREATE TABLE student(
      name varchar(225) NOT NULL,
      gender varchar(225) NOT NULL,
      marks INT NOT NULL,
      grade varchar(55) NOT NULL
);

ALTER TABLE student
ADD CONSTRAINT CHK_gn CHECK(gender='F' OR gender='M')
ADD CONSTRAINT CHK_grd CHECK(grade='pass' OR grade='fail');

INSERT INTO student(name, gender, marks, grade) VALUES('sam', 'F', 95, 'pass');
INSERT INTO student(name, gender, marks, grade) VALUES('anne', 'F', 89, 'pass');
INSERT INTO student(name, gender, marks, grade) VALUES('austin', 'M', 88, 'pass');
INSERT INTO student(name, gender, marks, grade) VALUES('max', 'M', 49, 'fail');
INSERT INTO student(name, gender, marks, grade) VALUES('ally', 'F', 75, 'pass');
INSERT INTO student(name, gender, marks, grade) VALUES('kevin', 'M', 91, 'pass');
INSERT INTO student(name, gender, marks, grade) VALUES('ara', 'F', 99, 'pass');
INSERT INTO student(name, gender, marks, grade) VALUES('heli', 'M', 90, 'pass');

--names of female students whose marks are greater than the highest marks scored by a male student
SELECT f.name FROM student f
WHERE f.gender='F' AND 
f.marks>(SELECT MAX(m.marks) 
FROM student m 
WHERE m.gender='M');

--male students who have higher marks than at least one female student
SELECT m.name FROM student m
WHERE m.gender='M' AND
(SELECT COUNT(*) FROM student f
WHERE f.gender='F' AND m.marks>f.marks)>0;

--names of three students where the first student's marks are exactly 1 more than the second student's marks, and the second student's marks are exactly 1 more than the third student's marks
SELECT a.name, b.name, c.name FROM student a,student b, student c
WHERE a.marks-b.marks=1 AND b.marks-c.marks=1;

--compares the pass rate of male and female students and selects the gender where the pass rate of the opposite gender is higher
SELECT DISTINCT a.gender FROM student a, student b
WHERE ((SELECT COUNT(*) FROM student 
WHERE gender!=b.gender AND grade='pass')/(
SELECT COUNT(*) FROM student 
WHERE gender!=b.gender))>
((SELECT COUNT(*) FROM student 
WHERE gender!=a.gender AND grade='pass')/(
SELECT COUNT(*) FROM student 
WHERE gender!=a.gender));
