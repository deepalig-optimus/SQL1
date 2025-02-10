Create Database CustomerEmployeeDatabase;
USE CustomerEmployeeDatabase;

Create table Customers(
	CustomerId INT PRIMARY KEY,
	CustomerName VARCHAR(30),
	City VARCHAR(60)
	);

Insert Into Customers
Values
(1,'John Doe','New York'),
(2,'Jane Smith','London'),
(3,'David Lee','Paris');

Select * From Customers;



Create Table Orders(
		OrderId int PRIMARY KEY,
		CustomerId int FOREIGN KEY REFERENCES Customers(CustomerId),
		OrderDate date,
		TotalAmount float);


Insert INTO Orders
VALUES
(101,1,'2023-10-26','100.00'),
(102,1,'2023-10-27','200.00'),
(103,1,'2023-10-28','150.00'),
(104,1,'2023-10-29','50.00');

update  Orders
set CustomerId=1 where TotalAmount='200.00';


update  Orders
set CustomerId=2 where TotalAmount='150.00';

update  Orders
set CustomerId=3 where TotalAmount='50.00';


Select * From Orders;


Create table Products(
		ProductId int Primary key,
		ProductName Varchar(20),
		Price Float);

Insert Into Products 
Values
(1,'Laptop','1000.00'),
(2,'Mouse','25.00'),
(3,'Keyboard','75.00');


/*Create Table OrderItems(
			OrderItemID int primary key,
			OrderId int Foreign key references Orders(OrderId),
		ProductId int Foreign key references Products(ProductId),
			Quantity int);*/

Create Table OrderItems(
			OrderItemId int primary key,
			OrderId int not null,
			ProductId int,
			Quantity int,
			Foreign key(OrderID) References Orders(OrderID),
			Foreign key(ProductId) References Products(ProductId)
			);

Insert Into OrderItems
Values
(1,101,1,1),
(2,101,2,2),
(3,102,1,1),
(4,102,3,1),
(5,103,2,3),
(6,104,3,2);


Select * From OrderItems;


Create Table Employees(
EmployeeId int Primary key,
EmployeeName Varchar(30),
DepartmentId int Foreign key
references
Departments(DepartmentId)
);



Insert into Employees
Values
(1,'Alice',1),
(2,'Bob',2),
(3,'Charlie',1),
(4,'David',3);


Select  * from Employees;



Create Table Departments (
DepartmentId int primary key,
DepartmentName varchar(30));


Insert Into Departments
Values
(1,'Sales'),
(2,'Marketing'),
(3,'IT');

Select * from Departments;

/*Alter table Employees
add constraint fk_DepartmentId Foreign key
(DepartmentId)
references Departments(DepartmentId)
;*/



--1 List all orders with the customer's name and city
Select CustomerName as name ,City ,OrderId
from Customers as c
left join 
Orders as o 
on c.CustomerId=o.CustomerId;


--2 Find the total amount spent by each customer
Select CustomerId,sum(TotalAmount) as Amount
from Orders
Group by CustomerID;


--3 List Customers who have placed more than two orders
Select CustomerId as CustId, count(CustomerId) as TotalOrder
from Orders
Group by CustomerId having Count(CustomerId)>2;

--4-List all products ordered by John Doe
Select -- ,
distinct(p.ProductName),c.CustomerName as Name
from Customers c
inner join 
Orders o 
on o.CustomerId=c.CustomerId 
inner join OrderItems i on
o.OrderId=i.OrderId
inner join 
Products p on p.ProductId=i.ProductId
where CustomerName='John Doe';


--5 Find the total quantity of each product
Select sum(Quantity) as TotalQuantity,ProductName
from Products p
inner join OrderItems o
on p.ProductId=o.ProductId
group by ProductName;



--6 List the order Id, customer name,product name and
--quantity for all orders.
Select o.OrderId,c.CustomerName,p.ProductName,sum(i.Quantity)
as TotalQuantity
from Orders o
inner join Customers c 
on o.CustomerId=c.CustomerId
inner join OrderItems i
on o.OrderId=i.Orderid
inner join Products p
on i.ProductId=p.ProductId
group by o.orderId,c.CustomerName ,p.ProductName;


--7. Explain the purpose of the FOREIGN KEY constraint in
--the Orders table. What happens if you try to insert an
--order with a CustomerID that doesn't exist in the 
--Customers table?

-- 8. Write a query to find all orders where the 
--customer's city is 'New York'.

Select 
distinct(p.ProductName),c.CustomerName as Name, c.City
from Customers c
inner join 
Orders o 
on o.CustomerId=c.CustomerId 
inner join OrderItems i on
o.OrderId=i.OrderId
inner join 
Products p on p.ProductId=i.ProductId
where City='New York';


--9. How will you get current date and time.
select getdate() AT TIME ZONE 'UTC' at time zone 'India Standard Time';


--10. Extract the year, month, and day from the
---OrderDate column in the Orders table.
Select 
	Year(OrderDate) as OrderYear,
	Month(OrderDate) as OrderMonth,
	Day(OrderDate) as OrderDay
From Orders;


--11. Use the SQL Server Fn to combine the CustomerName 
--and City columns into a single column named 
--CustomerLocation.
Select CustomerName + City as CustomerLocation from Customers;
Select concat(CustomerName,City) As CustomerLoaction from Customers;

--12. Calculate the total amount of all orders.
Select sum(TotalAmount) as Total from Orders;

--13. Calculate Average order amount.
Select avg(TotalAmount) as AvgAmount from Orders;

--14. What are the total number of customers that have 
--purchased keyboard.
Select Count(c.CustomerID) as TotalCustomers from
Customers c inner join 
Orders O on o.CustomerId=c.CustomerId
inner join 
OrderItems OI on OI.OrderId=o.OrderId
inner join Products p on p.ProductId=OI.ProductId 
where p.ProductName='keyboard';

--15. Write a query that lists the customer's name,
--order ID, order date, and the names of all the products
--included in each order.
Select c.CustomerName,o.OrderID,o.OrderDate,p.ProductName
from Customers c inner join
Orders o on
c.CustomerID=o.CustomerID
inner join OrderItems oi
on o.OrderId=oi.OrderId
inner join Products p
on oi.ProductId=p.ProductId
order by c.CustomerName,o.OrderId,o.OrderDate,p.ProductName;

--16. Write a query that lists the name of each customer and 
--their total spending across all orders. Include customers who 
--haven't placed any orders.

Select c.CustomerName ,sum(o.TotalAmount) as TotalSpending
from Customers c 
Left join Orders o
on c.CustomerId = o.CustomerId
group by c.CustomerName;

--17. Write a query that lists the names of all products that 
--have never been ordered.
Select p.ProductName,p.ProductId
from Products p
left join
OrderItems oi on p.ProductId=oi.ProductId
Where oi.ProductId is NULL;

--18. Write a query to list each employee's name along with the 
--name of the department they work in.
Select e.EmployeeName,d.DepartmentName
from Employees e 
left join Departments d 
on e.DepartmentID=d.DepartmentId
group by d.DepartmentName,e.EmployeeName;

--19. You want to report on all orders, but if the TotalAmount is 
--NULL (for some reason), display it as 0.00. Write a query to 
--achieve this.

Select distinct o.OrderId,coalesce(o.TotalAmount,0) as TotalAmount from
Orders o
Left join OrderItems oi
on o.OrderId=oi.OrderId
order by o.OrderId;

--20. Create a query that displays the customer's full name. If
--the customer has a MiddleName (which you'll need to add to the 
--Customers table), include it in the full name. If MiddleName is 
--NULL, just display the FirstName and LastName. (Add MiddleName
--with ALTER TABLE Customers ADD MiddleName VARCHAR(255);).

Alter table Customers add MiddleName Varchar(255);
Alter table Customers add constraint
DF_Customers_MiddleName default 'N/A' for MiddleName;

Update Customers
set MiddleName='kumar'
Where CustomerName='John Doe';

Update Customers
set MiddleName='Mohan'
Where CustomerName='David Lee';

Select * from Customers;

Select CustomerName+' '+MiddleName as FullName from Customers;
--Select Substring(CustomerName,1,3) As FirstName from Customers;
SELECT 
    --LEFT(CustomerName, CHARINDEX(' ', CustomerName) - 1) AS FirstName,
    --RIGHT(CustomerName, LEN(CustomerName) - CHARINDEX(' ', CustomerName)) AS LastName,
    COALESCE(
        CONCAT(
            LEFT(CustomerName, CHARINDEX(' ', CustomerName) - 1), ' ', 
            MiddleName, ' ', 
            RIGHT(CustomerName, LEN(CustomerName) - CHARINDEX(' ', CustomerName))
        ),
        CONCAT(
            LEFT(CustomerName, CHARINDEX(' ', CustomerName) - 1), ' ', 
            RIGHT(CustomerName, LEN(CustomerName) - CHARINDEX(' ', CustomerName))
        )
    ) AS FullName
FROM Customers;

--21. List the order ID, product name, and the total value of
--each order item (Quantity * Price). Handle cases where either
--Quantity or Price is NULL by displaying 0 for the value in such
--cases.
Select o.OrderId,p.ProductName ,SUM(COALESCE(oi.Quantity, 0) *
COALESCE(p.Price, 0)) AS TotalValue
from Orders o
Left join OrderItems oi on
o.OrderId=oi.OrderId 
left join Products p
on oi.ProductId=p.ProductId
group by oi.Quantity , p.price,o.OrderID,p.ProductName
Order by TotalValue;

--22. Find the name of the department that has the most employees.
Select top 1 d.DepartmentName, Count(e.EmployeeId) as TotalEmployees from
Departments d right join Employees e
on d.DepartmentId=e.DepartmentId
group by d.DepartmentName
order by TotalEmployees Desc ;

--23. For each customer, determine the rank of their orders based
--on the total amount spent, with the highest spending orders 
--receiving the top rank. How would you handle situations where 
--two or more orders have the same total amount?
Select  CustomerName ,Sum(oi.Quantity *p.price)  as TotalMoney, rank() over(order by Sum(oi.Quantity *p.price) DESC )
from Customers c
inner join Orders o On c.CustomerID=o.CustomerId
inner join OrderItems oi on o.OrderId=oi.OrderId
inner join Products p on oi.ProductId=p.ProductId
Group by c.CustomerName;

--24. Revisit the ranking of customer orders from the previous
--question. This time, ensure that consecutive ranks are always as
--signed, even if there are ties in the total amount spent.
--Explain how this approach differs from the ranking method you 
--used in the previous question. In what scenarios would you 
--choose one ranking method over the other?

--25. Identify the two most expensive orders for each customer. 
--How would you handle customers who have fewer than two orders? 
--Consider how your approach would handle ties in order amounts 
--when determining the "top two."


--26. Find the customer who has spent the most money.
Select top 1 CustomerName ,Sum(oi.Quantity *p.price)  as TotalMoney
from Customers c
inner join Orders o On c.CustomerID=o.CustomerId
inner join OrderItems oi on o.OrderId=oi.OrderId
inner join Products p on oi.ProductId=p.ProductId
Group by c.CustomerName
Order by TotalMoney DESC;

--27. List all customers who have never placed an order.
Select c.CustomerId,c.CustomerName from
Customers c left join
Orders o on c.CustomerId = o.CustomerID
where o.OrderId IS NULL;

--28. Find the product that has been sold the most (in terms of 
--quantity).
Select top 1 ProductName ,TotalQuantity
from 
(Select p.ProductName,sum(oi.Quantity) As TotalQuantity from Products p
inner join OrderItems oi on p.productId=oi.ProductId 
group by p.ProductName)
AS ProductQuantities
Order by TotalQuantity DESC;