/* Additional data on other European countries in the same period as the primary overview for the Czech Republic */

CREATE 
OR REPLACE TABLE t_long_phan_project_SQL_secondary_final AS (
  SELECT DISTINCT 
  	e.country, 
    c.country, 
    e.`Year`, 
    tlp.year_measurement, 
    e.GDP, 
    e.gini, 
    e.population 
  FROM 
    economies e 
    LEFT JOIN countries c ON e.country = c.country 
    LEFT JOIN t_long_phan_project_sql_primary_final tlp ON e.`Year` = tlp.year_measurement
  WHERE 
    c.continent = 'Europe' 
    AND c.country != 'Czech Republic' 
    AND e.`Year` BETWEEN 2006 AND 2018 
  ORDER BY 
    e.`Year`, 
    GDP DESC
);