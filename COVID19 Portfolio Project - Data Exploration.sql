/*
Covid 19 Data Exploration 
From the beginning of the pandemic until October 3rd 2023
*/

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From COVID_10_2023..CovidDeaths
Where continent is not null 
order by 1,2


-- The most infected days of new cases in sudan
Select top(20) new_cases, date
From COVID_10_2023..CovidDeaths
Where location = 'sudan'
Order By new_cases desc


-- the most days of new deaths in sudan
Select top(20) new_deaths, date, location
From COVID_10_2023..CovidDeaths
Where location = 'sudan'
Order By new_deaths desc



-- total cases vs total deaths
-- Shows likelihood of dying if you contract covid in Sudan
Select Location, date, cast(total_cases as float) total_cases , total_deaths, (total_deaths/cast(total_cases as float))*100 as DeathPercentage
From COVID_10_2023..CovidDeaths
Where location = 'sudan'
Order By 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From CovidDeaths
where Location='sudan'
Order By 1,2


-- Countries with Highest Infection Rate compared to Population
Select Location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/population)*100 as PercentPopulationInfected
From CovidDeaths
--where Location='sudan'
Group by Location, population
Order By PercentPopulationInfected desc


-- Countries with Highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths
--where Location='sudan'
Where continent is not null 
Group by Location
Order By TotalDeathCount desc


-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths
--where Location='sudan'
Where continent is not null 
Group by continent
Order By TotalDeathCount desc


-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From COVID_10_2023..CovidDeaths
--where Location='sudan'
Where continent is not null 
Order By 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From COVID_10_2023..CovidDeaths dea
Join COVID_10_2023..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location = 'sudan'
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query
-- I use to write ony Qatar because all the data of all the countries are so big and they can't give a result

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From COVID_10_2023..CovidDeaths dea
Join COVID_10_2023..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location = 'qatar'
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From COVID_10_2023..CovidDeaths dea
Join COVID_10_2023..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 