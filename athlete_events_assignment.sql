--1 . How many olympics games have been held?

select count(distinct games) from athlete_events

--2 . a) List down all Olympics games held so far.

select distinct games from athlete_events order by games

--b) list down all olympics in year-season-city format. (ex: 1960-summer-roma)

select  distinct CONCAT_WS('-',year,season,city) from athlete_events

--3 . Mention the total no of nations who participated in each olympics game?

select games,count(distinct NOC) as participants from athlete_events group by games order by games

--4 . Which year saw the highest and lowest no of countries participating in olympics?

with highest as 
(select year,count(distinct noc) as participant from athlete_events group by year)
select year,max(participant) as max_participant from highest group by year
having max(participant) = (select max(participant) from highest)

--second method
with highest as 
(select YEAR,count(distinct noc)participant from athlete_events group by Year)
select distinct FIRST_VALUE(year) over (order by participant desc) year,
FIRST_VALUE(participant) over (order by participant desc) country from highest

with lowest as 
(select year,count(distinct noc) as participant from athlete_events group by year)
select year,min(participant) as min_participant from lowest group by year
having min(participant) = (select min(participant) from lowest)

--second method

with lowest as 
(select YEAR,count(distinct noc)participant from athlete_events group by Year)
select distinct FIRST_VALUE(year) over (order by participant) year,
FIRST_VALUE(participant) over (order by participant) country from lowest


--5 . Which nation has participated in all of the olympic games?

select NOC as nations_participated from athlete_events 
group by NOC
having COUNT(distinct Games) = (select COUNT(distinct Games) from athlete_events)

--6 . Identify the sport which was played in all summer olympics.

select sport from athlete_events group by sport  having
count(distinct games) = ( select count(distinct games) from athlete_events where Season='summer')

--7 . Which Sports were just played only once in the olympics?

select sport from athlete_events group by sport having count(distinct games) =1

--8 . Fetch the total no of sports played in each olympic games.

select games,count(distinct sport) as total_sport from athlete_events group by games

--9 . Fetch details of the oldest athletes to win a gold medal.

select * from athlete_events where medal='gold' and age = (select max(age) from athlete_events where Medal='Gold')

--10 . Find the Ratio of male and female athletes participated in all olympic games.

with a as 
(select count(name) male from athlete_events where sex = 'M'),
b as 
(select count(name) female from athlete_events where sex = 'F')
select TRY_CONVERT(float,a.male)/TRY_CONVERT(float ,b.female) ratio  from a ,b


--11 . Fetch the top 5 athletes who have won the most gold medals.

select top 5 name , count(medal) as gold_medal from athlete_events where medal= 'gold'
group by name order by count(medal) desc


--12 . Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

select top 5 name,count(medal) as most_medal from athlete_events where medal in ('gold','silver','bronze')
group by name order by count(medal) desc

--13 . Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

select top 5 noc, count(medal) as most_medal from athlete_events where medal in ('gold','silver','bronze') 
group by noc order by count(medal) desc

--14 . List down total gold, silver and broze medals won by each country.

select noc , gold, silver, bronze from 
(select noc,medal,count(id) c from athlete_events where medal in ('gold','silver','bronze') group by noc ,medal ) x
pivot ( sum(c) for medal in (gold,silver,bronze)) as pt order by gold desc


--15. list down male and female participants in every olympic game.

select games,M as male,F as female from 
(select games,sex,count(id) c from athlete_events group by games,sex) x
pivot(sum(c) for sex in (M,F)) as PivotTable order by Games


select * from athlete_events


