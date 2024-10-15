CREATE TABLE uber1(
cid VARCHAR(10) PRIMARY KEY,
cname VARCHAR(225) NOT NULL,
area VARCHAR(225) NOT NULL,
city VARCHAR(225) NOT NULL,
pin INT NOT NULL,
tdist INT NOT NULL
);

INSERT INTO uber1(cid,cname,area,city,pin,tdist) 
VALUES('c01','sam','shanti nagar','chennai',62,200);
INSERT INTO uber1(cid,cname,area,city,pin,tdist) 
VALUES('c02','ally','gb residency','coimbatore',67,100);
INSERT INTO uber1(cid,cname,area,city,pin,tdist) 
VALUES('c03','ray','hopes','coimbatore',62,20);
INSERT INTO uber1(cid,cname,area,city,pin,tdist) 
VALUES('c04','lin','gb residency','coimbatore',67,10);






DROP PROCEDURE ccus;  

########but what if nothing matches city#########
--This procedure retrieves all customers whose city matches the input parameter c. For each matching customer, it displays the cid (Customer ID) and cname (Customer Name)
CREATE OR REPLACE PROCEDURE ccus(c VARCHAR) AS
BEGIN
    FOR rec IN (SELECT cid, cname
                FROM uber1
                WHERE city = c)
    LOOP
          DBMS_OUTPUT.PUT_LINE('Customer ID: ' || rec.cid);
          DBMS_OUTPUT.PUT_LINE('Customer name: ' || rec.cname);
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
EXEC ccus('coimbatore');  





--This procedure retrieves customers based on both the city and area. It will display the cid (Customer ID) and cname (Customer Name) for each match.
CREATE OR REPLACE PROCEDURE crcus(r VARCHAR,c VARCHAR) AS
BEGIN
    FOR rec IN (SELECT cid, cname
                FROM uber1
                WHERE city = c AND area=r)
    LOOP
          DBMS_OUTPUT.PUT_LINE('Customer ID: ' || rec.cid);
          DBMS_OUTPUT.PUT_LINE('Customer name: ' || rec.cname);
    END LOOP;
END;
/

EXEC crcus('gb residency','coimbatore'); 




--This procedure retrieves customers who have traveled a total distance (tdist) greater than or equal to 100. It displays the cid, cname, and tdist (total distance) for each qualifying customer.
CREATE OR REPLACE PROCEDURE dcus AS
BEGIN
    FOR rec IN (SELECT cid, cname, tdist
                FROM uber1
                WHERE tdist>=100)
    LOOP
          DBMS_OUTPUT.PUT_LINE('Customer ID: ' || rec.cid);
          DBMS_OUTPUT.PUT_LINE('Customer name: ' || rec.cname);
          DBMS_OUTPUT.PUT_LINE('Distance: ' || rec.tdist);
    END LOOP;
END;
/

EXEC dcus; 





DROP PROCEDURE fcus;

--This procedure calculates and prints the fare for each customer. The fare is calculated as tdist * 12 (where tdist is the total distance the customer has traveled). It displays the cid, cname, and the calculated fare for each customer.
CREATE OR REPLACE PROCEDURE fcus AS
BEGIN
    FOR rec IN (SELECT cid,cname,tdist
                FROM uber1)
    LOOP
          DBMS_OUTPUT.PUT_LINE('Customer ID: ' || rec.cid);
          DBMS_OUTPUT.PUT_LINE('Customer name: ' || rec.cname);
          DBMS_OUTPUT.PUT_LINE('Fare: ' || rec.tdist*12);
    END LOOP;
END;
/

EXEC fcus; 




--This procedure calculates and prints the fare for customers who have traveled a distance of 100 or more units. The fare is calculated as tdist * 10. It displays the cid, cname, and the calculated fare for each qualifying customer.
CREATE OR REPLACE PROCEDURE pcus AS
BEGIN
    FOR rec IN (SELECT cid,cname,tdist
                FROM uber1 WHERE tdist>=100)
    LOOP
          DBMS_OUTPUT.PUT_LINE('Customer ID: ' || rec.cid);
          DBMS_OUTPUT.PUT_LINE('Customer name: ' || rec.cname);
          DBMS_OUTPUT.PUT_LINE('Fare: ' || rec.tdist*10);
    END LOOP;
END;
/

EXEC pcus; 
