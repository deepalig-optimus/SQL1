Use Production;

Create Table Employee(
	EmployeeId INT Primary Key,
	FirstName Varchar(50),
	LastName Varchar(50),
	DepartmentId Int,
	Salary Decimal(18,2),
	HireDate Date
	);
Go

Create Table Department(
	DepartmentId Int Primary Key,
	DepartmentName Varchar(100)
	);
Go

INSERT INTO Department (DepartmentID, DepartmentName)
VALUES 
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Marketing');
GO

-- Inserting Sample Data into Employee
INSERT INTO Employee (EmployeeID, FirstName, LastName, DepartmentID, Salary, HireDate)
VALUES 
(1, 'John', 'Doe', 1, 60000, '2015-02-10'),
(2, 'Jane', 'Smith', 2, 75000, '2017-06-15'),
(3, 'Jim', 'Brown', 3, 85000, '2018-08-20'),
(4, 'Jake', 'White', 2, 70000, '2016-03-12'),
(5, 'Jill', 'Green', 1, 65000, '2019-01-07'),
(6, 'Jack', 'Black', 4, 50000, '2020-11-30');
GO

Select * from Employee;
Select * from Department;

--Q1 Create an index on DepartmentID in the employee table
Create index idx_DepartmentId
on Employee(DepartmentId);

Select * from Employee
where DepartmentId=2;

--Q2 Drop the above create index
Drop index Employee.idx_DepartmentId; --tablename.indexname

--Q3 Create a View That shows a list of employees with their full names and department names
Create view vWEmployeeWithDepartment 
as
Select EmployeeId, FirstName+' '+LastName as FullName
from Employee e join
Department d on e.DepartmentID=d.DepartmentID;

Select * From vWEmployeeWithDepartment;


--Alter the Above view
Create OR Alter View vWEmployeeWithDepartment as
Select
	e.EmployeeId,
	e.FirstName+' '+e.LastName as FullName,
	d.DepartmentName,
	e.Salary
From 
	Employee e
Join
	Department d on e.DepartmentID=d.DepartmentID;
Go

Select * from vWEmployeeWithDepartment;


--Q Create a View to Show employees' names who earn more than $70,000, sorted by salary.
Create view HighEarningEmployees 
as
Select
	e.EmployeeId,
	e.FirstName+' '+e.LastName as FullName,
	e.Salary
From
	Employee e
Where
	e.Salary>70000
Go

Select * From HighEarningEmployees;


--Create Table with clustered index
Create Table ClusterIdx(
	ClusterId int primary key, --automatically creates a clustered
	ClusterDate Datetime,
	CustomerID Int
	);
Insert into ClusterIdx Values(1, '2025-02-14 09:00:00',30),
	 (2, '2025-02-15 14:30:00',34),   
	 (3, '2025-03-01 18:00:00',35);

Create Clustered index idx_clusterId on ClusterIdx(ClusterId);
-- This Gives an error as already a cluster index is present


--Creating a non-clustered index
Create Nonclustered Index idx_ClusterId1
on ClusterIdx(ClusterId);


Select ClusterDate From ClusterIdx
where ClusterId=3;

--Q1: Create a scalar function to calculate the annual salary of an employee.
Create Function CalculateAnnualSalary(@Salary Decimal(10,2))
Returns Decimal(10,2)
As
Begin 
	Return @Salary*12;
End;

Select EmployeeId,FirstName,LastName,dbo.CalculateAnnualSalary(Salary)
As AnnualSalary
From Employee;

--Function to return fullname
Create Function dbo.GetEmployeeFullName(@EmployeeId Int)
Returns VArchar(100)
