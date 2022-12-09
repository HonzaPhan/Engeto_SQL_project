/* Primary table (food prices and wages by branches) serving as the dataset for the research questions */

CREATE 
OR REPLACE TABLE t_long_phan_project_sql_primary_final AS WITH food_prices AS (
  SELECT 
    cpc.NAME AS food_name, 
    cpc.code, 
    cpc.price_value, 
    cpc.price_unit, 
    AVG(cp.value) AS average_food_price, 
    YEAR(cp.date_from) AS year_measurement
  FROM 
    czechia_price cp 
    LEFT JOIN czechia_price_category cpc ON cp.category_code = cpc.code 
  WHERE 
    cp.region_code IS NULL 
  GROUP BY 
    food_name, 
    cpc.price_value, 
    cpc.code, 
    cpc.price_unit, 
    year_measurement
), 
wage AS (
  SELECT 
    AVG(czp.value) AS average_wage, 
    cpib.code AS branch_code, 
    cpib.NAME AS branch_name, 
    czp.payroll_year 
  FROM 
    czechia_payroll czp 
    LEFT JOIN czechia_payroll_industry_branch cpib ON czp.industry_branch_code = cpib.code 
  WHERE 
    czp.value_type_code = 5958 /* Average gross salary per employee */ 
    AND czp.calculation_code = 100 /* Type of calculation of the wage */
  GROUP BY 
    branch_name, 
    czp.payroll_year, 
    cpib.code
) 
SELECT 
  w.branch_code,
  w.branch_name,
  w.average_wage, 
  fp.year_measurement, 
  e.gdp, 
  fp.code AS food_category_code, 
  fp.food_name, 
  fp.average_food_price, 
  fp.price_value, 
  fp.price_unit 
  
FROM 
  food_prices fp 
  LEFT JOIN wage w ON fp.year_measurement = w.payroll_year 
  LEFT JOIN economies e ON year_measurement = e.`year` 
  AND e.country = 'Czech republic' 
ORDER BY 
  fp.year_measurement;