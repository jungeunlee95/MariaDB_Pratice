-- DDL
drop table member; 
create table member(
	no int not null auto_increment,
    email varchar(50) not null default '',
    passwd varchar(64) not null, -- mysql 함수로 암호화 시킬 수 있음
    name varchar(25),
    dept_name varchar(25),
    
    primary key(no)
);

desc member;
    
insert into member(passwd, name, dept_name)
 values(password('1234'), '이정은', '개발팀');

alter table member add juminbunho char(13) not null after no;
alter table member drop juminbunho;

alter table member add join_date datetime default now();

alter table member change no no int unsigned not null auto_increment;

alter table member change dept_name department_name varchar(25);

alter table member rename user;

insert into user
values(null, '', password('1234'), '이정은4', '개발팀', now());


update user
set join_date = (select now())
where no =1;

update user
set join_date = (select now()),
	name = "이정은수정"
where no =1;

delete from user where no = 1;

desc user;
select * from user;

show tables;













