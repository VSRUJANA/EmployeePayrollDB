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

-- Add BasicPay,Decductions,TaxablePay,IncomeTax and NetPay columns to table
sp_rename 'employee_payroll.salary', 'basic_pay';
alter table employee_payroll add deduction money,taxable_pay money,income_tax money,net_pay money;

-- Update data for newly added columns
Update employee_payroll set phone = '8332098789', department = 'Sales', address = 'Hyderabad', taxable_pay=70000, net_pay=95000 where name = 'Bill'
Update employee_payroll set phone = '9490876432', department = 'Marketing', address = 'Chennai', taxable_pay=180000, net_pay=190000 where name = 'Teresa'
Update employee_payroll set phone = '7413454566', department = 'Finance', address = 'Bangalore', taxable_pay=250000, net_pay=285000 where name = 'Charlie'
Update employee_payroll set deduction=50000, income_tax=10000
select * from employee_payroll;

-- Make Teresa as a part of sales and marketing department
insert into employee_payroll values
('Teresa','200000.00','2019-08-28','F','Chennai','9490876432','Sales',50000,180000,10000,190000);
select * from employee_payroll;

