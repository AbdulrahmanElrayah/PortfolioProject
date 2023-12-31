--1

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From COVID_10_2023..CovidDeaths
--Where location like '%sudan%'
where continent is not null 
--Group By date
order by 1,2

--2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From COVID_10_2023..CovidDeaths
--Where location like '%sudan%'
Where continent is null 
and location not in ('World', 'European Union', 'International','High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc

--3

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From COVID_10_2023..CovidDeaths
--Where location like '%sudans%'
Where continent is not null
Group by Location, Population
order by PercentPopulationInfected desc


--4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From COVID_10_2023..CovidDeaths
--Where location like '%sudan%'
Group by Location, Population, date
order by PercentPopulationInfected desc


--5

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From COVID_10_2023..CovidDeaths
--Where location like '%sudan%'
Where continent is null 
and location  in ('High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc
