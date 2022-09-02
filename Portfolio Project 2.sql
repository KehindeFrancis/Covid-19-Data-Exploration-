/*
Portfolio Project 2
*/

Select *
From [Project Portfolio 2].dbo.CovidDeaths

Select *
From [Project Portfolio 2].dbo.CovidVaccinations

Select *
From [Project Portfolio 2].dbo.CovidDeaths
where continent is not null
Order by 3,4

Select *
From [Project Portfolio 2].dbo.CovidVaccinations
order by 3,4

Select location, date, total_cases,new_cases,total_deaths,
   population
From [Project Portfolio 2].dbo.CovidDeaths
where continent is not null
order by 1,2

--Total Cases vs Total Deaths
--This indicates the likelihood of death if you contract covid in your country.
--In no particular orrder, in this case, the United States, Canada, the United Kingdom, Nigeria, and South Africa are considered. 

Select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%States%'
and continent is not null
order by 1,2

Select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%United Kingdom%'
and continent is not null
order by 1,2

Select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%Canada%'
and continent is not null
order by 1,2

Select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%Nigeria%'
and continent is not null
order by 1,2

Select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%South Africa%'
and continent is not null
order by 1,2


-- Total Cases vs Population 
-- Displays the percentage of the population who got Covid.
-- In no particular orrder, in this case, the United States, Canada, the United Kingdom, Nigeria, and South Africa are considered.

Select location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2

Select location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%Canada%'
and continent is not null
order by 1,2

Select location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%United Kingdom%'
and continent is not null
order by 1,2

Select location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%Nigeria%'
and continent is not null
order by 1,2

Select location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%South Africa%'
and continent is not null
order by 1,2

-- Countries with the highest infection rate in relation to population

Select continent, location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as 
   PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
where continent is not null
Group by continent, location, population
order by PercentPopulationInfected desc


-- Continents/Countries with the highest death rate per population

Select continent, location, Max(CONVERT(int,Total_deaths)) as TotalDeathCount
From [Project Portfolio 2].dbo.CovidDeaths
Where continent is not null
Group by continent,location
order by TotalDeathCount desc


-- The Global Death Case Count

Select date, Sum(new_cases) as total_cases,  Sum(CONVERT(int,new_deaths ))as total_deaths,
    Sum(cast(new_deaths as int))/Sum(new_cases)*100 as
	GlobalDeathPercentage
From [Project Portfolio 2]..CovidDeaths
Where continent is not null
Group by date
order by 1,2

Select Sum(new_cases) as total_cases,  Sum(cast(new_deaths as int))as total_deaths,
    Sum(cast(new_deaths as int))/Sum(new_cases)*100 as
	GlobalDeathPercentage
From [Project Portfolio 2]..CovidDeaths
Where continent is not null
order by 1,2


-- Comparing Total Population to Vaccinations

Select dea.continent, dea.location, dea.population,vac.new_vaccinations
,SUM(CONVERT(Bigint, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location
,dea.date) as RollingPeepsVaccinated
From [Project Portfolio 2]..CovidDeaths as dea
Join [Project Portfolio 2]..CovidVaccinations as vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
order by 1,2


-- USE CTE

With PopsvsVacc (continent, location, date, population, new_vaccinations, RollingPeepsVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,SUM(CONVERT (Bigint, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location
,dea.date) as RollingPeepsVaccinated
From [Project Portfolio 2]..CovidDeaths as dea
Join [Project Portfolio 2]..CovidVaccinations as vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeepsVaccinated/population)*100
From PopsvsVacc 


-- USE CTE

With PopsvsVacc (continent, location, date, population, new_vaccinations, RollingPeepsVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as Bigint)) Over (Partition by dea.location Order by dea.location
,dea.date) as RollingPeepsVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Project Portfolio 2].dbo.CovidDeaths as dea
Join [Project Portfolio 2].dbo.CovidVaccinations as vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
and new_vaccinations is not null
)
Select *, (RollingPeepsVaccinated/population)*100 RPVP
From PopsvsVacc


-- TEMP TABLE

 DROP Table if exists #PercerntPopVaccinated
 Create Table #PercerntPopVaccinated
 (
 continent nvarchar (255),
 loaction nvarchar (255),
 date datetime,
 population numeric, 
 new_vaccinations numeric,
 RollingPeepsVaccinated numeric
 )

 Insert into #PercerntPopVaccinated
 Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as Bigint)) Over (Partition by dea.location Order by dea.location
,dea.date) as RollingPeepsVaccinated
From [Project Portfolio 2]..CovidDeaths as dea
Join [Project Portfolio 2]..CovidVaccinations as vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingPeepsVaccinated/population)*100
From #PercerntPopVaccinated


--Creating a View to store data for future visualizations


Create View PercentPopVaccinated as 
 Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
 ,SUM(Cast(vac.new_vaccinations as Bigint)) Over (Partition by dea.location Order by dea.location
 ,dea.date) as RollingPopsVaccinated
 From [Project Portfolio 2]..CovidDeaths as dea
 Join [Project Portfolio 2]..CovidVaccinations as vac
     On dea.location = vac.location
	 and dea.date = vac.date
 Where dea.continent is not null

 Select *
 From PercentPopVaccinated


CREATE VIEW PopulationVsVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,SUM(CONVERT (Bigint, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location
,dea.date) as RollingPeepsVaccinated
From [Project Portfolio 2]..CovidDeaths as dea
Join [Project Portfolio 2]..CovidVaccinations as vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null

Select *
From PopulationVsVaccinated


CREATE VIEW GlobalDeathsCaseCount as
Select date, Sum(new_cases) as total_cases,  Sum(CONVERT(int,new_deaths ))as total_deaths,
    Sum(cast(new_deaths as int))/Sum(new_cases)*100 as
	GlobalDeathPercentage
From [Project Portfolio 2]..CovidDeaths
Where continent is not null
Group by date


CREATE VIEW HighestTotalDeathCount as 

Select continent, location, Max(CONVERT(int,Total_deaths)) as TotalDeathCount
From [Project Portfolio 2].dbo.CovidDeaths
Where continent is not null
Group by continent,location
-- order by TotalDeathCount desc

CREATE VIEW TotalCasesUnitedStates as
Select continent location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%states%'
and continent is not null
--order by 1,2


CREATE VIEW TotalCasesCanada as
Select continent, location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%Canada%'
and continent is not null
--order by 1,2


CREATE VIEW TotalCasesUnitedKingdom as
Select continent, location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%United Kingdom%'
and continent is not null
--order by 1,2


CREATE VIEW TotalCasesNigeria as
Select continent, location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%Nigeria%'
and continent is not null
--order by 1,2


CREATE VIEW TotalCasesSouthAfrica as
Select continent, location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From [Project Portfolio 2].dbo.CovidDeaths
Where location like '%South Africa%'
and continent is not null
--order by 1,2




