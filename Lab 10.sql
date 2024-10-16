CREATE TABLE employee(
eid VARCHAR(20) PRIMARY KEY,
ename VARCHAR(200) NOT NULL,
salary INT NOT NULL
);

INSERT INTO employee(eid,ename,salary)
VALUES('e01','max',6000);
INSERT INTO employee(eid,ename,salary)
VALUES('e02','milia',5000);
INSERT INTO employee(eid,ename,salary)
VALUES('e03','aria',4000);

SET SERVEROUTPUT ON;

--print all employee names
DECLARE
   CURSOR EmployeeCursor IS SELECT ename FROM employee;
BEGIN
   FOR rec IN EmployeeCursor
   LOOP
      DBMS_OUTPUT.PUT_LINE('Employee name: ' || rec.ename);
   END LOOP;
END;
/





  




CREATE TABLE orders(
oid VARCHAR(20) PRIMARY KEY,
odate DATE NOT NULL
);

INSERT INTO orders(oid,odate)
VALUES('o01','25-MAY-23');
INSERT INTO orders(oid,odate)
VALUES('o02','15-OCT-23');
INSERT INTO orders(oid,odate)
VALUES('o03','02-DEC-23');

--prints the data, then updates all order dates to the current date
DECLARE
   d DATE;
CURSOR OrderCursor IS SELECT * FROM orders;
BEGIN
   SELECT CURRENT_DATE INTO d FROM dual;

   FOR rec IN OrderCursor
   LOOP
      DBMS_OUTPUT.PUT_LINE('Order ID: ' || rec.oid);
      DBMS_OUTPUT.PUT_LINE('Order date: ' || rec.odate);
   END LOOP;

   UPDATE orders
   SET odate = d;

   DBMS_OUTPUT.PUT_LINE('Order dates updated successfully.');
END;
/

SELECT * FROM orders;










CREATE TABLE products(
pid VARCHAR(20) PRIMARY KEY,
q INT NOT NULL,
reorderlevel INT NOT NULL
);

INSERT INTO products(pid,q,reorderlevel)
VALUES('p01',10,11);
INSERT INTO products(pid,q,reorderlevel)
VALUES('p02',21,23);
INSERT INTO products(pid,q,reorderlevel)
VALUES('p03',7,10);
INSERT INTO products(pid,q,reorderlevel)
VALUES('p04',11,10);
INSERT INTO products(pid,q,reorderlevel)
VALUES('p05',1,7);

--used to display product details, followed by deleting products with quantities less than 10
DECLARE
CURSOR ProductCursor IS SELECT * FROM products; 
BEGIN
     FOR rec IN ProductCursor 
     LOOP
         DBMS_OUTPUT.PUT_LINE('Product ID: ' || rec.pid);
         DBMS_OUTPUT.PUT_LINE('Quantity: ' || rec.q);

     END LOOP; 

     DELETE FROM products WHERE q<10;
END;
/

SELECT * FROM products;









CREATE TABLE customers(
cid VARCHAR(20) NOT NULL,
cname VARCHAR(200) NOT NULL,
orders VARCHAR(20) NOT NULL,
ototal INT 
);

INSERT INTO customers(cid, cname, orders)
VALUES('c01','kim', 'pen');
INSERT INTO customers(cid, cname, orders)
VALUES('c01','kim', 'cart');
INSERT INTO customers(cid, cname, orders)
VALUES('c02','kay', 'pot');
INSERT INTO customers(cid, cname, orders)
VALUES('c03','jim','pot');

--updates the ototal field with the total number of orders for each customer
DECLARE
  CURSOR CustomerCursor IS SELECT * FROM customers;
BEGIN
  FOR rec IN CustomerCursor
  LOOP
    UPDATE customers
    SET ototal= (
      SELECT COUNT(*) FROM customers WHERE cid= rec.cid
    )
    WHERE cid = rec.cid;
  END LOOP;
END;
/

SELECT * FROM customers;









CREATE TABLE reorderItems(
pid VARCHAR(20),
q INT
);

--checks if a product's stock is below its reorder level and adds such products to the reorderItems table
DECLARE
CURSOR ReorderCursor IS SELECT * FROM products; 
BEGIN
     FOR rec IN ReorderCursor 
     LOOP
         IF(rec.reorderlevel>rec.q) THEN 
              INSERT INTO reorderItems(pid,q)
              VALUES(rec.pid,rec.q);
         END IF;
     END LOOP;
END;
/

SELECT * FROM reorderItems;








--compares each employee's salary to the average salary and prints the details of employees with higher or equal salaries
DECLARE
CURSOR SalaryCursor IS SELECT * FROM employee; 
t NUMBER;
BEGIN
     SELECT AVG(salary) INTO t FROM employee;

     FOR rec IN SalaryCursor 
     LOOP
         IF(rec.salary>=t) THEN 
                DBMS_OUTPUT.PUT_LINE('Employee name: ' || rec.ename);
                DBMS_OUTPUT.PUT_LINE('Salary: ' || rec.salary);
         END IF;
     END LOOP;
END;
/
