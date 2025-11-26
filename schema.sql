-- Covid 19 Professional Data Analytics Database Schema
-- Author: Antigravity
-- Date: 2025-11-26

-- Drop tables if they exist (Order matters due to FKs)
DROP TABLE IF EXISTS Excess_Mortality;
DROP TABLE IF EXISTS Government_Response;
DROP TABLE IF EXISTS Hospitalizations;
DROP TABLE IF EXISTS Testing;
DROP TABLE IF EXISTS Vaccinations;
DROP TABLE IF EXISTS Epidemiology;
DROP TABLE IF EXISTS Countries;

-- 1. Countries Table (Dimension)
CREATE TABLE Countries (
    iso_code VARCHAR(10) PRIMARY KEY,
    continent VARCHAR(50),
    location VARCHAR(100) NOT NULL,
    population BIGINT,
    population_density DECIMAL(10, 3),
    median_age DECIMAL(5, 2),
    aged_65_older DECIMAL(5, 3),
    aged_70_older DECIMAL(5, 3),
    gdp_per_capita DECIMAL(15, 2),
    extreme_poverty DECIMAL(5, 2),
    cardiovasc_death_rate DECIMAL(10, 3),
    diabetes_prevalence DECIMAL(5, 2),
    handwashing_facilities DECIMAL(10, 3),
    hospital_beds_per_thousand DECIMAL(10, 3),
    life_expectancy DECIMAL(5, 2),
    human_development_index DECIMAL(5, 3)
);

-- 2. Epidemiology Table (Fact)
CREATE TABLE Epidemiology (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    iso_code VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    total_cases BIGINT,
    new_cases INT,
    new_cases_smoothed DECIMAL(15, 3),
    total_deaths BIGINT,
    new_deaths INT,
    new_deaths_smoothed DECIMAL(15, 3),
    reproduction_rate DECIMAL(5, 2),
    FOREIGN KEY (iso_code) REFERENCES Countries(iso_code) ON DELETE CASCADE,
    UNIQUE KEY unique_epi (iso_code, date)
);

-- 3. Vaccinations Table (Fact)
CREATE TABLE Vaccinations (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    iso_code VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    total_vaccinations BIGINT,
    people_vaccinated BIGINT,
    people_fully_vaccinated BIGINT,
    total_boosters BIGINT,
    new_vaccinations INT,
    FOREIGN KEY (iso_code) REFERENCES Countries(iso_code) ON DELETE CASCADE,
    UNIQUE KEY unique_vax (iso_code, date)
);

-- 4. Testing Table (Fact)
CREATE TABLE Testing (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    iso_code VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    total_tests BIGINT,
    new_tests INT,
    positive_rate DECIMAL(5, 4),
    tests_per_case DECIMAL(10, 1),
    FOREIGN KEY (iso_code) REFERENCES Countries(iso_code) ON DELETE CASCADE,
    UNIQUE KEY unique_test (iso_code, date)
);

-- 5. Hospitalizations Table (Fact)
CREATE TABLE Hospitalizations (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    iso_code VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    icu_patients INT,
    hosp_patients INT,
    weekly_icu_admissions INT,
    weekly_hosp_admissions INT,
    FOREIGN KEY (iso_code) REFERENCES Countries(iso_code) ON DELETE CASCADE,
    UNIQUE KEY unique_hosp (iso_code, date)
);

-- 6. Government_Response Table (Fact)
CREATE TABLE Government_Response (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    iso_code VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    stringency_index DECIMAL(5, 2),
    FOREIGN KEY (iso_code) REFERENCES Countries(iso_code) ON DELETE CASCADE,
    UNIQUE KEY unique_gov (iso_code, date)
);

-- 7. Excess_Mortality Table (Fact)
CREATE TABLE Excess_Mortality (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    iso_code VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    excess_mortality DECIMAL(10, 2),
    excess_mortality_cumulative DECIMAL(10, 2),
    FOREIGN KEY (iso_code) REFERENCES Countries(iso_code) ON DELETE CASCADE,
    UNIQUE KEY unique_excess (iso_code, date)
);

-- Indexes for Performance
CREATE INDEX idx_epi_date ON Epidemiology(date);
CREATE INDEX idx_vax_date ON Vaccinations(date);
CREATE INDEX idx_test_date ON Testing(date);
CREATE INDEX idx_hosp_date ON Hospitalizations(date);
