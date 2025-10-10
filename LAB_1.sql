create table person (
    driver_id varchar(10),
    name varchar(20),
    address varchar(30),
    primary key(driver_id)
);
create table car (
    reg_num varchar(10),
    model varchar(10),
    year int,
    primary key(reg_num)
);
create table accident (
    report_num int,
    accident_date date,
    location varchar(20),
    primary key(report_num)
);
create table owns (
    driver_id varchar(10),
    reg_num varchar(10),
    primary key(driver_id, reg_num),
    foreign key(driver_id) references person(driver_id),
    foreign key(reg_num) references car(reg_num)
);
create table participated (
    driver_id varchar(10),
    reg_num varchar(10),
    report_num int,
    damage_amount int,
    primary key(driver_id, reg_num, report_num),
    foreign key(driver_id) references person(driver_id),
    foreign key(reg_num) references car(reg_num),
    foreign key(report_num) references accident(report_num)
);

-- PERSON
insert into person values('A01','Richard','Srinivas Nagar');
insert into person values('A02','Pradeep','Rajajinagar');
insert into person values('A03','Smith','Ashoknagar');
insert into person values('A04','Venu','N.R.Colony');
insert into person values('A05','John','Hanumanth Nagar');
-- CAR
insert into car values('KA052250','Indica',1990);
insert into car values('KA031181','Lancer',1957);
insert into car values('KA095477','Toyota',1998);
insert into car values('KA053408','Honda',2008);
insert into car values('KA041702','Audi',2005);
-- ACCIDENT
insert into accident values(11,'2003-01-01','Mysore Road');
insert into accident values(12,'2004-02-02','Southend Circle');
insert into accident values(13,'2003-01-21','Bulltemple Road');
insert into accident values(14,'2008-02-17','Mysore Road');
insert into accident values(15,'2005-03-04','Kanakpura Road');
-- OWNS
insert into owns values('A01','KA052250');
insert into owns values('A02','KA053408');
insert into owns values('A04','KA031181');
insert into owns values('A03','KA095477');
insert into owns values('A05','KA041702');
-- PARTICIPATED
insert into participated values('A01','KA052250',11,10000);
insert into participated values('A02','KA053408',12,50000);
insert into participated values('A03','KA095477',13,25000);
insert into participated values('A04','KA031181',14,3000);
insert into participated values('A05','KA041702',15,5000);

-- Update damage amount
update participated 
set damage_amount = 25000 
where reg_num = 'KA053408' and report_num = 12;

-- Add a new accident
insert into accident values(16,'15-MAR-08','Domlur');

-- Display accident date and location
select accident_date, location 
from accident;

-- Display driver IDs with accident damage >= 25000
select driver_id
from participated
where damage_amount >= 25000;

-- Query 3
SELECT COUNT(DISTINCT P.report_num) AS CNT
FROM CAR C, PARTICIPATED P
WHERE P.reg_num = C.reg_num AND C.model = 'Lancer';

-- Query 4
SELECT COUNT(DISTINCT driver_id) AS CNT
FROM PARTICIPATED P, ACCIDENT A
WHERE O.reg_num = P.reg_num AND P.report_num = A.report_num AND YEAR(A.accident_date) = 2008;

-- Query 5
select count(distinct p.report_num) as CNT
from participated p, car c, accident a
where p.reg_num = c.reg_num and p.report_num = a.report_num and
c.model = 'Lancer' and year(a.accident_date) = 2008;
							
-- Query 6
SELECT * FROM PARTICIPATED 
ORDER BY DAMAGE_AMOUNT DESC;

-- Query 7
SELECT AVG(DAMAGE_AMOUNT)
FROM PARTICIPATED;

-- Query 8
DELETE FROM PARTICIPATED
WHERE damage_amount < (
    SELECT avg_damage
    FROM (
        SELECT AVG(damage_amount) AS avg_damage
        FROM PARTICIPATED
    ) AS temp
);
Select * from PARTICIPATED;

-- Query 9
SELECT NAME 
FROM PERSON A, PARTICIPATED B 
WHERE A.DRIVER_ID = B.DRIVER_ID AND DAMAGE_AMOUNT>
		(SELECT AVG(DAMAGE_AMOUNT) FROM PARTICIPATED);

-- Query 10
SELECT MAX(DAMAGE_AMOUNT)
FROM PARTICIPATED;

-- Query 11
select * from car order by year ASC;