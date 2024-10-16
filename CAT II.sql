CREATE TABLE customers(
cid VARCHAR(50) PRIMARY KEY,
fname VARCHAR(50) NOT NULL,
lname VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL,
address VARCHAR(50) NOT NULL,
ph INT NOT NULL
);

CREATE TABLE orders(
oid VARCHAR(50) PRIMARY KEY,
cid VARCHAR(50) NOT NULL,
odate DATE NOT NULL,
tcost INT NOT NULL,
FOREIGN KEY (cid) REFERENCES customers(cid)
);

CREATE TABLE order_items(
iid VARCHAR(50) PRIMARY KEY,
oid VARCHAR(50) NOT NULL,
pid VARCHAR(50) NOT NULL,
q INT NOT NULL,
ucost INT NOT NULL,
FOREIGN KEY (oid) REFERENCES orders(oid)
);

CREATE TABLE products(
pid VARCHAR(50) PRIMARY KEY,
pname VARCHAR(50) NOT NULL,
catid VARCHAR(50) NOT NULL,
q INT NOT NULL,
cost INT NOT NULL
);

INSERT INTO customers(cid, fname, lname, email, address, ph)
VALUES('c01', 'sam', 'abi', 'sam@gm.com', 'chennai', 111111);

SET SERVEROUTPUT ON;

--automatically update the tcost in orders to reflect the new total cost
CREATE OR REPLACE TRIGGER updateorder
BEFORE INSERT OR UPDATE ON order_items
FOR EACH ROW
DECLARE 
       c NUMBER;
BEGIN
       c := :NEW.q * :NEW.ucost;

       UPDATE orders
       SET tcost = tcost + c
       WHERE oid = :NEW.oid;
END;
/

INSERT INTO orders(oid, cid, odate, tcost)
VALUES('o01','c01','25-JUN-23',0);

INSERT INTO order_items(iid, oid, pid, q, ucost)
VALUES('i01', 'o01', 'p01', 3, 120);

SELECT * FROM orders;

--Prevents the insertion or update of an order item if the quantity (q) exceeds 5 by raising an application error
CREATE OR REPLACE TRIGGER orderlimit
BEFORE INSERT OR UPDATE ON order_items
FOR EACH ROW
BEGIN
   IF :NEW.q > 5 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Maximum order quantity exceeded!');
   END IF;
END;
/

INSERT INTO order_items(iid, oid, pid, q, ucost)
VALUES('i02', 'o01', 'p02', 6, 10);

SELECT * FROM order_items;

INSERT INTO products(pid, pname, catid, q, cost)
VALUES('p01','pen', 'school', 10, 100);

--Checks whether the quantity being ordered exceeds the available stock.
--If not enough stock is available, it raises an error: "Stock not enough!".
--Otherwise, it updates the products table to reduce the quantity (q) of the product by the ordered amount.
CREATE OR REPLACE TRIGGER updateproductstock
BEFORE INSERT OR UPDATE ON order_items
FOR EACH ROW
DECLARE 
       c NUMBER;
       product_quantity NUMBER;
BEGIN
       c := :NEW.q;

   SELECT q INTO product_quantity
   FROM products
   WHERE pid = :NEW.pid;

   IF product_quantity - c < 0 THEN
       RAISE_APPLICATION_ERROR(-20001, 'Stock not enough!');
   ELSE 
       UPDATE products
       SET q= q - c
       WHERE pid = :NEW.pid;
   END IF;
END;
/

INSERT INTO order_items(iid, oid, pid, q, ucost)
VALUES('i03', 'o01', 'p01', 11, 100);

INSERT INTO order_items(iid, oid, pid, q, ucost)
VALUES('i03', 'o01', 'p01', 4, 100);

SELECT * FROM products;
SELECT * FROM order_items;
SELECT * FROM orders;

INSERT INTO products(pid, pname, catid, q, cost)
VALUES('p02','pencil', 'school', 12, 100);

--Iterates through all products and prints their names
DECLARE
   CURSOR ProductCursor IS SELECT pname FROM products;
BEGIN
   FOR rec IN ProductCursor 
   LOOP
      DBMS_OUTPUT.PUT_LINE('Product name: ' || rec.pname);
   END LOOP;
END;
/

INSERT INTO orders(oid, cid, odate, tcost)
VALUES('o02','c01','24-JUN-23',0);

INSERT INTO order_items(iid, oid, pid, q, ucost)
VALUES('i04', 'o02', 'p02', 3, 20);

INSERT INTO products(pid, pname, catid, q, cost)
VALUES('p03','pencil2', 'school', 0, 100);

--Sums the total cost of all orders and deletes any products that have a quantity (q) of less than 1
DECLARE
   CURSOR OrderCursor IS SELECT tcost FROM orders;
   tamt NUMBER :=0;
BEGIN
   FOR rec IN OrderCursor 
   LOOP
      tamt:= tamt+ rec.tcost;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Total amount: ' || tamt);

   DELETE FROM products
   WHERE pid IN (
      SELECT pid FROM products WHERE q < 1
   );

END;
/

SELECT * FROM products;
