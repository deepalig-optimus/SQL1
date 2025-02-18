Create Database Assignment;
Use Assignment;

-- Employee table
Create Table t_emp(
	emp_id int Identity(1001,2) Primary key,
	emp_code varchar(100),
	emp_f_name varchar(50) not null,
	emp_m_name varchar(50),
	emp_l_name varchar(50),
	emp_dob Date not null Check(DateDiff(Year,GetDate(),emp_dob)>18);
	emp_doj Date not null
	);


/*Create table n(
	DOB Date Check(DateDiff(year,GetDate(),dob)>18)
	);*/


--Activity table
Create Table t_activity(
activity_id int Primary key,
activity_description varchar(100)
);


--- Attendence Description Table
Create Table t_atten_det(
	atten_id int Identity(1001,1) Primary key ,
	emp_id int,
	activity_id int,
	atten_start_datetime DATETIME,
	atten_end_hrs int
	Foreign key (emp_id) References t_emp(emp_id),
	Foreign key (activity_id) References t_activity(activity_id)
	);


---Salary Table
Create Table t_salary(
	salary_id int primary key,
	emp_id int,
	changed_date Date,
	new_salary Decimal(18,2)
	);



--Insert Data into Employee Table
Insert into t_emp(emp_code,emp_f_name,emp_m_name,emp_l_name,emp_dob,emp_doj)
	Values('OPT20110105','Manmohan',NULL,'Singh','1983-02-10','2010-05-25'),
		('OPT20100915','Alfred','Joseph','Lawerence','1988-02-28','2010-06-20'),
		('OPT20100900','Aman','Joseph','Lawerence','1988-02-28','2004-06-20')
		;

Select * from t_emp;

---Insert data into Activity Table
Insert into t_activity(activity_id,activity_description)
	Values(1,'Code Anlaysis'),
		  (2,'Lunch'),
		  (3,'Coding'),
		  (4,'Knowledge Transition'),
		  (5,'Databse');


--Insert Data into Attende Table
Insert into t_atten_det(emp_id,activity_id,atten_start_datetime,atten_end_hrs)
			Values(1001,5,'2011-2-13 10:00:00',2),
				(1001,1,'2011-1-14 10:00:00',3),
				(1001,3,'2011-1-14 13:00:00',5),
				(1003,5,'2011-2-16 10:00:00',8),
				(1003,5,'2011-2-17 10:00:00',8),
				(1003,5,'2011-2-19 10:00:00',7);



--Insert Data into salary table
Insert into t_salary(salary_id,emp_id,changed_date,new_salary)
	values(1001,1003,'2011-02-16',20000.00),
		(1002,1003,'2011-01-05',25000.00),
		(1003,1001,'2011-02-16',26000.00);


Select * from t_emp;
Select * from t_activity;
Select * from t_atten_det;
Select * from t_salary;





Insert into t_emp(emp_code,emp_f_name,emp_m_name,emp_l_name,emp_dob,emp_doj)
	Values('OPT20110107','Aman','Rajput','Singh','1983-01-30','2010-06-25'),
		('OPT20100815','Ram',NULL,'Gupta','1988-03-31','2010-06-20');

Select * from t_emp;

--Q1 To Get fullName where DOB is on last day of month
With GetEmpByLastDay As(
	Select
		concat(emp_f_name,' ',emp_m_name,' ',emp_l_name) as full_name,
		emp_dob,
		Case 
			When Month(emp_dob) in(1,3,5,7,8,10,12) and Day(emp_dob)=31 then 'yes'
			When Month(emp_dob) in(4,6,9,11) and Day(emp_dob)=30 then 'yes'
			when Month(emp_dob)=2 and Day(emp_dob) in(28,29) then 'yes'
			else
			'no'
		End as lastdayofmonth
	from t_emp
)
Select * from GetEmpByLastDay
where lastdayofmonth='yes';

--Select Day(emp_dob) as Date from t_emp;
--Select month(emp_dob) as month from t_emp;


---Q2 Display fullname,
---			increment- y/n,
---			Previous salary
--			current salary
--			total worked hours
--			last worked activity and hours in that

Select 
	concat(e.emp_f_name,' ',e.emp_m_name,' ',e.emp_l_name) as fullname,
	sum(a.atten_end_hrs) as total_worked_hrs
	from t_emp e inner join 
	t_atten_det a on
	e.emp_id=a.emp_id
	group by a.atten_end_hrs,e.emp_f_name,e.emp_m_name,e.emp_l_name;
	
