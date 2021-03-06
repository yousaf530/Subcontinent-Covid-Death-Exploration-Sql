<div id="top"></div>

# Welcome to Subcontinet Countries Covid19 Deaths Analysis using SQL


[![windows](https://img.shields.io/badge/os-windows-blue?style=flat-square)](#) [![made-with-t-sql](https://img.shields.io/badge/Made%20with-T--SQL-red?style=flat-square)](#) [![windows](https://img.shields.io/badge/-Microsoft%20SQL%20Server-orange?style=flat-square&logo=microsoft%20sql%20server&logoColor=white)](#)



<div align="center">  

  <p align="center">
    Exploration and Analysis of the data of confirmed deaths in the subcontinet countries using data provided by  <a href="https://ourworldindata.org/">Our World in Data</a> using T-SQL and MS SQL Server.
    <br />
    <a href="https://docs.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver16"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="#">View Demo</a>
    ·
    <a href="https://github.com/yousaf530/Subcontinent-Covid-Death-Exploration-Sql/issues">Report Bug</a>
    ·
    <a href="https://github.com/yousaf530/Subcontinent-Covid-Death-Exploration-Sql/blob/main/Subcontinent%20Covid19%20Analysis%20Queries.sql">View Queries</a>
  </p>
</div>

---

## Table of Contents

  - [Overview](#overview)
    - [Dataset](#dataset)
    - [Get Started](#get-started)
    - [Tech Stack](#tech-stack)
    - [Insights](#insights)
  - [Contribution Guidelines](#contribution-guidelines)
  - [Feedback](#feedback)
  - [Author Info](#author-info)

---

## Overview
The project is mainly about showcasing the data exploration, manipulation and analytical capabilities using SQL. Following SQL skills are used for writing queries for the exploration and analysis of provided COVID19 dataset specifically for Subcontinent countries.

> SQL Skills 

`Joins` | `CTE's` | `Temp Tables` | `Windows Functions` | `Aggregate Functions` | `Creating Views` | `STORED PROCEDURES` | `TYPE CASTING`

## Dataset
The data used in this project is publically available at this [link](https://ourworldindata.org/explorers/coronavirus-data-explorer?zoomToSelection=true&time=2020-03-01..latest&facet=none&pickerSort=desc&pickerMetric=total_deaths&hideControls=true&Metric=Confirmed+deaths&Interval=7-day+rolling+average&Relative+to+Population=true&Color+by+test+positivity=false&country=IND~USA~GBR~CAN~DEU~FRA) and can be downloaded in csv format.

The list of countries included in the analysis is given below:


<ol>
  <li>India</li>
  <li>Bhutan</li>
  <li>Maldives</li>
  <li>Sri Lanka</li>
  <li>Nepal</li>
  <li>Bangladesh</li>
  <li>Pakistan</li>
</ol>

## Get Started
To get the database on your system and test and run the queries, you will need to have SQL Server and SSMS installed on your system. Then you can follow these steps:
- Import the Excel files in the Excel Data folder into the SSMS using the process mentioned [here](https://docs.microsoft.com/en-us/sql/relational-databases/import-export/import-data-from-excel-to-sql?view=sql-server-ver16)
- Open the `Subcontinent Covid19 Analysis Queries.sql` file in SSMS and run the queries in the given sequence.

## Tech Stack
- Microsoft SQL Server 2019 (RTM) - 15.0.2000.5 (X64)
- SQL Server Management Studio v18.12.1


## Insights
<details>
  <summary>Max Death Percentage for each Subcontinent Country</summary>

  > Result

  <img src="https://user-images.githubusercontent.com/45168689/177030245-da71e7e4-4289-4b1c-a192-fbcee4b20a74.png"/>

   > Query

```
SELECT location as 'Location',MAX(total_cases) as 'TotalCases', MAX(total_deaths) as 'TotalDeaths', MAX(ROUND(((total_deaths/total_cases) * 100),2)) as 'MaxDeathPercentage'
FROM CovidDeaths
WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
GROUP BY location
ORDER BY 4 DESC;
```
</details>

<details>
  <summary>Max Cases/Infection Ratio for each Subcontinent Country</summary>

  > Result

  <img src="https://user-images.githubusercontent.com/45168689/177030551-5fef5a70-741c-470a-8160-5d0456396729.png"/>

   > Query

```
SELECT location as 'Location', MAX(total_cases) as 'TotalCases', Max(population) as 'TotalPopulation' ,MAX(ROUND(((total_cases/population) * 100),2)) as 'MaxPercentPopulationInfected'
FROM CovidDeaths
WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
GROUP BY location
ORDER BY 4 DESC;
```
</details>

<details>
  <summary>Comparison Death Ratio Subcontinent vs Rest of Asia</summary>

  > Result

  <img src="https://user-images.githubusercontent.com/45168689/177031737-3a929324-195f-49ff-bb36-bb952990fb32.png"/>

   > Query

```
SELECT SUM(TotalCases) as 'TotalCases', SUM(TotalDeaths) as 'TotalDeaths', ROUND(((SUM(TotalDeaths))/SUM(TotalCases))*100,2) as 'DeathPercentageSubContCountries'
FROM (
SELECT MAX(total_cases) AS 'TotalCases', MAX(total_deaths) AS 'TotalDeaths' 
FROM CovidDeaths 
WHERE location IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
GROUP BY location) x;
```

```
SELECT SUM(TotalCases) as 'TotalCases', SUM(TotalDeaths) as 'TotalDeaths', ROUND(((SUM(TotalDeaths))/SUM(TotalCases))*100,2) as 'DeathPercentageAsia'
FROM (
SELECT MAX(total_cases) AS 'TotalCases', MAX(total_deaths) AS 'TotalDeaths' 
FROM CovidDeaths 
WHERE continent = 'Asia' AND location NOT IN ('India', 'Pakistan', 'Bhutan','Maldives','Sri Lanka','Nepal','Bangladesh')
GROUP BY location) x;
```
</details>


---

## Project Structure

```
Subcontinent-Covid-Death-Exploration-Sql
├── Data Files
│   ├── CovidDeaths.xlsx
│   └── CovidVaccinations.xlsx
├── README.md
└── Subcontinent Covid19 Analysis Queries.sql
```
---
## Contribution Guidelines

Thanks for your interest in my project. Have a great tip or optimizations that you want to add? Follow the steps:
- Fork the repository and create your branch from main.
- Issue that pull request!
- Always add a README and/or requirements.txt to your added code.

<a href="#top">Back To The Top</a>

---


## Feedback

Issues with template? Found a bug? Have a great idea for an addition? Feel free to file an issue.

<a href="#top">Back To The Top</a>

---

## Author Info

- Email - [yousafsaddique523@gmail.com](#)
- Github - [@yousaf530](https://github.com/yousaf530)
- LinkedIn - [Muhammad Yousaf Saddique](https://www.linkedin.com/in/yousaf530/)

<a href="#top">Back To The Top</a>

Enjoy!

