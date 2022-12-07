/*
 *	Research Questions
 */

/* 
 *	1. Have wages been rising in all industries over the years, or falling?
 *
 *	Answer: As we can see (according to SQL query below) not all industries have been rising. Although we can tell, except for those industries in particular years, that wages have been rising.
 */

SELECT DISTINCT 
	tlp1.branch_name AS Branch,
	tlp1.year_measurement AS Year,   
	tlp1.average_wage AS Average_Wage, 
	tlp2.year_measurement AS Comparative_Year, 
	tlp2.average_wage AS Comparative_Average_Wage, 
	ROUND((tlp2.average_wage - tlp1.average_wage) / tlp1.average_wage*100,2) AS Percentage_difference
	FROM t_long_phan_project_sql_primary_final tlp1
JOIN t_long_phan_project_sql_primary_final tlp2
	ON tlp1.branch_code = tlp2.branch_code
	AND tlp1.year_measurement = tlp2.year_measurement - 1
WHERE tlp2.average_wage < tlp1.average_wage
GROUP BY tlp1.year_measurement, tlp1.branch_name, tlp1.average_wage , tlp2.year_measurement , tlp2.average_wage 
ORDER BY tlp1.branch_name, tlp1.year_measurement;

-- Query with all compared branches and wages to compare with query above
SELECT DISTINCT 
	tlp1.branch_name AS Branch,
	tlp1.year_measurement AS Year,   
	tlp1.average_wage AS Average_Wage, 
	tlp2.year_measurement AS Comparative_Year, 
	tlp2.average_wage AS Comparative_Average_Wage, 
	ROUND((tlp2.average_wage - tlp1.average_wage) / tlp1.average_wage*100,2) AS Percentage_difference
	FROM t_long_phan_project_sql_primary_final tlp1
JOIN t_long_phan_project_sql_primary_final tlp2
	ON tlp1.branch_code = tlp2.branch_code
	AND tlp1.year_measurement = tlp2.year_measurement - 1
GROUP BY tlp1.year_measurement, tlp1.branch_name, tlp1.average_wage , tlp2.year_measurement , tlp2.average_wage 
ORDER BY tlp1.branch_name, tlp1.year_measurement;

/*
 *	2. How many liters of milk and kilograms of bread can be bought in the first and last comparable periods in the available price and wage dataset?
 *	
 *	Answer: For average wage in 2006 you could buy 1 257 Kg of bread and 1 404 l of milk. Despite of higher prices than year 2006, in year 2018 you could buy 1 317 Kg of bread and 1 611 l of milk.
 */

WITH t_long_phan_project_sql_primary_final AS (
  SELECT 
    CAST(average_food_price AS decimal (7, 2)) AS Food_price_2006, 
    food_name, 
    year_measurement, 
    Avg(average_wage) AS Average_Wage_2006,
    price_unit AS Unit
  FROM 
    t_long_phan_project_sql_primary_final 
  WHERE 
    food_name IN (
      'Mléko polotučné pasterované', 
      'Chléb konzumní kmínový'
    ) 
    AND year_measurement = 2006 
  GROUP BY 
    food_name, 
    year_measurement,
    Unit
), 
t_long_phan_project_sql_primary_final_2 AS (
  SELECT 
    CAST(average_food_price AS decimal (7, 2)) AS Food_price_2018, 
    food_name, 
    year_measurement, 
    Avg(average_wage) AS Average_Wage_2018
  FROM 
    t_long_phan_project_sql_primary_final_2 
  WHERE 
    food_name IN (
      'Mléko polotučné pasterované', 
      'Chléb konzumní kmínový'
    ) 
    AND year_measurement = 2018 
  GROUP BY 
    food_name, 
    year_measurement 
	) 
SELECT 
  tlp1.food_name, 
  Food_price_2006, 
  Food_price_2018, 
  Average_Wage_2006, 
  Average_Wage_2018, 
  Round(Average_Wage_2006 / Food_price_2006) AS Amount_2006, 
  Round(Average_Wage_2018 / Food_price_2018) AS Amount_2018,
  Unit
FROM 
  t_long_phan_project_sql_primary_final tlp1 
JOIN t_long_phan_project_sql_primary_final_2 tlp2 
  ON tlp1.food_name = tlp2.food_name 
GROUP BY 
  tlp1.food_name, 
  Food_price_2006, 
  Food_price_2018, 
  Average_Wage_2006, 
  Average_Wage_2018,
  Unit;
 
/*
 *	3. Which food category is increasing in a price the slowest (has the lowest percentage of year-on-year increase)?
 */



/*
 *	4. Has there been a year in which the year-on-year increase in food prices was significantly higher than wage growth (greater than 10%)?
 */
  


/*
 * 	5. Does the level of GDP affect changes in wages and food prices? Or, if the GDP increases more significantly in one year, will this be reflected in food prices or wages in the same or the following year by a more significant increase?
 */


