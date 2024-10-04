CREATE TABLE sailor (
    sid varchar(255) PRIMARY KEY,
    sname varchar(255) NOT NULL,
    rating int,
    age int NOT NULL
);


CREATE TABLE boat(
    bid varchar(255) PRIMARY KEY,
    bname varchar(255) NOT NULL,
    color varchar(255) NOT NULL
);

CREATE TABLE reserves(
    sid varchar(255),
    bid varchar(255),
    dat DATE NOT NULL,
    FOREIGN KEY (sid) REFERENCES sailor(sid),
    FOREIGN KEY (bid) REFERENCES boat(bid)
);

INSERT INTO sailor(sid, sname, rating, age) VALUES('s01', 'shelly mary', 5, 24);
INSERT INTO sailor(sid, sname, rating, age) VALUES('s02', 'ruby rain', 4, 26);
INSERT INTO sailor(sid, sname, rating, age) VALUES('s03', 'jack sparrow', 5, 29);
INSERT INTO sailor(sid, sname, rating, age) VALUES('s04', 'jelavic black', 3, 21);
INSERT INTO sailor(sid, sname, rating, age) VALUES('s05', 'rolly', 3, 23);

INSERT INTO boat(bid, bname, color) VALUES('b01', 'black pearl', 'black');
INSERT INTO boat(bid, bname, color) VALUES('b02', 'bloody mary', 'red');
INSERT INTO boat(bid, bname, color) VALUES('b03', 'night sky', 'black');
INSERT INTO boat(bid, bname, color) VALUES('b04', 'graciosa', 'green');
INSERT INTO boat(bid, bname, color) VALUES('b05', 'emerald rich', 'green');

INSERT INTO reserves(sid, bid, dat) VALUES('s01', 'b02', '15-AUG-22');
INSERT INTO reserves(sid, bid, dat) VALUES('s01', 'b05', '16-AUG-22');
INSERT INTO reserves(sid, bid, dat) VALUES('s02', 'b03', '15-AUG-20');
INSERT INTO reserves(sid, bid, dat) VALUES('s03', 'b01', '15-MAR-22');
INSERT INTO reserves(sid, bid, dat) VALUES('s03', 'b03', '16-AUG-22');
INSERT INTO reserves(sid, bid, dat) VALUES('s04', 'b05', '23-NOV-21');

--This query finds the name(s) of the sailor(s) who have the highest rating. 
SELECT sname FROM sailor WHERE rating=(SELECT MAX(rating) FROM sailor);

SELECT sname FROM sailor WHERE age=(SELECT MIN(age) FROM sailor);

--names of boats that have been reserved, ordered by the reservation date.
SELECT b.bname FROM boat b
JOIN reserves r ON b.bid=r.bid
ORDER BY r.dat;

--the most recent reservations appear first.
SELECT * FROM reserves ORDER BY dat DESC;

--names start with j
SELECT sname FROM sailor WHERE sname LIKE 'j%';

--second-youngest sailor by ordering the sailors by age and skipping the first row, then fetching only the next (second) row.
SELECT sname FROM sailor ORDER BY age 
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;

SELECT b.bid,b.bname FROM boat b
JOIN reserves r ON b.bid=r.bid
WHERE r.dat='15-AUG-22' OR r.dat='16-AUG-22';

SELECT s.sid,s.sname FROM sailor s
JOIN reserves r ON s.sid=r.sid
WHERE r.bid='b02' AND r.dat='15-AUG-22';

-- list of sailor names and the corresponding boats they have reserved
SELECT sailor.sname, boat.bname FROM sailor
JOIN reserves ON sailor.sid = reserves.sid
JOIN boat ON reserves.bid = boat.bid;

--it uses a left join with the "reserves" table to find the combinations of sailors and boats where there is no reservation 
SELECT s.sid, s.sname, b.bid
FROM sailor s CROSS JOIN boat b
LEFT JOIN reserves r ON r.sid = s.sid AND r.bid = b.bid
WHERE r.sid IS NULL OR r.bid IS NULL;

--This query retrieves a list of distinct sailor names who have made a reservation. It joins the "sailor" and "reserves" tables on the sailor ID (sid), ensuring that only sailors who have made reservations are included.
SELECT DISTINCT s.sname FROM sailor s
JOIN reserves r ON s.sid=r.sid
WHERE s.sid=r.sid;

--distinct colors of boats reserved by the sailor named 'Jack Sparrow'
SELECT DISTINCT b.color FROM boat b 
JOIN reserves r ON b.bid = r.bid 
JOIN sailor s ON s.sid = r.sid 
WHERE s.sname = 'jack sparrow';

--IDs of sailors who have reserved a green boat but have not reserved a red boat
--JOIN is same as INNER JOIN
SELECT DISTINCT r.sid FROM reserves r
INNER JOIN boat b ON r.bid = b.bid
WHERE b.color = 'green'
AND r.sid NOT IN (
    SELECT r.sid
    FROM reserves r
    INNER JOIN boat b ON r.bid = b.bid
    WHERE b.color = 'red'
);
