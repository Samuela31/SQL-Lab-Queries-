CREATE TABLE stud (
    sid varchar(255) PRIMARY KEY,
    sname varchar(255) NOT NULL,
    dob DATE NOT NULL,
    city varchar(255) NOT NULL,
    cid varchar(255)
);


CREATE TABLE course(
    cid varchar(255) PRIMARY KEY,
    cname varchar(255) NOT NULL,
    sid varchar(255),
    tid varchar(255),
    FOREIGN KEY (sid) REFERENCES stud(sid)

);

CREATE TABLE teacher (
    tid varchar(255) PRIMARY KEY,
    tname varchar(255) NOT NULL,
    cid varchar(255),
    did varchar(255),
    FOREIGN KEY (cid) REFERENCES course(cid)

);

CREATE TABLE dept(
    did varchar(255) PRIMARY KEY,
    dname varchar(255) NOT NULL,
    tid varchar(255),
    FOREIGN KEY (tid) REFERENCES teacher(tid)

);

ALTER TABLE stud
ADD CONSTRAINT FK_st FOREIGN KEY (cid) REFERENCES course(cid);

ALTER TABLE course
ADD CONSTRAINT FK_cs FOREIGN KEY (tid) REFERENCES teacher(tid);

ALTER TABLE teacher
ADD CONSTRAINT FK_dt FOREIGN KEY (did) REFERENCES dept(did);

INSERT INTO stud(sid, sname, dob, city) VALUES('s01', 'sam', '08-MAR-11', 'chennai');
INSERT INTO course(cid, cname, sid) VALUES('c01', 'sql', 's01');
INSERT INTO teacher(tid, tname, cid) VALUES('t01', 'roland', 'c01');
INSERT INTO dept(did, dname, tid) VALUES('d01', 'cse', 't01');
UPDATE stud SET cid = 'c01' WHERE sid = 's01';
UPDATE course SET tid = 't01' WHERE cid = 'c01';
UPDATE teacher SET did = 'd01' WHERE tid = 't01';

INSERT INTO stud(sid, sname, dob, city) VALUES('s02', 'dan', '09-MAR-21', 'mumbai');
INSERT INTO course(cid, cname, sid) VALUES('c02', 'dbms', 's02');
INSERT INTO teacher(tid, tname, cid) VALUES('t02', 'alice', 'c02');
INSERT INTO dept(did, dname, tid) VALUES('d02', 'it', 't02');
UPDATE stud SET cid = 'c02' WHERE sid = 's02';
UPDATE course SET tid = 't02' WHERE cid = 'c02';
UPDATE teacher SET did = 'd02' WHERE tid = 't02';

INSERT INTO stud(sid, sname, dob, city) VALUES('s03', 'ian', '08-DEC-31', 'mumbai');
INSERT INTO course(cid, cname, sid) VALUES('c03', 'ds', 's03');
INSERT INTO teacher(tid, tname, cid) VALUES('t03', 'allen', 'c03');
INSERT INTO dept(did, dname, tid) VALUES('d03', 'aiml', 't03');
UPDATE stud SET cid = 'c02' WHERE sid = 's03';
UPDATE course SET tid = 't02' WHERE cid = 'c03';
UPDATE teacher SET did = 'd02' WHERE tid = 't03';

SELECT sname, city FROM stud WHERE sid='s03';
SELECT city FROM stud WHERE sid='s01' OR sid='s03';

SELECT sid FROM stud WHERE city='mumbai';

SELECT tid FROM teacher WHERE did='d01';

--returns the names of courses (course.cname) that are taught by teachers with IDs 't01', 't02', or 't03'. 
SELECT course.cname FROM course 
JOIN teacher ON course.cid = teacher.cid
WHERE teacher.tid = 't01' OR teacher.tid = 't02' OR teacher.tid = 't03';

--returns the names (sname) of students who were born in March.
SELECT sname FROM stud WHERE EXTRACT(MONTH FROM dob) = 3;

--join operation matches each student with the corresponding course they are enrolled in.
SELECT s.sname, c.cname
FROM stud s
JOIN course c ON s.cid = c.cid;

DELETE FROM stud WHERE sid = 's03';
