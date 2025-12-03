    -- ============================================
-- ANSI SQL COMMANDS DEMONSTRATION
-- ============================================

-- ============================================
-- DDL (Data Definition Language) Commands
-- ============================================

-- Connect to the database first on the teminal 
-- psql -U username -d postgres
psql -U aliayman -d postgres

-- terminate the session for a spesificn db
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'companydb'
  AND pid <> pg_backend_pid();


-- CREATE: Create a new database and tables
CREATE DATABASE CompanyDB;

-- Switch to the database (syntax varies by DBMS)
USE CompanyDB;       -- for mac    >>>  \c CompanyDB;


-- \l → list all databases.
-- \dt → list all tables in the current database.

-- CREATE: Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    HireDate DATE
);

-- CREATE: Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

-- CREATE: Create Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    Budget DECIMAL(12, 2),
    StartDate DATE,
    EndDate DATE
);

-- ALTER: Add a new column to Employees table
ALTER TABLE Employees
ADD PhoneNumber VARCHAR(15);

-- -- ALTER: Modify column data type
-- ALTER TABLE Employees
-- ALTER COLUMN Salary DECIMAL(12, 2);

-- ALTER: Add foreign key constraint
ALTER TABLE Employees
ADD CONSTRAINT FK_Department
FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);

-- TRUNCATE: Remove all data from a table (keeping structure)
CREATE TABLE TempData (
    ID INT,
    Value VARCHAR(50)
);

TRUNCATE TABLE TempData;

-- DROP: Remove the temporary table
DROP TABLE TempData;


-- ============================================
-- DML (Data Manipulation Language) Commands
-- ============================================

-- INSERT: Add data to Departments
INSERT INTO Departments (DepartmentID, DepartmentName, Location)
VALUES 
    (1, 'Human Resources', 'New York'),
    (2, 'Engineering', 'San Francisco'),
    (3, 'Marketing', 'Chicago'),
    (4, 'Sales', 'Boston');

-- INSERT: Add data to Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, DepartmentID, Salary, HireDate, PhoneNumber)
VALUES 
    (101, 'John', 'Doe', 'john.doe@company.com', 2, 85000.00, '2020-03-15', '555-0101'),
    (102, 'Jane', 'Smith', 'jane.smith@company.com', 1, 65000.00, '2019-07-22', '555-0102'),
    (103, 'Mike', 'Johnson', 'mike.johnson@company.com', 2, 92000.00, '2018-11-30', '555-0103'),
    (104, 'Sarah', 'Williams', 'sarah.williams@company.com', 3, 71000.00, '2021-01-10', '555-0104'),
    (105, 'Tom', 'Brown', 'tom.brown@company.com', 4, 78000.00, '2020-09-05', '555-0105');

-- INSERT: Add data to Projects
INSERT INTO Projects (ProjectID, ProjectName, Budget, StartDate, EndDate)
VALUES 
    (1, 'Website Redesign', 150000.00, '2024-01-01', '2024-06-30'),
    (2, 'Mobile App Development', 250000.00, '2024-02-15', '2024-12-31'),
    (3, 'Marketing Campaign', 80000.00, '2024-03-01', '2024-05-31');

-- UPDATE: Modify existing data
UPDATE Employees
SET Salary = 95000.00
WHERE EmployeeID = 103;

-- UPDATE: Give raises to Engineering department
UPDATE Employees
SET Salary = Salary * 1.10
WHERE DepartmentID = 2;

-- UPDATE: Update multiple columns
UPDATE Employees
SET Email = 'j.doe@company.com', PhoneNumber = '555-9999'
WHERE EmployeeID = 101;

-- DELETE: Remove specific records
DELETE FROM Employees
WHERE EmployeeID = 105;

-- DELETE: Remove records based on condition
DELETE FROM Projects
WHERE EndDate < '2024-01-01';


-- ============================================
-- DCL (Data Control Language) Commands
-- ============================================

-- GRANT: Give permissions to users
GRANT SELECT, INSERT ON Employees TO 'hr_manager';

GRANT SELECT ON Departments TO 'all_employees';

GRANT ALL PRIVILEGES ON Projects TO 'project_admin';

-- REVOKE: Remove permissions from users
REVOKE INSERT ON Employees FROM 'hr_manager';

REVOKE SELECT ON Departments FROM 'all_employees';


-- ============================================
-- TCL (Transaction Control Language) Commands
-- ============================================

-- BEGIN TRANSACTION (implicit in most systems)
BEGIN TRANSACTION;

-- Insert new employee
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, DepartmentID, Salary, HireDate)
VALUES (106, 'Lisa', 'Anderson', 'lisa.anderson@company.com', 3, 69000.00, '2024-01-15');

-- SAVEPOINT: Create a savepoint
SAVEPOINT BeforeUpdate;

-- Update salary
UPDATE Employees
SET Salary = 72000.00
WHERE EmployeeID = 106;

-- ROLLBACK: Rollback to savepoint (undo the update)
ROLLBACK TO BeforeUpdate;

-- COMMIT: Save all changes
COMMIT;

-- Example of full ROLLBACK
BEGIN TRANSACTION;

DELETE FROM Employees WHERE DepartmentID = 4;

-- ROLLBACK: Undo all changes in transaction
ROLLBACK;


-- -- ============================================
-- -- DQL (Data Query Language) Commands
-- -- ============================================

-- -- SELECT: Basic query
-- SELECT * FROM Employees;

-- -- SELECT: Specific columns
-- SELECT FirstName, LastName, Salary FROM Employees;

-- -- SELECT: With WHERE clause
-- SELECT * FROM Employees
-- WHERE Salary > 70000;

-- -- SELECT: With JOIN
-- SELECT 
--     e.EmployeeID,
--     e.FirstName,
--     e.LastName,
--     d.DepartmentName,
--     e.Salary
-- FROM Employees e
-- INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- -- SELECT: With aggregate functions
-- SELECT 
--     DepartmentID,
--     COUNT(*) AS EmployeeCount,
--     AVG(Salary) AS AverageSalary,
--     MAX(Salary) AS MaxSalary,
--     MIN(Salary) AS MinSalary
-- FROM Employees
-- GROUP BY DepartmentID;

-- -- SELECT: With ORDER BY
-- SELECT FirstName, LastName, Salary
-- FROM Employees
-- ORDER BY Salary DESC;

-- -- SELECT: With HAVING clause
-- SELECT DepartmentID, AVG(Salary) AS AvgSalary
-- FROM Employees
-- GROUP BY DepartmentID
-- HAVING AVG(Salary) > 75000;

-- -- SELECT: Subquery
-- SELECT FirstName, LastName, Salary
-- FROM Employees
-- WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- -- SELECT: DISTINCT values
-- SELECT DISTINCT DepartmentID FROM Employees;

-- -- SELECT: With LIKE pattern matching
-- SELECT * FROM Employees
-- WHERE Email LIKE '%@company.com';


-- -- ============================================
-- -- SUMMARY OF ALL COMMANDS DEMONSTRATED
-- -- ============================================

-- /*
-- DDL (Data Definition Language):
--   ✓ CREATE - Created database, tables
--   ✓ DROP - Dropped temporary table
--   ✓ ALTER - Added columns, modified constraints
--   ✓ TRUNCATE - Cleared table data

-- DML (Data Manipulation Language):
--   ✓ INSERT - Added records to tables
--   ✓ UPDATE - Modified existing records
--   ✓ DELETE - Removed records

-- DCL (Data Control Language):
--   ✓ GRANT - Gave permissions to users
--   ✓ REVOKE - Removed permissions

-- TCL (Transaction Control Language):
--   ✓ COMMIT - Saved transactions
--   ✓ ROLLBACK - Undid transactions
--   ✓ SAVEPOINT - Created transaction savepoints

-- DQL (Data Query Language):
--   ✓ SELECT - Retrieved data with various clauses
-- */