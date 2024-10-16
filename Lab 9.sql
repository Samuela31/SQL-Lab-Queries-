CREATE TABLE uber2(
usid VARCHAR(20) PRIMARY KEY,
uname VARCHAR(200) NOT NULL,
ustatus VARCHAR(200) CHECK(ustatus='unbanned' OR ustatus='banned' OR ustatus='new') NOT NULL,
trip VARCHAR(200) CHECK(trip='booked' OR trip='cancelled') NOT NULL,
tdate DATE NOT NULL
);

INSERT INTO uber2(usid,uname,ustatus,trip,tdate)
VALUES('u01','sam','unbanned','booked','25-DEC-23');
INSERT INTO uber2(usid,uname,ustatus,trip,tdate)
VALUES('u02','ara','new','cancelled','25-DEC-23');
INSERT INTO uber2(usid,uname,ustatus,trip,tdate)
VALUES('u03','kay','banned','booked','24-DEC-23');
INSERT INTO uber2(usid,uname,ustatus,trip,tdate)
VALUES('u04','ray','new','booked','23-NOV-23');
INSERT INTO uber2(usid,uname,ustatus,trip,tdate)
VALUES('u05','ren','banned','cancelled','23-NOV-23');
INSERT INTO uber2(usid,uname,ustatus,trip,tdate)
VALUES('u06','lua','unbanned','cancelled','25-DEC-23');

--Prints details of unbanned users.
CREATE OR REPLACE PROCEDURE ub AS
BEGIN
    FOR rec IN (SELECT usid, uname
                FROM uber2
                WHERE ustatus = 'unbanned')
    LOOP
          DBMS_OUTPUT.PUT_LINE('User ID: ' || rec.usid);
          DBMS_OUTPUT.PUT_LINE('User name: ' || rec.uname);
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
EXEC ub; 





--Prints details of banned users
CREATE OR REPLACE PROCEDURE b AS
BEGIN
    FOR rec IN (SELECT usid, uname
                FROM uber2
                WHERE ustatus = 'banned')
    LOOP
          DBMS_OUTPUT.PUT_LINE('User ID: ' || rec.usid);
          DBMS_OUTPUT.PUT_LINE('User name: ' || rec.uname);
    END LOOP;
END;
/

EXEC b; 





--Prints details of new users.
CREATE OR REPLACE PROCEDURE nu AS
BEGIN
    FOR rec IN (SELECT usid, uname
                FROM uber2
                WHERE ustatus = 'new')
    LOOP
          DBMS_OUTPUT.PUT_LINE('User ID: ' || rec.usid);
          DBMS_OUTPUT.PUT_LINE('User name: ' || rec.uname);
    END LOOP;
END;
/

EXEC nu; 





--Calculates the cancellation rate of unbanned users
CREATE OR REPLACE FUNCTION cru(d DATE)  
RETURN NUMBER IS  
   req NUMBER := 0;  
   canc NUMBER := 0;  
BEGIN  
   SELECT COUNT(*) INTO req  
   FROM uber2 
   WHERE trip='booked' AND tdate=d AND ustatus='unbanned';  

   SELECT COUNT(*) INTO canc  
   FROM uber2 
   WHERE trip='cancelled' AND tdate=d AND ustatus='unbanned';  

   RETURN CASE WHEN req = 0 THEN 0 ELSE canc/req END;  
END;  
/  

DECLARE  
   r NUMBER;  
BEGIN  
   r := cru('25-DEC-23');  
   DBMS_OUTPUT.PUT_LINE('Cancellation rate of unbanned users: Rs' || r);  
END;  
/  





--Calculates the cancellation rate of banned users
CREATE OR REPLACE FUNCTION crb(d DATE)  
RETURN NUMBER IS  
   req NUMBER := 0;  
   canc NUMBER := 0;  
BEGIN  
   SELECT COUNT(*) INTO req  
   FROM uber2 
   WHERE trip='booked' AND tdate=d AND ustatus='banned';  

   SELECT COUNT(*) INTO canc  
   FROM uber2 
   WHERE trip='cancelled' AND tdate=d AND ustatus='banned';  

   RETURN CASE WHEN req = 0 THEN 0 ELSE canc/req END;
END;  
/  

DECLARE  
   r NUMBER;  
BEGIN  
   r := crb('25-DEC-23');  
   DBMS_OUTPUT.PUT_LINE('Cancellation rate of banned users: Rs' || r);  
END;  
/  





--Calculates the total cancellation rate for all user statuses (unbanned, banned, new).
CREATE OR REPLACE PROCEDURE tcr(d DATE) AS
    ur NUMBER :=0;
    br NUMBER :=0;
    nr NUMBER :=0;
    rate NUMBER :=0;
    
    FUNCTION crn(d DATE)  RETURN number IS  
       req NUMBER := 0;  
       canc NUMBER := 0;  

    BEGIN  
       SELECT COUNT(*) INTO req  
       FROM uber2 
       WHERE trip='booked' AND tdate=d AND ustatus='new';  

       SELECT COUNT(*) INTO canc  
       FROM uber2 
       WHERE trip='cancelled' AND tdate=d AND ustatus='new';  

    RETURN CASE WHEN req = 0 THEN 0 ELSE canc/req END;
    END crn;  

BEGIN
    nr:=crn(d);
    br:=crb(d);
    ur:=cru(d);
    rate:=nr+br+ur;

   DBMS_OUTPUT.PUT_LINE('Total cancellation rate: Rs' || rate);  
END;
/

EXEC tcr('25-DEC-23'); 





--Calculates the total number of requests (booked trips) on Christmas
CREATE OR REPLACE PROCEDURE christmas_req AS
    chreq NUMBER :=0;
    
    FUNCTION chnr RETURN number IS  
       req NUMBER := 0;  

    BEGIN  
       SELECT COUNT(*) INTO req  
       FROM uber2 
       WHERE trip='booked' AND tdate='25-DEC-23';  

    RETURN req;  
    END chnr;  

BEGIN
    chreq:=chnr();

   DBMS_OUTPUT.PUT_LINE('Total requests on Christmas: Rs' || chreq);  
END;
/

EXEC christmas_req;
