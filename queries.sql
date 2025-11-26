-- Covid 19 Professional Data Analytics - Analytical Queries
-- Author: Antigravity
-- Date: 2025-11-26

-- 1. Global Impact Summary
-- Total cases, deaths, and vaccinations worldwide
SELECT
    SUM(e.new_cases) AS global_total_cases,
    SUM(e.new_deaths) AS global_total_deaths,
    SUM(v.new_vaccinations) AS global_total_vaccinations
FROM Epidemiology e
LEFT JOIN Vaccinations v ON e.iso_code = v.iso_code AND e.date = v.date
WHERE e.iso_code NOT LIKE 'OWID_%'; -- Exclude aggregates

-- 2. Vaccination vs. Mortality Rate (Top 20 Countries by GDP)
-- Analyze if higher vaccination rates correlate with lower mortality
SELECT
    c.location,
    c.gdp_per_capita,
    MAX(v.people_fully_vaccinated) / c.population * 100 AS pct_fully_vaccinated,
    SUM(e.new_deaths) / SUM(e.new_cases) * 100 AS case_fatality_rate
FROM Countries c
JOIN Epidemiology e ON c.iso_code = e.iso_code
LEFT JOIN Vaccinations v ON c.iso_code = v.iso_code AND e.date = v.date
WHERE c.iso_code NOT LIKE 'OWID_%' AND c.population > 1000000
GROUP BY c.location, c.gdp_per_capita, c.population
ORDER BY c.gdp_per_capita DESC
LIMIT 20;

-- 3. ICU Capacity Strain
-- Identify days where ICU patients exceeded 50% of estimated capacity (using hospital beds as proxy)
-- Note: This is a rough proxy as ICU beds are a fraction of total beds
SELECT
    c.location,
    h.date,
    h.icu_patients,
    c.hospital_beds_per_thousand * (c.population / 1000) AS est_total_beds,
    h.icu_patients / (c.hospital_beds_per_thousand * (c.population / 1000)) * 100 AS icu_load_pct
FROM Hospitalizations h
JOIN Countries c ON h.iso_code = c.iso_code
WHERE h.icu_patients IS NOT NULL AND c.hospital_beds_per_thousand IS NOT NULL
ORDER BY icu_load_pct DESC
LIMIT 20;

-- 4. Stringency Index vs. New Cases (Time Lag Analysis)
-- Compare government stringency with new cases 2 weeks later
SELECT
    g.iso_code,
    g.date AS policy_date,
    g.stringency_index,
    LEAD(e.new_cases, 14) OVER (PARTITION BY g.iso_code ORDER BY g.date) AS cases_14_days_later
FROM Government_Response g
JOIN Epidemiology e ON g.iso_code = e.iso_code AND g.date = e.date
WHERE g.iso_code = 'USA' -- Example for USA
ORDER BY g.date DESC
LIMIT 50;

-- 5. Excess Mortality Analysis
-- Countries with highest excess mortality percentage
SELECT
    c.location,
    MAX(em.excess_mortality_cumulative) AS max_excess_mortality_pct
FROM Excess_Mortality em
JOIN Countries c ON em.iso_code = c.iso_code
WHERE c.iso_code NOT LIKE 'OWID_%'
GROUP BY c.location
ORDER BY max_excess_mortality_pct DESC
LIMIT 10;

-- 6. Testing Efficiency
-- Countries with best positive rate (lower is better) with high testing volume
SELECT
    c.location,
    SUM(t.new_tests) AS total_tests_conducted,
    AVG(t.positive_rate) * 100 AS avg_positive_rate_pct
FROM Testing t
JOIN Countries c ON t.iso_code = c.iso_code
WHERE t.date > '2021-01-01' AND c.population > 5000000
GROUP BY c.location
HAVING total_tests_conducted > 1000000
ORDER BY avg_positive_rate_pct ASC
LIMIT 10;
