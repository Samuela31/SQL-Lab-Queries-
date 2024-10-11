CREATE TABLE supplier(
    sid varchar(255) PRIMARY KEY,
    sname varchar(255) NOT NULL,
    rating int
);

CREATE TABLE parts(
    pid varchar(255) PRIMARY KEY,
    pname varchar(255) NOT NULL,
    color varchar(255) NOT NULL
);

CREATE TABLE catalog(
    sid varchar(255),
    pid varchar(255),
    cost int NOT NULL,
    FOREIGN KEY (sid) REFERENCES supplier(sid),
    FOREIGN KEY (pid) REFERENCES parts(pid)
);

INSERT INTO supplier(sid, sname, rating) VALUES('s01', 'alexa', 5);
INSERT INTO supplier(sid, sname, rating) VALUES('s02', 'siri', 4);
INSERT INTO supplier(sid, sname, rating) VALUES('s03', 'ferris', 3);

INSERT INTO parts(pid, pname, color) VALUES('p01', 'gloves', 'green');
INSERT INTO parts(pid, pname, color) VALUES('p02', 'paint', 'green');
INSERT INTO parts(pid, pname, color) VALUES('p03', 'sprinkler', 'blue');
INSERT INTO parts(pid, pname, color) VALUES('p04', 'scissors', 'red');
INSERT INTO parts(pid, pname, color) VALUES('p05', 'box', 'red');

INSERT INTO catalog(sid, pid, cost) VALUES('s01', 'p01', 50);
INSERT INTO catalog(sid, pid, cost) VALUES('s01', 'p02', 80);
INSERT INTO catalog(sid, pid, cost) VALUES('s01', 'p03', 20);
INSERT INTO catalog(sid, pid, cost) VALUES('s01', 'p04', 40);
INSERT INTO catalog(sid, pid, cost) VALUES('s01', 'p05', 60);
INSERT INTO catalog(sid, pid, cost) VALUES('s02', 'p01', 30);
INSERT INTO catalog(sid, pid, cost) VALUES('s02', 'p04', 50);
INSERT INTO catalog(sid, pid, cost) VALUES('s03', 'p03', 20);

--distinct supplier IDs and names of suppliers who supply more than one part 
SELECT DISTINCT  s.sid, s.sname FROM supplier s
WHERE (SELECT COUNT(*) FROM catalog c
WHERE  s.sid=c.sid AND c.pid IS NOT NULL)>1;

-- distinct suppliers who supply at least one red-colored part
SELECT DISTINCT  * FROM supplier s
WHERE (SELECT COUNT(*) FROM catalog c
JOIN parts p ON p.pid=c.pid
WHERE  s.sid=c.sid AND p.color='red')>0;

--suppliers who supply both green and red-colored parts
SELECT DISTINCT  s.sname FROM supplier s
WHERE (SELECT COUNT(*) FROM catalog c
JOIN parts p ON p.pid=c.pid
WHERE  s.sid=c.sid AND p.color='green')>0
AND (SELECT COUNT(*) FROM catalog c
JOIN parts p ON p.pid=c.pid
WHERE  s.sid=c.sid AND p.color='red')>0;

--suppliers who supply every part listed in the "parts" table
SELECT * FROM supplier s
WHERE NOT EXISTS (SELECT p.pid FROM parts p
WHERE NOT EXISTS (SELECT c.sid FROM catalog c
WHERE c.sid = s.sid AND c.pid = p.pid)
);

--who supply exactly two parts
SELECT  s.sid, s.sname FROM supplier s
WHERE (SELECT COUNT(*) FROM catalog c
WHERE  s.sid=c.sid AND c.pid IS NOT NULL)=2;

SELECT  s.sname FROM supplier s
WHERE (SELECT COUNT(*) FROM catalog c
WHERE  s.sid=c.sid AND c.pid IS NOT NULL)<5;

SELECT pname FROM parts 
WHERE pid IN (SELECT pid FROM parts
WHERE color = 'red');

--name of the supplier who offers part 'p02' at the lowest cost
SELECT s.sname FROM supplier s
JOIN catalog c ON s.sid=c.sid
WHERE c.pid='p02' AND
c.cost=(SELECT MIN(cost) FROM catalog
WHERE pid='p02');

--retrieves the part ID, supplier ID, supplier name, and cost for each part, where the supplier provides that part at the minimum cost. It orders the results by part ID (pid).
SELECT c.pid, s.sid, s.sname, c.cost
FROM catalog c
JOIN supplier s ON c.sid = s.sid
WHERE c.cost = (
    SELECT MIN(cost)
    FROM catalog
    WHERE pid = c.pid
)
ORDER BY c.pid;
