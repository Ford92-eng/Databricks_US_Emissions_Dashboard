-- ============================================
-- US Emissions Dashboard - Databricks SQL
-- ============================================

-- 1. Emissions per person
SELECT county_state_name,  
  population,
  CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE) / population as emissions_per_person
FROM emissions_data
ORDER BY emissions_per_person DESC
LIMIT 10


-- 2. Top 10 states and percentage of national emissions
WITH state_emissions AS (
  SELECT state_abbr,
    SUM(CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)) as Total_Emissions
  FROM emissions_data
  GROUP BY state_abbr
),
national AS (
  SELECT SUM(Total_Emissions) as National_Emissions FROM state_emissions
),
top10 AS (
  SELECT state_abbr, Total_Emissions
  FROM state_emissions
  ORDER BY Total_Emissions DESC
  LIMIT 10
)
SELECT state_abbr,
  Total_Emissions,
  ROUND(100 * Total_Emissions / National_Emissions, 2) as pct_of_national
FROM top10, national
ORDER BY Total_Emissions DESC;

WITH state_emissions AS (
  SELECT state_abbr,
    SUM(CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)) as Total_Emissions
  FROM emissions_data
  GROUP BY state_abbr
),
national AS (
  SELECT SUM(Total_Emissions) as National_Emissions FROM state_emissions
)
SELECT SUM(Total_Emissions) as top10_emissions,
  ROUND(100 * SUM(Total_Emissions) / MAX(National_Emissions), 2) as top10_pct_of_national
FROM (SELECT Total_Emissions FROM state_emissions ORDER BY Total_Emissions DESC LIMIT 10) top10, national;


-- 3. Top 10 counties by total emissions
SELECT county_state_name,  
  population,
  CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE) as Total_Emissions
FROM emissions_data
ORDER BY Total_Emissions DESC
LIMIT 10
