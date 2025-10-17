create database bankdatabase;
use bankdatabase;
CREATE TABLE branch(
    branch_name VARCHAR(30) PRIMARY KEY,
    branch_city VARCHAR(30),
    assets INT
);

CREATE TABLE bankaccount(
    accno INT PRIMARY KEY,
    branch_name VARCHAR(30),
    balance INT,
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE bankcustomer(
    customer_name VARCHAR(30) PRIMARY KEY,
    customer_street VARCHAR(30),
    customer_city VARCHAR(30)
);

CREATE TABLE depositor(
    customer_name VARCHAR(30),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES bankcustomer(customer_name),
    FOREIGN KEY (accno) REFERENCES bankaccount(accno)
);

CREATE TABLE loan(
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(30),
    amount INT,
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

INSERT INTO branch VALUES
('SBI_Chamrajpet','Bangalore',50000),
('SBI_ResidencyRoad','Bangalore',10000),
('SBI_ShivajiRoad','Bombay',20000),
('SBI_ParliamentRoad','Delhi',10000),
('SBI_Jantarmantar','Delhi',20000);
select * from branch;

INSERT INTO bankaccount VALUES
(1,'SBI_Chamrajpet',2000),
(2,'SBI_ResidencyRoad',5000),
(3,'SBI_ShivajiRoad',6000),
(4,'SBI_ParliamentRoad',9000),
(5,'SBI_Jantarmantar',8000),
(6,'SBI_ShivajiRoad',4000),
(8,'SBI_ResidencyRoad',4000),
(9,'SBI_ParliamentRoad',3000),
(10,'SBI_ResidencyRoad',5000),
(11,'SBI_Jantarmantar',2000);
select * from bankaccount;

INSERT INTO bankcustomer VALUES
('Avinash','Bull_Temple_Road','Bangalore'),
('Dinesh','Bannergatta_Road','Bangalore'),
('Mohan','NationalCollege_Road','Bangalore'),
('Nikil','Akbar_Road','Delhi'),
('Ravi','Prithviraj_Road','Delhi');
select * from bankcustomer;

INSERT INTO depositor VALUES
('Avinash',1),
('Dinesh',2),
('Nikil',4),
('Ravi',5),
('Avinash',8),
('Nikil',9),
('Dinesh',10),
('Nikil',11);
select * from depositor;

INSERT INTO loan VALUES
(1,'SBI_Chamrajpet',1000),
(2,'SBI_ResidencyRoad',2000),
(3,'SBI_ShivajiRoad',3000),
(4,'SBI_ParliamentRoad',4000),
(5,'SBI_Jantarmantar',5000);
select * from loan;

-- Query 3
SELECT branch_name, (assets / 100000.0) AS "assets in lakhs"
FROM branch;

-- Query 4
SELECT d.customer_name, b.branch_name
FROM depositor d
JOIN bankaccount a ON d.accno = a.accno
JOIN branch b ON a.branch_name = b.branch_name
GROUP BY d.customer_name, b.branch_name
HAVING COUNT(d.accno) >= 2;

-- Query 5
CREATE VIEW branch_total_loans AS
SELECT branch_name, SUM(amount) AS total_loan_amount
FROM loan
GROUP BY branch_name;
SELECT * FROM branch_total_loans;

-- Query 6
SELECT d.customer_name
FROM depositor d
JOIN bankaccount b ON d.accno = b.accno
JOIN branch br ON b.branch_name = br.branch_name
WHERE br.branch_city = 'Delhi'
GROUP BY d.customer_name
HAVING COUNT(DISTINCT b.branch_name) = (SELECT COUNT(*) FROM branch WHERE branch_city = 'Delhi');

-- Query 7
CREATE TABLE borrower (
    customer_name VARCHAR(30),
    loan_number INT,
    PRIMARY KEY (customer_name, loan_number),
    FOREIGN KEY (customer_name) REFERENCES bankcustomer(customer_name),
    FOREIGN KEY (loan_number) REFERENCES loan(loan_number)
);
INSERT INTO borrower VALUES
('Avinash', 1),
('Dinesh', 2),
('Ravi', 3),
('Mohan', 4),
('Nikil', 5);
Select * from borrower;
SELECT DISTINCT b.customer_name
FROM borrower b
LEFT JOIN depositor d ON b.customer_name = d.customer_name
WHERE d.customer_name IS NULL;

-- Query 8
SELECT DISTINCT d.customer_name
FROM depositor d
JOIN bankaccount b ON d.accno = b.accno
JOIN loan l ON b.branch_name = l.branch_name
WHERE (b.branch_name = 'SBI_Chamrajpet' OR b.branch_name = 'SBI_ResidencyRoad');

-- Query 9
SELECT branch_name
FROM branch
WHERE assets > ALL (
    SELECT assets
    FROM branch
    WHERE branch_city = 'Bangalore'
);

-- Query 10
DELETE FROM bankaccount
WHERE branch_name IN (
    SELECT branch_name
    FROM branch
    WHERE branch_city = 'Bombay'
);
SELECT * FROM bankaccount;

-- Query 11
UPDATE bankaccount
SET balance = balance * 1.05;
SET SQL_SAFE_UPDATES = 0;
select * from bankaccount;
DELETE FROM bankaccount
WHERE branch_name IN (SELECT branch_name FROM branch WHERE branch_city = 'Bombay');
select * from bankaccount;
