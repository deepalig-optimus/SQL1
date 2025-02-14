Create database Production;
Use Production;


-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    DateOfBirth DATE
);
GO

-- Create Products Table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    StockQuantity INT
);
GO

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- Create OrderDetails Table (Many-to-Many relation between Orders and Products)
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Insert Sample Data into Customers
INSERT INTO Customers (FirstName, LastName, Email, DateOfBirth) VALUES
('John', 'Doe', 'john.doe@example.com', '1985-06-15'),
('Jane', 'Smith', 'jane.smith@example.com', '1990-09-20'),
('Bob', 'Johnson', 'bob.johnson@example.com', '1982-11-05');
GO

-- Insert Sample Data into Products
INSERT INTO Products (ProductName, Price, StockQuantity) VALUES
('Laptop', 1200.50, 50),
('Headphones', 150.00, 200),
('Mouse', 25.75, 150),
('Keyboard', 80.00, 120);
GO

-- Insert Sample Data into Orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2025-02-13', 1200.50),
(2, '2025-02-12', 200.00),
(3, '2025-02-11', 105.00);
GO

-- Insert Sample Data into OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price) VALUES
(1, 1, 1, 1200.50),
(2, 2, 1, 150.00),
(2, 3, 2, 25.75),
(3, 4, 1, 80.00);
GO


--Q1 validate email format(Before Insert on Customers)
Create Trigger ValidateEmailFormat
On Customers
Instead of Insert
As
Begin
	Declare @Email Varchar(100);

	Select @Email = Email From Inserted;

	if(@Email not like '%@example.com')
	Begin
		Print 'Error:Email must be in the format @example.com';
		Return;
	End

	Insert into Customers(FirstName,LastName,Email,DateOfBirth)
	Select FirstName,LastName,Email,DateOfBirth From Inserted;
End;
Go


Insert into Customers
(FirstName,LastName,Email,DateOfBirth) 
Values('Deepali','Gupta','Xyz@.com','2025-09-02');
--This will be failed due to incorrect format

Insert into Customers
(FirstName,LastName,Email,DateOfBirth) 
Values('Itee','Gupta','xyz@example.com','2024-05-02');
--will be inserted 

Select * from Customers;


--Q2 Validate Dob(just For learning)
--Same Cannot be created as already exits
/*CREATE TRIGGER ValidateDobFormat
ON Customers
AFTER INSERT
AS
BEGIN
    DECLARE @DateOfBirth DATE;
   
    -- Check if any of the inserted rows have an invalid DateOfBirth format
    SELECT @DateOfBirth = DateOfBirth
    FROM Inserted;
    
    -- If the DateOfBirth does not match the 'yyyy-mm-dd' format, rollback the transaction
    IF (ISDATE(@DateOfBirth) = 0)
    BEGIN
        PRINT 'Error: Invalid Date of Birth format';
        
        -- Rollback the insert to prevent invalid data from being added
        ROLLBACK TRANSACTION;
    END
END;
GO
*/

--Trigger for preventing duplicate Email
Create Trigger PreventDuplicateEmail
On Customers
After Insert
As
Begin
	Declare @Email varchar(255); --local variable

	Select @Email=Email
	From Inserted;

	If Exists (Select 1 From Customers Where Email=@Email)
	Begin
		RaisError('Error:Duplicate Email found.',16,1);

		RollBack Transaction;
	End
End;
Go
Select * from Customers;

Insert into Customers values('Deepali','Gupta','xyz@example.com','2024-09-03');

CREATE TABLE CustomersAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incremented ID for each audit record
    CustomerID INT,
    OldFirstName VARCHAR(100),
    NewFirstName VARCHAR(100),
    OldEmail VARCHAR(100),
    NewEmail VARCHAR(100),
    UpdateDate DATETIME DEFAULT GETDATE()  -- Capture the current date and time of the update
);


--update Trigger
Create Trigger trg_LogCustomerChanges
on Customers
After Update
AS
Begin
	Insert Into CustomersAudit (CustomerID,OldFirstName,NewFirstName,OldEmail,NewEmail)
	Select
		i.CustomerID,
		d.FirstName as OldFirstName,
		i.FirstName as NewFirstName,
		d.Email as OldEmail,
		i.Email as NewEmail
	From 
		Inserted i
	join 
		Deleted d
		On i.CustomerID=d.CustomerID
	Where
		i.FirstName <> d.FirstName
		Or i.Email<>d.Email;
End;
Go

--testing Trigger
Update Customers Set FirstName='Johnathan',Email='john@example.com'
where customerID=1;

Select * From CustomersAudit Where CustomerId=1;

--JSON
Create Table Product(
ProductId Int Primary key,
ProductsDetails nVarchar(Max)
);

INSERT INTO Product (ProductId, ProductsDetails)
VALUES 
(100, '{"ProductName":"Laptop", "Price":999.99, "Category":"Electronics"}'),
(200, '{"ProductName":"Phone", "Price":599.99, "Category":"Electronics"}');

Select ProductId,
	JSON_VALUE(ProductsDetails,'$.ProductName')As ProductName,
	JSON_VALUE(ProductsDetails,'$.Price')As Price
From Product;

Select ISJSON('true',Value);

SELECT ISJSON('test string', VALUE);

--Declare @pSearchOptions nvarchar(4000)=N'[1,2,3,4]'

/*Select *
From products
Inner Join OPENJSON(@pSearchOptions) As productTypes
On product.productTypeId=productTypes.value;*/

Declare @json1 nvarchar(max),@json2 nvarchar(max)
Set @json1=N'{"name":"John","surname":"Does"}'
Set @json2=N'{"name":"John","age":45}'


Select *
From OPENJSON(@json1)
Union ALL
SELECT * 
FROM OPENJSON(@json2)
Where [name] NOT IN (SELECT [name] FROM OPENJSON(@json1))
