# Covid-19 Professional Data Analytics Database

## Project Overview
This is an enterprise-grade Data Analytics Database project designed to analyze the global COVID-19 pandemic. Built entirely with **SQL**, it features a highly normalized Data Warehouse structure populated with comprehensive realistic data.

This system handles the full complexity of pandemic data, splitting it into 7 distinct tables to enable sophisticated cross-domain analysis.

## Key Features
-   **Pure SQL**: No external dependencies or scripts required.
-   **Professional Schema**: A 7-table normalized architecture (Star/Snowflake hybrid).
-   **Comprehensive Data**: Pre-populated with realistic data for major global economies.
-   **Advanced Analytics**: Complex joins and window functions to analyze Epidemiology, Vaccinations, and Healthcare capacity.
-   **Performance**: Optimized with Indexes and Foreign Keys.

## Database Structure
### Dimension Tables
-   **Countries**: Comprehensive metadata (Population, GDP, Age Structure, Health Infrastructure).

### Fact Tables
-   **Epidemiology**: Cases, Deaths, Reproduction Rate.
-   **Vaccinations**: Doses, People Vaccinated, Boosters.
-   **Testing**: Tests Conducted, Positive Rate.
-   **Hospitalizations**: ICU Patients, Hospital Admissions.
-   **Government_Response**: Stringency Index.
-   **Excess_Mortality**: Excess death estimates.

## Getting Started

### Prerequisites
-   A SQL Database (MySQL, PostgreSQL, etc.).

### Installation Steps
1.  **Create Database Schema**:
    Execute `schema.sql` to create the professional table structure.

2.  **Load Data**:
    Execute `seed_data.sql` to populate the database with realistic data.

3.  **Run Analysis**:
    Execute `queries.sql` to generate professional reports.

## Files Included
-   `schema.sql`: DDL for 7-table schema.
-   `seed_data.sql`: DML for data population.
-   `queries.sql`: Advanced analytical queries.
-   `introduction.txt`, `abstract.txt`, `conclusion.txt`: Detailed documentation.

## Author
**Ridda Maddni**
