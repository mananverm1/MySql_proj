-- welcome to my sql project on Employees
-- import zip file from(https://github.com/datacharmer/test_db)
-- import all the data into mysql workbench by extracting that zip file

-- now  use database employees
use employees;
-- check all the tables we have
select * from departments;
select * from dept_emp;
select * from dept_manager;
select * from employees;
select * from salaries;
select * from titles;

-- checking how many employees we have in our organization
select count(emp_no) from employees;

-- Checking how many male and female employees there are
select count(emp_no) male_emp from employees where gender='m';
select count(emp_no) male_emp from employees where gender='f';

-- Checking employees name starts with letter g,b,p
select distinct first_name from employees 
where first_name like 'G%' or first_name like 'B%' or first_name like 'P%';

-- Checking how many employees were hired in a particular year. 
select count(emp_no),year(hire_date)
from employees 
group by year(hire_date);

-- checking dep_no,title of a perticular employees
select * from dept_emp;
select * from titles;
select distinct e.emp_no,t.title,d.dept_no 
from employees e 
inner join titles t
on e.emp_no=t.emp_no
inner join dept_emp d 
on e.emp_no=d.emp_no;

-- checking dept_no and department name of perticular employees
select *  from dept_emp;
select * from departments;
select 
distinct concat(e.first_name,' ',e.last_name),
e.emp_no,
de.dept_no,
d.dept_name
from employees e  
inner join dept_emp de on
e.emp_no=de.emp_no  
inner join departments d 
on de.dept_no=d.dept_no;

-- checking hireing rate of employees as per hire_date
select * from employees;
select year(hire_date) ,count(emp_no),
lag(count(emp_no),1) over (order by year(hire_date))
from employees 
group by year(hire_date)
order by  year(hire_date);

select year(hire_date) hireing_year,count(emp_no) Total_emp,
(
	(
		count(emp_no)- lag(count(emp_no),1) over (order by year(hire_date))
	)/lag(count(emp_no),1) over (order by year(hire_date))
    )*100 as growth_rate
from employees 
group by year(hire_date)
order by year(hire_date);



-- Checking how many employees we have in perticular department 
select count(e.emp_no), d.dept_no,dn.dept_name
from employees e inner join dept_emp d 
on e.emp_no=d.emp_no
inner join departments dn 
on d.dept_no=dn.dept_no
group by d.dept_no;

-- checking how much total salary we are giving
select sum(salary) from salaries;

-- checking salary of perticular employees
select emp_no,sum(salary) as total_salary
from salaries
group by emp_no;

-- checking the growth rate of salary of employee 10001
select * from salaries;
select emp_no,from_date,salary,
(
(salary-lag(salary,1) over(order by from_date))/salary
)*100 as growth_rate
from salaries where emp_no=10001
order by from_date;


-- checking which employess has maximum salary
SELECT concat(e.first_name,' ',e.last_name) emp_name, s.emp_no ,MAX(s.salary) salary 
FROM employees e
inner join salaries s on
e.emp_no=s.emp_no
GROUP BY emp_no
ORDER BY MAX(salary) DESC
LIMIT 1;

-- Delete details of employee 10021 from 4 tables using inner join
select * from employees 
where emp_no=10021;
select * from salaries 
where emp_no=10021;
select * from dept_emp 
where emp_no=10021;
select * from titles 
where 	emp_no=10021;

delete e,s,d,t from employees e 
inner join
salaries s 
on e.emp_no=s.emp_no
inner join
dept_emp d 
on e.emp_no=d.emp_no
inner join 
titles t 
on e.emp_no=t.emp_no
where e.emp_no=10021;


-- checking how many employees has salaries between 30000-40000,40001-50000,50001-60000,60001-70000,70001-80000 using distribution
select '30000-40000' as salary ,
count(emp_no) Total_emp 
from salaries where salary 
between 30000 and 40000
union
select '40001-50000' as salary,
count(emp_no) Total_emp  
from salaries 
where salary between 40001 and 50000
union
select '50001-60000' as salary ,
count(emp_no) Total_emp 
from salaries 
where salary between 50001 and 60000
union
select '60001-70000' as salary ,
count(emp_no) Total_emp 
from salaries 
where salary between 60001 and 70000
union
select '70001-80000' as salary ,
count(emp_no) Total_emp 
from salaries 
where salary between 70001 and 80000;

-- deviding salaries table into 4 quartile
select emp_no,salary,ntile(4) 
over (order by salary) quartile  
from salaries;

-- checking which employyes hired before 1989

select year(hire_date),
case
when year(hire_date) <'1989'
then emp_no
else 0
end username
from employees;
select emp_no ,sum(salary) from salaries where emp_no=10001;

-- creating some store procedure 
	-- you can check department name by just entering dept_no
        call set_dept_no('d002');
	-- you can check total salary of perticular employee by entering emp_no
		call emp_sal(10002);
	--  you can check how many employees in perticular gender
    set @gender='f';
    select @gender;
    call gender_emp(@gender,@count);
    select @count;
    
