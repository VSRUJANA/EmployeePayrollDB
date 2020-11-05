-- Create a database
create database Payroll_Service;
-- View database
use Payroll_Service;
select DB_NAME();

-- Create table in the database
create table employee_payroll
(
id int identity(1,1),
name varchar(25) not null,
salary money not null,
start_date date not null
);

-- Display table details
select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'employee_payroll';
-- Inserting data in table
insert into employee_payroll values
('Bill',100000.00,'2018-10-03'),
('Teresa',200000.00,'2019-08-28'),
('Charlie',300000.00,'2020-04-05');

-- Retrieve all data from table
select * from employee_payroll;

-- Selecting salary of Teresa
select salary from employee_payroll where name = 'Teresa';
-- Selecting all employees with start date between 1/1/2018 and present date
select * from employee_payroll where start_date between '2018-01-01' and GETDATE();

-- Add extra column 'Gender' to table
Alter table employee_payroll
Add gender char;
select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'employee_payroll';
-- Update gender of employees
update employee_payroll set gender = 'M' where name = 'Bill' or name = 'Charlie';
update employee_payroll set gender = 'F' where name = 'Teresa';
select * from employee_payroll;

-- Sum of salary of all males
select SUM(salary) from employee_payroll
where gender = 'M'
group by gender
-- Average salary based on gender
select AVG(salary), gender from employee_payroll
group by gender;
-- Minimum salary based on gender
select MIN(salary), gender from employee_payroll
group by gender;
-- Maximum salary based on gender
select MAX(salary), gender from employee_payroll
group by gender;
-- Employee count based on gender
select COUNT(gender), gender from employee_payroll
group by gender;

-- Add new columns phone,address and department to table
Alter table employee_payroll add phone varchar(15)
Alter table employee_payroll add department varchar(20) 
Alter table employee_payroll add address varchar(150)
Alter table employee_payroll add constraint df_address default 'India' for address;

-- Add BasicPay,Deductions,TaxablePay,IncomeTax and NetPay columns to table
sp_rename 'employee_payroll.salary', 'basic_pay';
alter table employee_payroll add deduction money,taxable_pay money,income_tax money,net_pay money;

-- Update data for newly added columns
Update employee_payroll set phone = '8332098789', department = 'Sales', address = 'Hyderabad', taxable_pay=70000, net_pay=95000 where name = 'Bill'
Update employee_payroll set phone = '9490876432', department = 'Marketing', address = 'Chennai', taxable_pay=180000, net_pay=190000 where name = 'Teresa'
Update employee_payroll set phone = '7413454566', department = 'Finance', address = 'Bangalore', taxable_pay=250000, net_pay=285000 where name = 'Charlie'
Update employee_payroll set deduction=50000, income_tax=10000
select * from employee_payroll;

-- DBCC CHECKIDENT (employee_payroll, RESEED, 3);

-- Make Teresa as a part of sales and marketing department
insert into employee_payroll values
('Teresa','200000.00','2019-08-28','F','Chennai','9490876432','Sales',50000,180000,10000,190000);
select * from employee_payroll;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Implement ER Diagram

-- Create Employee Table
create table Employee
(
Emp_ID int identity(1,1),
Company_ID int not null,
Emp_Name varchar(25) not null,
Gender char not null,
Phone_No varchar(15) not null,
Address varchar(20) not null,
start_date date not null
PRIMARY KEY (Emp_ID)
);

-- Inserting data into Employees table
insert into Employee values
(100,'Bill','M','7413454354','Hyderabad','2018-10-03'),
(121,'Teresa','F','8985665656','Bangalore','2019-08-28'),
(144,'Charlie','M','9189898765','Chennai','2020-04-05'),
(100,'Jack','M','+91 8339898765','Delhi','2016-11-05'),
(144,'Jill','M','6300898765','Chennai','2017-04-15'),
(169,'Emma','F','7656898765','Hyderabad','2018-07-25');

-- View Employee table
select * from Employee;

-- Create Company Table
create table Company
(
Company_ID int not null,
Company_Name varchar(25) not null
PRIMARY KEY (Company_ID)
);

-- Inserting data into Company Table
insert into Company values
(100,'Capgemini'),
(121,'Wipro'),
(144,'Microsoft'),
(169,'Amazon');

-- View Company Table
select * from Company;

-- Create Department Table
create table Department
(
Dept_ID int not null,
Dept_Name varchar(25) not null
PRIMARY KEY (Dept_ID)
);

-- Inserting data into Department Table
insert into Department values
(1001,'Sales'),
(1002,'Marketing'),
(1003,'HR'),
(1004,'Finance');

-- View Department Table
select * from Department;

-- Create Employee_Department_Relation table to maintain many-many relationship between Employee and Department
create table Employee_Department_Relation
(
Employee_ID int not null,
Department_ID int not null,
FOREIGN KEY (Employee_ID) REFERENCES Employee(Emp_ID), 
FOREIGN KEY (Department_ID) REFERENCES Department(Dept_ID)
);

-- Inserting data into Employee_Department_Relation table
insert into Employee_Department_Relation values
(1,1001),
(2,1001),
(2,1002),
(3,1004),
(4,1003),
(5,1004),
(6,1002);

-- Create Payroll Table
create table Payroll
(
Emp_ID int,
BasicPay money,
Deduction money,
TaxablePay money,
IncomeTax money,
NetPay money
);

-- Inserting Data into Payroll table
insert into Payroll values
(1,120000,10000,110000,10000,100000),
(2,220000,10000,210000,10000,200000),
(3,320000,10000,310000,10000,300000),
(4,420000,10000,410000,10000,400000),
(5,120000,10000,110000,10000,100000),
(6,220000,10000,210000,10000,20000);

-- View Payroll table
select * from Payroll;

--Join Employee, Payroll and Company tables
SELECT emp.Emp_ID,Emp_Name,emp.Company_ID,Company_Name,BasicPay,Deduction,TaxablePay,IncomeTax,NetPay
FROM Employee emp
JOIN Payroll pay
ON emp.Emp_ID=pay.Emp_ID
JOIN Company company
ON emp.Company_ID=company.Company_ID;

-- Join Employee and Department tables
SELECT emp.Emp_ID,Company_ID,Emp_Name,dept.Dept_ID,dept.Dept_Name
FROM Employee emp
JOIN Employee_Department_Relation emp_Dept
    ON emp.Emp_ID = emp_Dept.Employee_ID
JOIN Department dept
    ON emp_Dept.Department_ID = dept.Dept_ID;

-- Retrieve all data from database
SELECT emp.Emp_ID,Emp_Name,emp.Company_ID,Company_Name,dept.Dept_ID,dept.Dept_Name,BasicPay,Deduction,TaxablePay,IncomeTax,NetPay
FROM Employee emp
JOIN Employee_Department_Relation emp_Dept
    ON emp.Emp_ID = emp_Dept.Employee_ID
JOIN Department dept
    ON emp_Dept.Department_ID = dept.Dept_ID
JOIN Company company
ON emp.Company_ID=company.Company_ID
JOIN Payroll pay
ON emp.Emp_ID=pay.Emp_ID;

-- Selecting salary for particular employee
SELECT Emp_Name,BasicPay,Deduction,TaxablePay,IncomeTax,NetPay FROM Payroll pay
JOIN Employee emp ON emp.Emp_ID=pay.Emp_ID
where emp.Emp_Name='Teresa';

-- Selecting all employees with start date between 1/1/2018 and present date
select * from Employee 
where start_date between '2018-01-01' and GETDATE();

-- Sum of salary of all males
select gender,SUM(NetPay) from Payroll pay
join Employee emp on emp.Emp_ID=pay.Emp_ID
group by gender
-- Average salary based on gender
select gender,AVG(NetPay) from Payroll pay
join Employee emp on emp.Emp_ID=pay.Emp_ID
group by gender;
-- Minimum salary based on gender
select gender,MIN(NetPay) from Payroll pay
join Employee emp on emp.Emp_ID=pay.Emp_ID
group by gender;
-- Maximum salary based on gender
select gender,MAX(NetPay) from Payroll pay
join Employee emp on emp.Emp_ID=pay.Emp_ID
group by gender;
-- Employee count based on gender
select COUNT(gender), gender from Employee
group by gender;