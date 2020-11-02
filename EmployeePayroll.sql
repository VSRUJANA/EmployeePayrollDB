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
