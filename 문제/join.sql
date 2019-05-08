-- join
-- employees 테이블과 titles 테이블을 join하여 
-- 직원의 이름과 직책을 모두출력하되 여성 엔지니어만 출력

select e.first_name, t.title
from employees e, titles t
where e.emp_no = t.emp_no
and e.gender = 'f';
