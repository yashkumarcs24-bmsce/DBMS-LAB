Create database Supplier;
Use Supplier;

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(30),
    city VARCHAR(30)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(30),
    color VARCHAR(20)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost INT,
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Supplier VALUES
(1, 'Acme Widget Suppliers', 'London'),
(2, 'John Supplies', 'Delhi'),
(3, 'Global Parts', 'Tokyo'),
(4, 'Universal Suppliers', 'London');
Select * from Supplier;

INSERT INTO Parts VALUES
(101, 'Bolt', 'Red'),
(102, 'Nut', 'Blue'),
(103, 'Screw', 'Red'),
(104, 'Washer', 'Green'),
(105, 'Gear', 'Yellow');
Select * from Parts;

INSERT INTO Catalog VALUES
(1, 101, 50),
(1, 102, 70),
(1, 103, 80),
(1, 104, 65),
(1, 105, 95),
(2, 101, 55),
(2, 103, 85),
(3, 102, 60),
(3, 104, 75),
(4, 103, 90),
(4, 101, 52);
Select * from Catalog;

SELECT DISTINCT p.pname
FROM Parts p, Catalog c
WHERE p.pid = c.pid;

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (SELECT p.pid
    FROM Parts p
    WHERE p.pid NOT IN (SELECT c.pid FROM Catalog c WHERE c.sid = s.sid)
);

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.color = 'Red'
    AND p.pid NOT IN (SELECT c.pid FROM Catalog c WHERE c.sid = s.sid)
);

SELECT p.pname
FROM Parts p, Catalog c, Supplier s
WHERE p.pid = c.pid AND s.sid = c.sid AND s.sname = 'Acme Widget Suppliers'
AND p.pid NOT IN (
    SELECT c2.pid
    FROM Catalog c2, Supplier s2
    WHERE s2.sid = c2.sid AND s2.sname <> 'Acme Widget Suppliers'
);

SELECT DISTINCT c.sid
FROM Catalog c
JOIN (
    SELECT pid, AVG(cost) AS avgCost
    FROM Catalog
    GROUP BY pid
) AS avgTable
ON c.pid = avgTable.pid
WHERE c.cost > avgTable.avgCost;

SELECT p.pname, s.sname, c.cost
FROM Catalog c, Supplier s, Parts p
WHERE c.sid = s.sid AND p.pid = c.pid AND c.cost = (
    SELECT MAX(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c.pid
);