-- 현재 Fai Bale이 근무하는 부서에서 근무하는 직원의 사번, 전체 이름을 출력
-- 부서찾기
select b.dept_no
from employees a, dept_emp b
where a.emp_no = b.emp_no
and b.to_date='9999-01-01'
and concat(a.first_name,' ',a.last_name) = 'Fai Bale';

-- 그 부서 직원들 찾기
select a.emp_no, concat(a.first_name,' ',a.last_name)
from employees a, dept_emp b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.dept_no = 'd004';

-- subquery로 한번에
select a.emp_no, concat(a.first_name,' ',a.last_name)
from employees a, dept_emp b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.dept_no = (select b.dept_no
				from employees a, dept_emp b
				where a.emp_no = b.emp_no
				and b.to_date='9999-01-01'
				and concat(a.first_name,' ',a.last_name) = 'Fai Bale');
                
                
-- 실습문제 1: 현재 전체사원의 평균 연봉보다 적은 급여를 받는 사원의 이름, 급여 출력
select concat(a.first_name,' ',a.last_name) 이름, b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.salary < (select avg(salary)
			    from salaries
				where to_date = '9999-01-01')
order by b.salary desc;


-- 실습문제 2: 현재 가장적은 평균 급여를 받고 있는 직책에 대해서 평균 급여 출력   
-- 1번째 방법 : TOP-K(order by 후에 top부터 k개를 빼내는 것)
select b.title, avg(a.salary)
from salaries a, titles b
where a.emp_no = b.emp_no
and a.to_date='9999-01-01'
and b.to_date='9999-01-01'
group by b.title
having avg(a.salary) = (select avg(a.salary)
						from salaries a, titles b
						where a.emp_no = b.emp_no
						and a.to_date='9999-01-01'
						and b.to_date='9999-01-01'
						group by b.title
						order by avg(a.salary)
						limit 1);
                        
-- 2번째 방법
select b.title, avg(a.salary)
from salaries a, titles b
where a.emp_no = b.emp_no
and a.to_date='9999-01-01'
and b.to_date='9999-01-01'
group by b.title
having round(avg(a.salary)) = (select min(avg_salary)
								from( select round(avg(a.salary)) as avg_salary
										from salaries a, titles b
										where a.emp_no = b.emp_no
										and a.to_date='9999-01-01'
										and b.to_date='9999-01-01'
										group by b.title) a);

-- 3번째 방법 : JOIN만으로 풀어보깅 
-- 사실 1번째 방법에서 굳이 서브쿼리 쓸 이유가 없음
select b.title, avg(a.salary) avg_salary
from salaries a, titles b
where a.emp_no = b.emp_no
and a.to_date='9999-01-01'
and b.to_date='9999-01-01'
group by b.title
order by avg_salary
limit 1;
               
               
               
-- 결과가 여러개인 경우(복수,다중행)
-- 문제1 :  현재 급여가 50000 이상인 직원 이름 출력
-- in, =any
select concat(a.first_name, ' ', a.last_name), b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and (a.emp_no, b.salary) in (select emp_no, salary
							from salaries
							where to_date = '9999-01-01'               
							and salary > 50000);        
select concat(a.first_name, ' ', a.last_name), b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and (a.emp_no, b.salary) =any (select emp_no, salary
							from salaries
							where to_date = '9999-01-01'               
							and salary > 50000);                        
                
-- from 절에 subquery
select concat(a.first_name, ' ', a.last_name), b.salary		
from employees a, (select emp_no, salary
					from salaries
					where to_date = '9999-01-01'               
					and salary > 50000) b
where a.emp_no = b.emp_no;            
 
 
 -- 문제 2:  각 부서별로 최고 월급을 받는 직원의 이름과 월급 출력
 select c.dept_no, max(b.salary) as max_salary
 from employees a, salaries b, dept_emp c
 where a.emp_no = b.emp_no
 and a.emp_no = c.emp_no
 and b.to_date='9999-01-01'
 and c.to_date='9999-01-01'
 group by c.dept_no;
 
 -- 1 where 절에 subquery사용해보기
  select a.first_name, c.dept_no, b.salary
 from employees a, salaries b, dept_emp c
 where a.emp_no = b.emp_no
 and a.emp_no = c.emp_no
 and b.to_date='9999-01-01'
 and c.to_date='9999-01-01'
 and (c.dept_no, b.salary) =any( select c.dept_no, max(b.salary) as max_salary
								 from employees a, salaries b, dept_emp c
								 where a.emp_no = b.emp_no
								 and a.emp_no = c.emp_no
								 and b.to_date='9999-01-01'
								 and c.to_date='9999-01-01'
								 group by c.dept_no);
 -- 1 from 절에 subquery사용해보기
  select a.first_name, c.dept_no, b.salary
 from employees a, salaries b, dept_emp c,
	  ( select c.dept_no, max(b.salary) as max_salary
		 from employees a, salaries b, dept_emp c
		 where a.emp_no = b.emp_no
		 and a.emp_no = c.emp_no
		 and b.to_date='9999-01-01'
		 and c.to_date='9999-01-01'
		 group by c.dept_no) d
 where a.emp_no = b.emp_no
 and a.emp_no = c.emp_no
 and c.dept_no = d.dept_no
 and b.to_date='9999-01-01'
 and c.to_date='9999-01-01'
 and b.salary = d.max_salary;




 
 
 
 
 
 
