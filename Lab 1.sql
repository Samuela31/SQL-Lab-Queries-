CREATE TABLE stud (
    sid int NOT NULL,
    sname varchar(255) NOT NULL,
    city varchar(255) NOT NULL
);

CREATE TABLE hostel (
    hid int,
    room int NOT NULL,
    hname varchar(255) NOT NULL
);

INSERT INTO stud(sid, sname, city) VALUES(123456, 'sam', 'chennai');
INSERT INTO stud(sid, sname, city) VALUES(129856, 'dan', 'chennai');
INSERT INTO stud(sid, sname, city) VALUES(122356, 'ian', 'peelamedu');
INSERT INTO stud(sid, sname, city) VALUES(124696, 'ray', 'avadi');
INSERT INTO stud(sid, sname, city) VALUES(127866, 'kai', 'delhi');
SELECT * FROM stud;

INSERT INTO hostel(hid, room, hname) VALUES(123456, 226, 'amma');
INSERT INTO hostel(hid, room, hname) VALUES(129856, 236, 'palani');
INSERT INTO hostel(hid, room, hname) VALUES(122356, 216, 'amma');
INSERT INTO hostel(hid, room, hname) VALUES(124696, 246, 'palani');
INSERT INTO hostel(hid, room, hname) VALUES(127866, 227, 'amma');
SELECT * FROM hostel;

ALTER TABLE stud
ADD PRIMARY KEY (sid)
ADD CONSTRAINT CHK_his CHECK(sid>=100000 AND sid<=999999);

--hid is foreign key
ALTER TABLE hostel
ADD CONSTRAINT FK_hs FOREIGN KEY (hid) REFERENCES stud(sid);

ALTER TABLE stud
ADD cgpa float(2)
ADD CONSTRAINT CHK_cg CHECK(cgpa>=0.00 AND cgpa<=10.00);

ALTER TABLE hostel
ADD location varchar(100) DEFAULT 'CIT Campus';

ALTER TABLE stud
ADD gender varchar(1)
ADD CONSTRAINT CHK_gend CHECK(gender='M' OR gender='F');

INSERT INTO hostel( room, hname) VALUES( 227, 'amma');
SELECT * FROM hostel;

ALTER TABLE stud DROP CONSTRAINT CHK_his;
ALTER TABLE hostel DROP CONSTRAINT FK_hs;
UPDATE stud SET sid = sid + 1000000000;
ALTER TABLE stud ADD CONSTRAINT chk_mew CHECK(sid>=1000000000 AND sid<=9999999999);
UPDATE hostel SET hid = hid + 1000000000;
ALTER TABLE hostel ADD CONSTRAINT FK_hs FOREIGN KEY (hid) REFERENCES stud(sid);
