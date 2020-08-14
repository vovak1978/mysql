#1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
select * from client where length(firstname) < 6;

#2. +Вибрати львівські відділення банку.
select * from department where DepartmentCity = 'lviv';

#3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select * from client where Education = 'high' order by LastName;

#4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
select * from application order by idapplication desc limit 5;

#5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select * from client where LastName like '%ov' or '%ova';

#6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select * from client c join department d on Department_idDepartment = idDepartment
where d.DepartmentCity = 'kyiv';

#7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
select firstname, passport from client order by FirstName;

#8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select * from client c join application a on idClient = Client_idClient
where a.CreditState = 'not returned' and a.Currency = 'gryvnia' and a.Sum > 5000;

#9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select count(idClient) from client union 
select count(idclient) from client c join department d on Department_idDepartment=idDepartment
where d.DepartmentCity = 'lviv';


#10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select FirstName, LastName, max(sum) from application a  join client c on Client_idClient = idClient
group by Client_idClient;

#11. Визначити кількість заявок на крдеит для кожного клієнта.
select Client_idClient, count(*) from application group by Client_idClient;

#12. Визначити найбільший та найменший кредити.
select Currency, max(sum), min(sum) from application where Currency = 'euro'; 

#13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select count(idapplication), FirstName, LastName from application a inner join client c on Client_idClient = idClient
where Education = 'high'group by LastName, FirstName;

#14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select idClient,LastName,FirstName, avg(Sum) as suma 
from client as c, application as a where c.idClient = a.Client_idClient 
group by idClient order by suma desc limit 1;
 

#15. Вивести відділення, яке видало в кредити найбільше грошей
select idDepartment, sum(sum), DepartmentCity as suma from 
(application a inner join client с on idClient = Client_idClient)
inner join department d on idDepartment = Department_idDepartment 
group by idDepartment order by suma desc limit 1;  

#16. Вивести відділення, яке видало найбільший кредит.
select Department_idDepartment, max(Sum) as suma  from 
(application a join client с on idClient = Client_idClient)
join department d on idDepartment = Department_idDepartment 
group by Department_idDepartment order by suma desc limit 1;   

#17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update application as a join client as c on idClient = Client_idClient 
set a.sum = 6000 where c.education = 'high'; 

#18. Усіх клієнтів київських відділень пересилити до Києва.
update client as c join department as d on Department_idDepartment = idDepartment
set c.city = 'kyiv' where d.departmentcity = 'kyiv';

#19. Видалити усі кредити, які є повернені.
delete from application where CreditState = 'returned';


#20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
delete a from application as a join client as c on Client_idClient = idClient
 where LastName like '_o%' or LastName like '_e%' or LastName like '_a%' ;


#21. Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select iddepartment, sum(sum) as s  from (department as d join client as c
on Department_idDepartment = idDepartment) join application as a on Client_idClient = idClient
where DepartmentCity = 'lviv'
group by idDepartment having s > 5000; 

#22. Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select lastname, sum(sum) as sum from client as c join application on Client_idClient = idClient 
where CreditState = 'returned'
group by idClient having sum > 5000; 

#23. Знайти максимальний неповернений кредит.*/
select max(sum) from application where CreditState = 'not returned'; 


#24. Знайти клієнта, сума кредиту якого найменша*/
select FirstName, LastName, sum(sum) as suma from client as c join application as a 
on Client_idClient = idClient group by idClient order by suma limit 1 ;



#25. Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
select * from application where sum > (select avg(Sum) as suma
from application);


#26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
select * from client where City = (select City from (select City, count(idApplication) as count from application as a
inner join client as c on Client_idClient = idClient 
group by Client_idClient order by count desc limit 1) t);



#27. місто чувака який набрав найбільше кредитів
select Client_idClient, FirstName, City,  max(sum) as suma
from application as a, client as c 
where a.Client_idClient = c.idClient
group by Client_idClient order by suma desc limit 1;

