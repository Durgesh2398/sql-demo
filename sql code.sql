from - where - group by - having - order by

Select * from moviesdb.movies;
SELECT * FROM moviesdb.movies where title like "%captain%";
SELECT * FROM moviesdb.movies where studio="";
SELECT count(industry) FROM moviesdb.movies where industry="bollywood"
SELECT title, release_year from moviesdb.movies where studio="Marvel studios";
select * from moviesdb.movies where title like "%avenger%";
select release_year from moviesdb.movies where title="The Godfather";
select distinct title from moviesdb.movies where industry="bollywood";

select * from moviesdb.movies where imdb_rating>5 and imdb_rating<8
select * from moviesdb.movies where imdb_rating between 6 and 8;
select * from moviesdb.movies where release_year in (2020,2021);
select * from moviesdb.movies where imdb_rating is null;

select * from moviesdb.movies where industry="bollywood" order by imdb_rating limit 10;
select * from moviesdb.movies where industry="bollywood" order by imdb_rating limit 10 offset 1;
select * from moviesdb.movies order by release_year desc;
select * from moviesdb.movies where release_year=2022;
select * from moviesdb.movies where release_year>2020;
select * from moviesdb.movies where release_year>2020 and imdb_rating>8;
select * from moviesdb.movies where studio in ("Marvel studios","Hombale Films");
select * from moviesdb.movies where title like "%thor%" order by release_year;
select * from moviesdb.movies where studio!="Marvel Studios";
Select round(avg(imdb_rating)) from moviesdb.movies where studio="Marvel Studios";
Select min(imdb_rating), max(imdb_rating), round(avg(imdb_rating),2) as avgIMDB from moviesdb.movies where studio="Marvel Studios";
Select industry, count(*) from moviesdb.movies group by industry;
Select studio, count(*) as countt from moviesdb.movies group by studio order by countt desc;
Select * from moviesdb.movies where release_year between 2015 and 2022;
Select release_year, count(*) from moviesdb.movies group by release_year order by release_year;
Select release_year, count(*) from moviesdb.movies group by release_year;
Select max(release_year), min(release_year) from moviesdb.movies;
Select release_year, count(*) as countt from moviesdb.movies group by release_year having countt>2 order by release_year;

select * , year(curdate())-birth_year as age from moviesdb.actors order by age;
select *, (revenue-budget) as profit from moviesdb.financials;
select *, if(currency="usd", revenue*83, revenue) as revenue_INR from moviesdb.financials;
select * , 
Case
	when unit="thousands" then revenue/1000
    when unit="billions" then revenue*1000
    else revenue
End as revenue_million 
from moviesdb.financials;
Select *,round((((revenue-budget)/budget)*100)) as profit_percent from moviesdb.financials
select count(distinct imdb_rating), STDDEV(imdb_rating) from moviesdb.movies;

select m.movie_id, title, budget, revenue, currency, unit from movies m join financials f
on m.movie_id=f.movie_id

select m.movie_id, title, budget, revenue, currency, unit from movies m inner join financials f
on m.movie_id=f.movie_id

select m.movie_id, title, budget, revenue, currency, unit from movies m left join financials f
on m.movie_id=f.movie_id

select f.movie_id, title, budget, revenue, currency, unit from movies m right join financials f
on m.movie_id=f.movie_id

select f.movie_id, title, budget, revenue, currency, unit from movies m right join financials f
using(movie_id,movie_id) 

select m.movie_id, title, budget, revenue, currency, unit from movies m left join financials f
on m.movie_id=f.movie_id union
select f.movie_id, title, budget, revenue, currency, unit from movies m right join financials f
on m.movie_id=f.movie_id

select language_id, title, l.name from movies m join languages l using(language_id,language_id)

select language_id, title, l.name from movies left join languages l using(language_id,language_id)
where l.name="telugu"

select l.name, count(title) as numberOf from movies m join languages l using(language_id,language_id) group by language_id
select l.name, count(movie_id) as numberOf from movies m left join languages l using(language_id,language_id) group by language_id order by numberOf

Select *, concat(name, " ", variant_name) as fullName , (price+variant_price) as full_price from items cross join variants

select * , 
Case
	when unit="thousands" then revenue/1000
    when unit="billions" then revenue*1000
    else revenue
End as revenue_million 
from movies m join financials using(movie_id,movie_id) order by revenue_million desc;

select m.title, group_concat(a.name separator " , ") as actors 
from movies m 
join movie_actor ma on ma.movie_id=m.movie_id 
join actors a on a.actor_id=ma.actor_id 
group by m.movie_id;

select a.name, GROUP_CONCAT(m.title SEPARATOR ' | ') as moviess, COUNT(m.title) as num_movies 
from actors a 
join movie_actor ma on ma.actor_id=a.actor_id
join movies m on m.movie_id=ma.movie_id
group by a.actor_id

select m.title, f.revenue, f.currency, f.unit , 
case
	when unit="Billions" then revenue*1000
    else revenue
    end as revenueM
from financials f
join movies m on m.movie_id=f.movie_id
join languages l on l.language_id=m.language_id
where l.name="hindi"
order by revenueM;

returns a single value
Select * from movies where imdb_rating=(select max(imdb_rating) from movies)

returns a list of value
Select * from movies where imdb_rating in ((select max(imdb_rating) from movies),(select min(imdb_rating) from movies ))

returns a table
select * from (select name, year(curdate())-birth_year as age from actors) as actorsage where age>70 and age<80

select actors who acted in any pf these movies 101,110,121
Select * from actors where actor_id in(select actor_id from movie_actor where movie_id in(101,110,121))
Select * from actors where actor_id =Any(select actor_id from movie_actor where movie_id in(101,110,121))

select all movies whose rating is greater than any of the marvel movies rating
select * from movies where imdb_rating > any(select imdb_rating from movies where studio="marvel studios")
select * from movies where imdb_rating > any(select min(imdb_rating) from movies where studio="marvel studios")
select * from movies where imdb_rating > some(select min(imdb_rating) from movies where studio="marvel studios")

select all movies whose rating is greater than all of the marvel movies rating
select * from movies where imdb_rating > all(select imdb_rating from movies where studio="marvel studios")
select * from movies where imdb_rating > all(select max(imdb_rating) from movies where studio="marvel studios")

count number of movies actor actor acted 
select a.actor_id, name, count(*) as movie_count from movie_actor ma join actors a on a.actor_id=ma.actor_id
group by actor_id
order by movie_count desc

select 
	actor_id,
	name ,
	(select count(*) from movie_actor 
		where actor_id = actors.actor_id) as movie_count 
from actors

Select all the rows with minimum and max release year 
Select * from movies where release_year in ((select max(release_year) from movies),(select min(release_year) from movies ))

select all the rows from the movies table whose imdb_rating is higher than average rating
select * from movies where imdb_rating > all(select avg(imdb_rating) from movies where studio="marvel studios")
order by imdb_rating desc

with actors_age (actor_name, age) as (
	select name as x, year(curdate())-birth_year as y from actors)
select actor_name, age from actors_age where age>70 and age<85

movies that prodced 500% profit and their rating was less than avg rating of all movies
movies that produced 500% profit
select *, (revenue-budget)*100/budget as profit from financials where (revenue-budget)*100/budget>=500
movies rating less than avg rating
select * from movies where imdb_rating<(select avg(imdb_rating) from movies)

select * from (select *, (revenue-budget)*100/budget as profit from financials) x 
join (select * from movies where imdb_rating<(select avg(imdb_rating) from movies)) y
on x.movie_id=y.movie_id
where profit>500

with x as 
(select *, (revenue-budget)*100/budget as profit from financials ),
	y as 
    (select * from movies where imdb_rating<(select avg(imdb_rating) from movies))
select * from x join y 
on x.movie_id = y.movie_id
where profit>=500;

select all hollywood movies released after 2000 year and that made profit 500mln
select * from movies where release_year>2000 
select * , (revenue-budget)*100/budget as profit from financials where (revenue-budget)*100/budget>500 

select * from (select * from movies where release_year>2000) x join
(select * , (revenue-budget)*100/budget as profit from financials where (revenue-budget)*100/budget>500 ) y
on  
x.movie_id = y.movie_id
where industry="hollywood"

with x as (select * from movies where release_year>2000), 
y as (select * , (revenue-budget)*100/budget as profit from financials where (revenue-budget)*100/budget>500 )
select * from x join y
on x.movie_id = y.movie_id
where x.industry="hollywood"

