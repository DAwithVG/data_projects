--% of deaths per total cases reported
select location,date,total_cases,total_deaths,round((total_deaths/total_cases)*100,2)as 'death_percentage' from 
Covid_deaths
where location  = 'India'
order by 1,2

-- as of 08-04-2024 in india you have a 1.18% chance of dying if you are infected by corona virus


--percenage of indian population that got infected by covid
select location,date,total_cases,population,round((total_cases/population)*100,4)as 'infected_percentage' from 
Covid_deaths
where location  = 'India'
order by 1,2

--countries list which shows the highest %infected people at a single point of time
select location,population,max(total_cases) as max_cases,max(round((total_cases/population)*100,4))as 'max_infected_percentage' from 
Covid_deaths
group by location,population
--Having location  = 'Andorra'
order by 4 desc


-- countries with highest death count
select location,max(total_deaths) as total_deaths from Covid_deaths
where continent is not null
group by location
order by 2 desc
-- the top 3 countries with highest death counts are USA,Brazil,India

-- showing continents with highest death count
select location,max(total_deaths) as total_deaths from Covid_deaths
where continent is null
group by location
order by 2 desc


-- To find the total  number of vaccination provided till a particular date 
with cte as (SELECT cd.continent,cd.location,cd.date,population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as float)) over(partition by cd.location order by cd.location,cd.date) as rolling_sum from Portfolio_database..Covid_deaths as cd
join  Portfolio_database..Covid_vaccinations as cv on cd.date = cv.date
and cv.location = cd.location
where cd.continent is not null
)

select *,(rolling_sum/population)*100 as percent_population_vaccinated
from cte
where location  = 'India'
order by location,date

-- As of 06/01/2022 100% of india's population was vaccinated


--creating views for visualizations

create view  percent_population_vaccinated as SELECT cd.continent,cd.location,cd.date,population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as float)) over(partition by cd.location order by cd.location,cd.date) as rolling_sum from Portfolio_database..Covid_deaths as cd
join  Portfolio_database..Covid_vaccinations as cv on cd.date = cv.date
and cv.location = cd.location
where cd.continent is not null

select * from percent_population_vaccinated 




