CREATE DATABASE SupplierPartsDB;
USE SupplierPartsDB;

-- 2️⃣ Create Tables
CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
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

-- 3️⃣ Insert Data
INSERT INTO Supplier VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

INSERT INTO Parts VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

INSERT INTO Catalog VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10002, 20003, 30),
(10003, 20003, 30),
(10004, 20003, 40);

-- 4️⃣ Queries

-- Q3. Find the pnames of parts for which there is some supplier.
SELECT DISTINCT pname
FROM Parts p
WHERE p.pid IN (SELECT pid FROM Catalog);

-- Q4. Find the snames of suppliers who supply every part.
SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.pid NOT IN (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid
    )
);

-- Q5. Find the snames of suppliers who supply every red part.
SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.color = 'Red'
    AND p.pid NOT IN (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid
    )
);

-- Q6. Find the pnames of parts supplied by Acme Widget Suppliers and by no one else.
SELECT p.pname
FROM Parts p
WHERE p.pid IN (
    SELECT c.pid
    FROM Catalog c
    JOIN Supplier s ON c.sid = s.sid
    WHERE s.sname = 'Acme Widget'
)
AND p.pid NOT IN (
    SELECT c.pid
    FROM Catalog c
    JOIN Supplier s ON c.sid = s.sid
    WHERE s.sname <> 'Acme Widget'
);

-- Q7. Find the sids of suppliers who charge more for some part than the average cost of that part.
SELECT DISTINCT c1.sid
FROM Catalog c1
WHERE c1.cost > (
    SELECT AVG(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c1.pid
);

-- Q8. For each part, find the sname of the supplier who charges the most for that part.
SELECT p.pname, s.sname, c.cost
FROM Catalog c
JOIN Supplier s ON c.sid = s.sid
JOIN Parts p ON c.pid = p.pid
WHERE c.cost = (
    SELECT MAX(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c.pid
);

