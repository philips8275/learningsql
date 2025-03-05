

use ims;
show tables;
select * from student;
select * from teacher;

create table stjoin(sid int(5), Tid int(5),
 foreign key(sid) references student(sid) on delete set null on update cascade , 
foreign key(Tid) references teacher(Tid) on delete set null on update cascade);

insert into stjoin values(1,null);
insert into stjoin values(2,2);
insert into stjoin values(3,2);
insert into stjoin values(4,4);
insert into stjoin values(5,4);
insert into stjoin values(6,5);
insert into stjoin values(7,2);
insert into stjoin values(8,3);
insert into stjoin values(11,3);
insert into stjoin values(10,6);
insert into stjoin values(2,5);
delete from stjoin where Tid=5 and sid=2;
delete from stjoin where sid=6 and Tid=5;

update stjoin set Tid=null where sid=11;
select * from stjoin;


select t.fname, s.fname from stjoin st right join student s on s.sid=st.sid right join teacher t on t.Tid=st.Tid;

select t.fname, count(st.sid) as student_count from stjoin st right join teacher t on t.Tid=st.Tid group by st.Tid,t.fname;

select s.sid,s.fname,s.email,s.Address from stjoin st right join student s on s.sid=st.sid 
union 
select t.Tid,t.fname,t.email,t.Department from stjoin st left join teacher t on t.Tid=st.Tid;

create view subject as select s.fname as Student_Name,t.fname as teacher_name,t.Department,s.email as student_email,t.email as teacher_email from stjoin st left join student s on s.sid=st.sid left join teacher t on t.Tid=st.Tid;
select * from subject;
show create view subject;
delete from subject where Student_name='Francis' and Department=null;
drop view subject;

create view studenttable as select fname, lname , email from student;
select * from studenttable;
delete from studenttable where fname='abc';

create view DS as select t.fname as Teacher_name, count(st.Tid) as Student_count from teacher t left join stjoin st on t.Tid=st.Tid group by t.fname;
select * from DS;
drop view DS;
 
 
 
select t.fname,t.Department, count(st.Tid) as student_count from teacher t left join stjoin st on t.Tid=st.Tid group by t.Tid, t.fname;
select s.fname as Student_name, t.Department from student s left join stjoin st on st.sid=s.sid inner join teacher t on t.Tid=st.sid;




create table stu(id int(5), fname varchar(50), emails varchar(50));
select * from stu;
delete from stu where id=3;
SET SQL_SAFE_UPDATES = 0;

delimiter //

create procedure semails(id int(5), fname varchar(50),email varchar(50))
begin
insert into stu values(id,fname,email);
end //

call semails(3,'dso','dso@')//

create procedure studentname (in sid int(5),out sname varchar(50))
begin
select fname into sname from stu where sid=id;
end//

call studentname(1,@student_name)//
select @student_name//

drop procedure studentname//
 
delimiter ;

create table accouont(accno int(5) primary key, name varchar(50), balance int(10));
insert into accouont values(1,'Philips',50000);
insert into accouont values(2,'brian',60000);
insert into accouont values(3,'roystan',70000);
insert into accouont values(4,'Gaurav',50000);
select * from accouont;

create table ministatement(transid int(5) primary key, accno int(5),foreign key(accno) references accouont(accno), prebalance int(5),nextbalance int(5),tdate date);
ALTER TABLE ministatement 
MODIFY COLUMN transid INT AUTO_INCREMENT;
create trigger ministatement before update on accouont
for each row
begin
insert into ministatement values ('0',OLD.accno,OLD.balance,NEW.balance,(select curdate()));
end
$$

delimiter ;
update accouont set balance=15000 where accno=1;

select * from ministatement;

update accouont set balance=1500000 where accno=1;

create table admission(aid int(5) primary key auto_increment,name varchar(200),email varchar(200),contact varchar(200),company varchar(200),status int(5) default 0);
insert into admission values(0,'Philips','philips@','98745631','Nvidia','1');
insert into admission values(0,'brian','brain@','91745631','Google',1);
insert into admission values(0,'Roystan','Roystan@','93745631','NTT',1);
insert into admission values(0,'Gaurav','gaurav@','98745931','TCS',0);
insert into admission values(0,'Philips','philips@','98745631','Google',0);

select aid from admission where name='Philips';

create table alumni(almid int(5) primary key auto_increment,name varchar(200),email varchar(200),contact varchar(200),company varchar(200));
select * from alumni;

delimiter $$
create trigger savealumni after update on admission
for each row
begin
 insert into alumni values(null,OLD.name,OLD.email,OLD.contact,OLD.company);
 delete from admission where aid=OLD.aid;
 end$$
delimiter ;

select * from alumni;
drop trigger savealumni;
update admission set status='1' where aid=5;
DESC admission;
