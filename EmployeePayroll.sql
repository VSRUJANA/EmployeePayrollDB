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
start date not null
);

-- Display table details
select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'employee_payroll';
-- Inserting data in table
insert into employee_payroll values
('Bill',100000.00,'2018-10-03'),
('Teresa',200000.00,'2019-08-28'),
('Charlie',300000.00,'2020-04-05');