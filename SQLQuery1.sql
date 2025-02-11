create database db1;
create table t1(id INT primary key ,name varchar(20),doj date);
insert into t1 values(1,'emp1','03-02-2025');
insert into t1 values(2,'emp2','03-02-2025'),
(3,'emp3','01-02-2025'),
(4,'emp2','03-02-2025');
select * from t1;

select doj from t1 where
name like 'e%';

update t1 
set doj='10-01-2025' where name='emp1';

alter table t1
add salary int;

alter table t1
add email varchar(255);

create table persons(
ID int NOT NULL,
LastName varchar(255),
FirstNAme varchar(255),
Age int,
UNIQUE (ID)
);



Create Table per(
ID int NOT NULL,
FirstName varchar(255),
Age int,
Constraint UC_Person UNIQUE (ID,FirstName)
);
insert into per values(300,
22,'Hally');

create table orders
(OrderId int,
items int,
OrderDate date,
username varchar(20));

insert into orders (OrderId, items, OrderDate, username)
values
(100,5,'2025-02-20','Itee'),
(101,3,'2025-01-10','Shubhi'),
(102,4,'2025-02-12','Manya'),
(103,5,'2025-09-20','Dhruv'),
(104,10,'2025-10-16','Paras'),
(105,8,'2025-11-27','Rohan')
;
select * from orders;


INSERT INTO orders (OrderId, items, OrderDate, username)
VALUES
(100, 5, '2025-10-20', 'Itee'),
(101, 3, '2025-01-10', 'Shubhi'),
(102, 4, '2025-02-12', 'Manya'),
(103, 5, '2025-09-20', 'Dhruv'),
(104, 10, '2025-10-16', 'Paras'),
(105, 8, '2025-12-27', 'Rohan');

alter table orders
add CustomerId varchar(10);

alter table orders
add shipperId varchar(10);

update orders
set CustomerId=CASE
	when OrderId=100 Then 1
	when OrderId=101 Then 2
	when OrderId=102 Then 3
	when OrderId=103 Then 4
	when OrderId=104 Then 5
	when OrderId=105 Then 6
	Else CustomerId
	End;

	update orders
set shipperId=CASE
	when OrderId=100 Then 01
	when OrderId=101 Then 02
	when OrderId=102 Then 03
	when OrderId=103 Then 04
	when OrderId=104 Then 05
	when OrderId=105 Then 06
	Else CustomerId
	End;




delete from orders;

Create table customers(
CustomerId int primary key,
CustomerName varchar(20),
contact_number varchar(15)
);

insert into customers 
values(1,'Itee','2345678901'),
(2,'Shubhi','9812376450'),
(3,'Manya','8790654321');

select * from customers;

select * from orders;

select orders.OrderId,
customers.CustomerName,
orders.OrderDate
from orders
inner join customers on orders.customerId=Customers.CustomerId;


select OrderId 
from orders
inner join customers
on orders.customerId=customers.customerId
;

create table shippers (ShipperId int,
					ShipperName varchar(30));

select orders.orderId,customers.CustomerName,shippers.ShipperName
from ((orders
Inner Join customers on orders.customerId=customers.customerId)
Inner Join shippers on orders.shipperId=shippers.shipperId);


create table departments(
	departmentid int primary key,
	departmentname varchar(100)
	);


create table employees(
	employeeid int primary key,
	firstname varchar(50),
	lastname varchar(50),
	departmentId int,
	jobpositionid int,
	hiredate date,
	salary decimal(10,2),
	foreign key ( departmentid) references
departments(departmentid),
Foreign key(jobpositionId) references
jobpositions(jobpositionid)
);

create table jobpositions(
jobpositionid int primary key,
jontitle varchar(100),
MinSalary Decimal(10,2),
MAxSalary Decimal(10,2)
);

insert into departments values(1,'Human Resources'),
						(2,'Finance'),
						(3,'IT'),
						(4,'Marketing');


INSERT INTO jobpositions (jobpositionid, jontitle, MinSalary, MaxSalary)
VALUES
(1, 'HR Manager', 50000.00, 80000.00),
(2, 'Accountant', 40000.00, 70000.00),
(3, 'Software Developer', 60000.00, 100000.00),
(4, 'Marketing Specialist', 45000.00, 75000.00);


insert into employees(employeeid,firstname,lastname,
departmentid,jobpositionid,hiredate,salary)
values
(1,'Alic','Johnson',1,1,'2020-01-15',75000.00),
(2,'Bob','Smith',2,2,'2019-03-22',65000.00),
(3,'Charlie','Brown',3,3,'2021-06-10',90000.00),
(4,'Diana','Prince',4,4,'2018-11-05',80000.00);


select employeeid, sum(salary) as totalSalary
from employees
group by employeeid
having sum(salary)>70000;

use db1;