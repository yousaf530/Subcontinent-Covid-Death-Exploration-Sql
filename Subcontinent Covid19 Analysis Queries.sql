-- Select the required DB
	USE SubcontinentCovidDB;


-- Changing the Data Type of CovidDeaths.total_deaths column to FLOAT from nvarchar

	ALTER TABLE CovidDeaths
	Alter column total_deaths FLOAT;

-- Changing the Data Type of CovidVacinations.new_vaccinations column to FLOAT from nvarchar

	ALTER TABLE CovidVacinations
	Alter column new_vaccinations FLOAT;


-- Changing the Data Type of CovidVacinations.total_vaccinations column to FLOAT from nvarchar

	ALTER TABLE CovidVacinations
	Alter column total_vaccinations FLOAT;


-- Select whole dataset/table CovidDeaths
	
	SELECT *
	FROM CovidDeaths
	ORDER BY 3,4;

-- Select data that will be used most frequently for Subcontinent Countries and desired KPIs
	
	SELECT location, date, total_cases, new_cases,total_deaths, population
	FROM CovidDeaths
	WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	ORDER BY 1,2;


-- Having a look at the total number of data points/days data for each country
	
	SELECT location as 'Location' , COUNT(*) AS 'TotalDataPoints' FROM CovidDeaths
	WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	group by location
	ORDER BY 2 DESC;


-- Total Cases vs Total Deaths
	-- What percent of people from those who caught Covid ended up dying 
	
	SELECT location, date, total_cases, total_deaths, 'DeathPercentage' =
		CASE   
		  WHEN total_deaths IS NULL THEN 0   
		  ELSE ROUND(((total_deaths/total_cases) * 100),2)
		END
	FROM CovidDeaths
	WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	ORDER BY 1,2;

	-- Max Death Percentage for each Subcontinent Country
	
	SELECT location as 'Location',MAX(total_cases) as 'TotalCases', MAX(total_deaths) as 'TotalDeaths', MAX(ROUND(((total_deaths/total_cases) * 100),2)) as 'MaxDeathPercentage'
	FROM CovidDeaths
	WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	GROUP BY location
	ORDER BY 4 DESC;


-- Total Cases vs Population
	-- Having a look at what percentage of Population got Covid

	SELECT location, date, population, total_cases, ROUND(((total_cases/population) * 100),2) as 'PercentPopulationInfected'
	FROM CovidDeaths
	WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	ORDER BY 1,2;

	-- Max Cases/Infection Percentage for each Subcontinent Country
	
	SELECT location as 'Location', MAX(total_cases) as 'TotalCases', Max(population) as 'TotalPopulation' ,MAX(ROUND(((total_cases/population) * 100),2)) as 'MaxPercentPopulationInfected'
	FROM CovidDeaths
	WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	GROUP BY location
	ORDER BY 4 DESC;


-- Total Cases and Total Deaths in the Subcontinet Countries
	-- Sum of Max values for each country to find the total metrics

	SELECT SUM(TotalCases) as 'TotalCases', SUM(TotalDeaths) as 'TotalDeaths', ROUND(((SUM(TotalDeaths))/SUM(TotalCases))*100,2) as 'DeathPercentageSubContCountries'
	FROM (
	SELECT MAX(total_cases) AS 'TotalCases', MAX(total_deaths) AS 'TotalDeaths' 
	FROM CovidDeaths 
	WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	GROUP BY location) x;


	SELECT SUM(TotalCases) as 'TotalCases', SUM(TotalDeaths) as 'TotalDeaths', ROUND(((SUM(TotalDeaths))/SUM(TotalCases))*100,2) as 'DeathPercentageAsia'
	FROM (
	SELECT MAX(total_cases) AS 'TotalCases', MAX(total_deaths) AS 'TotalDeaths' 
	FROM CovidDeaths 
	WHERE continent = 'Asia' AND location NOT IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	GROUP BY location) x;


--Total subcontinent people who were vaccinated 
	SELECT death.location, death.date, death.date, death.population, vac.new_vaccinations, vac.total_vaccinations
	FROM CovidDeaths death
	INNER JOIN
	CovidVacinations vac
	ON death.location = vac.location AND death.date = vac.date
	WHERE death.location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	ORDER BY 1,2;
		

-- Total Population vs Total Vaccinations Ratio (Using Window Function and CTE's)

	WITH PopvsVac ( Location, Date, Population, New_Vaccinations, RollingTotalVaccinations) 
	as (
	SELECT death.location, death.date, death.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as 'RollingTotalVaccinations'
	FROM CovidDeaths death
	INNER JOIN
	CovidVacinations vac
	ON death.location = vac.location AND death.date = vac.date
	WHERE death.location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
	)
	 SELECT *, (RollingTotalVaccinations/Population) as 'PopulationVaccinatedRatio'
	 FROM PopvsVac;


-- Temp Table for Storing result of Above Query
	DROP TABLE IF EXISTS #PercentPopulationVaccinated
	-- Create Temp Table
	CREATE TABLE #PercentPopulationVaccinated
	(
	Location varchar(200),
	Date datetime,
	Population numeric,
	New_Vaccinations float,
	RollingTotalVaccinations float
	)

	-- Insert query result into Temp Table
	INSERT INTO #PercentPopulationVaccinated
	SELECT death.location, death.date, death.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as 'RollingTotalVaccinations'
	FROM CovidDeaths death
	INNER JOIN
	CovidVacinations vac
	ON death.location = vac.location AND death.date = vac.date
	WHERE death.location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')

	-- Query on Temp Table
	 SELECT Location, ROUND(MAX((RollingTotalVaccinations/Population)*100),2) as 'PopulationvsVaccinatedRatio'
	 FROM #PercentPopulationVaccinated
	 GROUP BY Location;


-- New Batch
GO

--Views
	CREATE VIEW WeeklyRollingAvgVaccinations
	AS
	SELECT death.location, death.date, death.population, vac.new_vaccinations, AVG(vac.new_vaccinations) OVER (ORDER BY death.location, death.date ROWS 7  PRECEDING) as '7DayRollingAvgVaccinations'
	FROM CovidDeaths death
	INNER JOIN
	CovidVacinations vac
	ON death.location = vac.location AND death.date = vac.date
	WHERE death.location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh');

-- New Batch
GO

	SELECT * FROM WeeklyRollingAvgVaccinations;

-- New Batch
GO

-- Stored Procedure to get total deaths percentage of the specified country

	CREATE PROCEDURE Total_Deaths 
	@Country varchar(50)
	AS
 	SELECT location as 'Location', ROUND(MAX(((total_deaths/total_cases) * 100)),2) as 'MaxDeathPercentage'
	FROM CovidDeaths
	WHERE location = @Country
	GROUP BY location;

	-- Execute Stored Procedure
	EXEC Total_Deaths @Country = 'Afghanistan'
	EXEC Total_Deaths @Country = 'Pakistan'