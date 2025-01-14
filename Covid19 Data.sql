-- Testing to see that our tables loaded properly

--Select *
--From test..CovidDeaths
--Where continent is not null
--order by 3, 4;

--Select *
--from test..CovidVaccinations
--order by 3, 4;

-- Querying data that we're actually going to use

Select location, date, total_cases, new_cases, total_deaths, population
From test..CovidDeaths
Where continent is not null
Order by 1,2

--Total cases vs Total deaths per country (Using US as an example)
--Calculates likelihood of dying after contracting Covid in a given location

Select location, date, total_cases, total_deaths, round((total_deaths * 100 / total_cases), 2) as death_rate
From test..CovidDeaths
Where location like '%States%' AND continent is not null
Order by 1, 2

--Calculating total cases compared to population of a given country (US example)

Select location, date, total_cases, population, round((total_cases *100 / population), 2) as case_rate
From test..CovidDeaths
Where location like '%States%' AND continent is not null
Order by 1, 2

--By the last day in this data, the US case rate was nearly 10%. Essentially, citizens in the US had a 1 in 10 chance of contracting Covid

--Now, let's look at the same data but with all locations

Select location, date, total_cases, population, round((total_cases *100 / population), 2) as case_rate
From test..CovidDeaths
Where continent is not null
Order by 1, 2

--Highest infection rates based on population

Select location, population, max(total_cases) as TotalInfections, max(round((total_cases * 100 / population), 2)) as case_rate
From test..CovidDeaths
Where continent is not null
Group by location, population
order by case_rate desc

--Calculating the highest death rates per population

Select location, population, max(cast(total_deaths as int)) as TotalDeaths, max(round((cast(total_deaths as int) * 100 / population), 2)) as death_rate
From test..CovidDeaths
Where continent is not null
Group by location, population
Order by TotalDeaths desc

--
--
--Looking at the data based on Continents

--Total death count per continent

Select location, max(cast(total_deaths as int)) as TotalDeaths
From test..CovidDeaths
Where continent is null
Group by location
Order by TotalDeaths desc

--Total population for each continent (excluding World)

Select location, population
From test..CovidDeaths
Where continent is null and location != 'World'
Group by location, population
Order by population desc;

--Infection rate of each continent
Select location, population, round((MAX(cast(total_cases as int)) / population) * 100, 3) as Case_rate
From test..CovidDeaths
Where continent is null AND location != 'International' AND location != 'World'
Group by location, population
Order by Case_rate desc;

--

Select continent, max(cast(total_cases as int)) as TotalCaseCount
From test..CovidDeaths
Where continent is not null
Group by continent;

--GLOBAL NUMBERS
--By date, how many new cases and new deaths occurred globally? 

Select date, sum(new_cases), sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/sum(new_cases) * 100 as deathpercentage
From test..CovidDeaths
Where continent is not null
Group by [date]
Order by 1, 2

--Joining deaths and vaccinations tables to perform queries
--Total new vaccines per day per location

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From test..CovidDeaths dea 
Join test..CovidVaccinations vac 
    ON dea.location = vac.location AND dea.date = vac.date 
Where dea.continent is not null
Order by 2, 3;

--Running total of new vaccines for all locations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
    sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinationsToDate
From test..CovidDeaths dea 
Join test..CovidVaccinations vac 
    ON dea.location = vac.location AND dea.date = vac.date 
Where dea.continent is not null
Order by 2, 3;

--Adding Percentage Vaccinated Using CTE

With PopVaxed (continent, location, date, population, new_vaccinations, TotalVaccinationsToDate)
as (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
    sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinationsToDate
From test..CovidDeaths dea 
Join test..CovidVaccinations vac 
    ON dea.location = vac.location AND dea.date = vac.date 
Where dea.continent is not null
)
Select *, (TotalVaccinationsToDate/population) * 100 as PercentVaxed
From PopVaxed
Where location = 'United States'


--Adding Percentage Vaxed using Temp Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations numeric,
    TotalVaccinationsToDate numeric)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
    sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinationsToDate
From test..CovidDeaths dea 
Join test..CovidVaccinations vac 
    ON dea.location = vac.location AND dea.date = vac.date 
Where dea.continent is not null

Select *, (TotalVaccinationsToDate/population) * 100 as PercentVaxed
From #PercentPopulationVaccinated
Where location = 'United States'

-- Creating Views from the Queries

Create View ContinentalCases as
Select continent, max(cast(total_cases as int)) as TotalCaseCount
From test..CovidDeaths
Where continent is not null
Group by continent


select *
From ContinentalCases

Create View PercentPopulationVaccinated
as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
    sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinationsToDate
From test..CovidDeaths dea 
Join test..CovidVaccinations vac 
    ON dea.location = vac.location AND dea.date = vac.date 
Where dea.continent is not null

