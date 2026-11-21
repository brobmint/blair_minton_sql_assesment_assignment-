CREATE TABLE project (
project_id VARCHAR(255) PRIMARY KEY,
proj_name VARCHAR(255),
domain VARCHAR(255),
start_date VARCHAR(255),
closure_date VARCHAR(255),
dev_qtr VARCHAR(255),
status VARCHAR(255)
);

CREATE TABLE employee_record (
emp_id VARCHAR(255) PRIMARY KEY,
first_name VARCHAR(255),
last_name VARCHAR(255),
gender VARCHAR(255),
role VARCHAR(255),
dept VARCHAR(255),
exp INTEGER,
country VARCHAR(255),
continent VARCHAR(255),
salary INTEGER,
emp_rating INTEGER,
manager_id VARCHAR(255),
proj_id VARCHAR(255),
FOREIGN KEY (proj_id) REFERENCES project(project_id),
FOREIGN KEY (manager_id) REFERENCES employee_record(emp_id)
);

CREATE TABLE data_science_team (
emp_id VARCHAR(255) PRIMARY KEY,
first_name VARCHAR(255),
last_name VARCHAR(255),
gender VARCHAR(255),
role VARCHAR(255),
dept VARCHAR(255),
exp INTEGER,
country VARCHAR(255),
continent VARCHAR(255),
FOREIGN KEY (emp_id) REFERENCES employee_record(emp_id)
);

select emp_id, first_name, last_name, gender, dept
from employee_record;

select emp_id, first_name, last_name, gender, dept, emp_rating
from employee_record 
where emp_rating < 2 or emp_rating > 4 or emp_rating between 2 and 4;

select first_name || ' ' || last_name as name
from employee_record
where dept = 'FINANCE'; 

select emp_id, first_name, role, dept
from employee_record 
where role = 'MANAGER' 
or role = 'PRESIDENT' 
or role = 'CEO';

select *
from employee_record 
where dept = 'HEALTHCARE'
union all 
select *
from employee_record
where dept = 'FINANCE';

select emp_id, first_name, last_name, role, dept, emp_rating, MAX(emp_rating) OVER (partition by dept) as dept_rating
from employee_record;

select role, MIN(salary) as min_salary, MAX(salary) as max_salary 
from employee_record 
group by role;


select rank() over (order by exp desc) as experience_rank, 
emp_id, 
first_name, 
last_name,
exp
from employee_record; 

create view various_countries as 
select country, emp_id, first_name, last_name
from employee_record 
where salary > 6000

select emp_id, first_name, last_name, exp 
from employee_record 
where exp IN (
select exp
from employee_record
where exp > 10 
);

with role_check AS (
select p.project_id, d.emp_id, d.role, CASE 
WHEN d.exp <= 2 THEN 'JUNIOR DATA SCIENTIST'
WHEN d.exp > 2 AND d.exp <= 5 THEN 'ASSOCIATE DATA SCIENTIST'
WHEN d.exp > 5 AND d.exp <= 10 THEN 'SENIOR DATA SCIENTIST'
WHEN d.exp > 10 AND d.exp <= 12 THEN 'LEAD DATA SCIENTIST'
WHEN d.exp > 12 AND d.exp <= 16 THEN 'MANAGER'
END AS role_experience 
From data_science_team d
left join employee_record ep on ep.emp_id = d.emp_id
left join project p on p.project_id = ep.proj_id)
select role, role_experience, emp_id, CASE
WHEN role = role_experience THEN 'MATCH' 
ELSE 'MISMATCH'
END AS role_status 
from role_check;

select emp_id, 
first_name, 
last_name,
emp_rating,
salary,
round(salary * 0.05 * emp_rating, 2) as bonus
from employee_record;

select AVG (salary) as average_salary, country, continent
from employee_record 
group by country, continent;
