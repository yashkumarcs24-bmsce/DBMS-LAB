CREATE DATABASE COMPANY;
USE COMPANY;

CREATE TABLE DEPT (
    DEPTNO INT PRIMARY KEY,
    DNAME VARCHAR(50),
    DLOC VARCHAR(50)
);
CREATE TABLE EMPLOYEE (
    EMPNO INT PRIMARY KEY,
    ENAME VARCHAR(50),
    MGR_NO INT,
    HIREDATE DATE,
    SAL DECIMAL(10,2),
    DEPTNO INT,
    FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO)
);
CREATE TABLE PROJECT (
    PNO INT PRIMARY KEY,
    PNAME VARCHAR(50),
    PLOC VARCHAR(50)
);
CREATE TABLE ASSIGNED_TO (
    EMPNO INT,
    PNO INT,
    JOB_ROLE VARCHAR(50),
    PRIMARY KEY (EMPNO, PNO),
    FOREIGN KEY (EMPNO) REFERENCES EMPLOYEE(EMPNO),
    FOREIGN KEY (PNO) REFERENCES PROJECT(PNO)
);
CREATE TABLE INCENTIVES (
    EMPNO INT,
    INCENTIVE_DATE DATE,
    INCENTIVE_AMOUNT DECIMAL(10,2),
    PRIMARY KEY (EMPNO, INCENTIVE_DATE),
    FOREIGN KEY (EMPNO) REFERENCES EMPLOYEE(EMPNO)
);

INSERT INTO DEPT VALUES
(10, 'HR', 'Bengaluru'),
(20, 'Finance', 'Hyderabad'),
(30, 'IT', 'Mysuru'),
(40, 'Sales', 'Chennai'),
(50, 'Admin', 'Pune');
SELECT * FROM Dept;

INSERT INTO EMPLOYEE VALUES
(201, 'Asha', 301, '2019-08-15', 62000, 10),
(202, 'Rahul', 302, '2020-02-10', 55000, 20),
(203, 'Priya', 303, '2021-05-05', 58000, 30),
(204, 'Nikhil', 304, '2021-09-18', 60000, 40),
(205, 'Sneha', 305, '2022-03-12', 65000, 50),
(206, 'Manoj', 306, '2023-07-01', 70000, 10);
SELECT * FROM EMPLOYEE;

INSERT INTO PROJECT VALUES
(1001, 'Payroll System', 'Bengaluru'),
(1002, 'Billing App', 'Hyderabad'),
(1003, 'Website Revamp', 'Mysuru'),
(1004, 'CRM Portal', 'Chennai'),
(1005, 'ERP Suite', 'Pune');
SELECT * FROM PROJECT;

INSERT INTO ASSIGNED_TO VALUES
(201, 1001, 'Manager'),
(202, 1002, 'Developer'),
(203, 1003, 'Tester'),
(204, 1004, 'Analyst'),
(205, 1003, 'Developer'),
(206, 1005, 'Admin');
SELECT * FROM ASSIGNED_TO;

INSERT INTO INCENTIVES VALUES
(201, '2024-02-10', 1500),
(202, '2024-02-27', 2000),
(203, '2024-03-12', 3000),
(204, '2024-03-24', 3500),
(205, '2024-04-05', 2500);
SELECT * FROM  INCENTIVES;

SELECT DISTINCT A.EMPNO
FROM ASSIGNED_TO A, PROJECT P
WHERE A.PNO = P.PNO AND P.PLOC IN ('Bengaluru', 'Hyderabad', 'Mysuru');

SELECT EMPNO
FROM EMPLOYEE
WHERE EMPNO NOT IN (SELECT EMPNO FROM INCENTIVES);

SELECT E.ENAME, E.EMPNO, D.DNAME, A.JOB_ROLE, D.DLOC AS DEPT_LOCATION, P.PLOC AS PROJECT_LOCATION
FROM EMPLOYEE E, DEPT D, ASSIGNED_TO A, PROJECT P
WHERE E.DEPTNO = D.DEPTNO AND E.EMPNO = A.EMPNO AND A.PNO = P.PNO AND D.DLOC = P.PLOC;

Select e.Ename, d.DName, d.DLoc as Dept_Location
From Employee e, Dept d
Where e.deptno=d.deptno;

SELECT E.EName, E.EmpNo
FROM Employee E, Assigned_to a
WHERE A.EmpNO=e.Empno AND A.PNo IS NULL;

Select D.DName, AVG(E.Sal) As Average_Salary, MAX(E.Sal) As Maximum_Salary
From Dept D, Employee E
Where D.DeptNo=E.DeptNo
Group by DName;

Select E.EName, SUM(I.Incentive_amount) As Total_Incentives_Earned
From Employee E, Incentives I
Where E.EmpNo=I.EmpNo
Group By E.Ename
Order by Total_Incentives_Earned;

Select E.EName, E.EmpNo, A.Job_Role
From Employee E, Assigned_to A, Project P 
Where E.EmpNo=A.EmpNo AND A.PNo=P.PNo AND P.PName="Website Revamp";

Select D.DName, D.DeptNo
From Dept D, Employee E
Where E.DeptNo=D.DeptNo AND E.EmpNo IS NULL;

Update Employee
Set Mgr_No=204
Where EmpNo in (201,202,203);
Update Employee
Set Mgr_No=206
Where EmpNo in (204,205);

Select M.EName As Manager_Name, Count(E.EmpNo) As Direct_Report_Count
From Employee E, Employee M
Where E.Mgr_No=M.EmpNo
Group By M.EName
Order By Direct_Report_Count;

Select E.Ename, Count(A.Pno) As Project_Count
From Employee E, Assigned_to A 
Where E.EmpNo=A.EmpNo
Group By E.Ename
Having Count(A.Pno)>1;
