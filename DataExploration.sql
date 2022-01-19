select *
from Portfolio..coviddeaths
where continent = 'north america' AND location = 'mexico'
order by 3,4;

select location, date, total_cases, new_cases, total_cases, population
from Portfolio..coviddeaths
order by 1,2;


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Portfolio..coviddeaths
where location like '%states%'
order by 1,2;


select location, date, population, total_cases, (total_cases/population)*100 as CasePercentage
from Portfolio..coviddeaths
where location like '%states%'
order by 1,2;

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio..coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio..coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio..coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc


select date, SUM(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Portfolio..coviddeaths
where continent is not null
group by date
order by 1,2;

select dea.continent, dea.location, dea.date, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location
, dea.date) as RollingPeopleVacc
from Portfolio..coviddeaths dea
Join Portfolio..Covidvacc vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

With PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPeopleVacc)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location
, dea.date) as RollingPeopleVacc
from Portfolio..coviddeaths dea
Join Portfolio..Covidvacc vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVacc/Population)*100
from PopvsVac

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVacc numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location
, dea.date) as RollingPeopleVacc
from Portfolio..coviddeaths dea
Join Portfolio..Covidvacc vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVacc/Population)*100
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location
, dea.date) as RollingPeopleVacc
from Portfolio..coviddeaths dea
Join Portfolio..Covidvacc vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
