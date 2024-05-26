create table stud(
    regno int UNIQUE,
     name varchar(50) NOT NULL,
   dept varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    cgpa float,
   pin int,
    CONSTRAINT CHK_stud CHECK (regno>=700000 AND regno<800000 AND cgpa>=0.00 AND cgpa<=10.00 AND pin>600000 AND pin<700000 and name!='' and dept!='' and city!='')
   );

insert into stud(regno, name, dept, city, cgpa, pin)
values (717078, 'sam', 'cs', 'cbe', 9.24, 620000);

select * from stud;
