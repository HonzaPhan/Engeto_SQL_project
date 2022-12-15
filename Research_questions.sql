/*
 *	Research Questions
 */

/* 
 *	1. Have wages been rising in all industries over the years, or falling?
 *
 *	Answer: As we can see (according to SQL query below) not all industries have been rising. Although we can tell, except for those industries in particular years, that wages have been rising.
 */

SELECT DISTINCT 
	tlp1.branch_name AS branch,
	tlp1.year_measurement AS year,   
	tlp1.average_wage AS average_wage, 
	tlp2.year_measurement AS comparative_year, 
	tlp2.average_wage AS comparative_average_wage, 
	round((tlp2.average_wage - tlp1.average_wage) / tlp1.average_wage*100,2) AS percentage_difference
FROM t_long_phan_project_sql_primary_final tlp1
JOIN t_long_phan_project_sql_primary_final tlp2
	ON tlp1.branch_code = tlp2.branch_code
	AND tlp1.year_measurement = tlp2.year_measurement - 1
WHERE tlp2.average_wage < tlp1.average_wage
GROUP BY 
	tlp1.year_measurement, 
	tlp1.branch_name, 
	tlp1.average_wage, 
	tlp2.year_measurement, 
	tlp2.average_wage 
ORDER BY 
	tlp1.branch_name,
	tlp1.year_measurement;

-- Query with all compared branches and wages to compare with query above
SELECT DISTINCT 
	tlp1.branch_name AS branch,
	tlp1.year_measurement AS year,   
	tlp1.average_wage AS average_wage, 
	tlp2.year_measurement AS comparative_year, 
	tlp2.average_wage AS comparative_average_wage, 
	round((tlp2.average_wage - tlp1.average_wage) / tlp1.average_wage*100,2) AS percentage_difference
FROM t_long_phan_project_sql_primary_final tlp1
JOIN t_long_phan_project_sql_primary_final tlp2
	ON tlp1.branch_code = tlp2.branch_code
	AND tlp1.year_measurement = tlp2.year_measurement - 1
GROUP BY 
	tlp1.year_measurement, 
	tlp1.branch_name, 
	tlp1.average_wage, 
	tlp2.year_measurement, 
	tlp2.average_wage 
ORDER BY 
	tlp1.branch_name,
	tlp1.year_measurement;

/*
 *	2. How many liters of milk and kilograms of bread can be bought in the first and last comparable periods in the available price and wage dataset?
 *	
 *	Answer: For average wage in 2006 you could buy 1 257 Kg of bread and 1 404 l of milk. Despite of higher prices than year 2006, in year 2018 you could buy 1 317 Kg of bread and 1 611 l of milk.
 */

WITH t_long_phan_project_sql_primary_final AS (
  SELECT 
    cast(average_food_price AS decimal (7,2)) AS food_price_2006, 
    food_name, 
    year_measurement, 
    avg(average_wage) AS average_wage_2006,
    price_unit AS unit
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
    unit
), 
t_long_phan_project_sql_primary_final_2 AS (
  SELECT 
    cast(average_food_price AS decimal (7,2)) AS food_price_2018, 
    food_name, 
    year_measurement, 
    avg(average_wage) AS average_wage_2018
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
  food_price_2006, 
  food_price_2018, 
  average_wage_2006, 
  average_wage_2018, 
  round(average_wage_2006 / food_price_2006) AS amount_2006, 
  round(average_wage_2018 / food_price_2018) AS amount_2018,
  Unit
FROM 
  t_long_phan_project_sql_primary_final tlp1 
JOIN t_long_phan_project_sql_primary_final_2 tlp2 
  ON tlp1.food_name = tlp2.food_name 
GROUP BY 
  tlp1.food_name, 
  food_price_2006, 
  food_price_2018, 
  average_wage_2006, 
  average_wage_2018,
  unit;
 
/*
 *	3. Which food category is increasing in a price the slowest (has the lowest percentage of year-on-year increase)?
 *
 *	Answer: food category with the slowest year-on-year growth is granulated Sugar ("Krystalový cukr").
 *
 *	YoY = year-on-year
 */

SELECT 
  growth.food_name AS 'name_of_food', 
  round(avg(growth.difference_prices), 2) AS 'YoY_growth', 
  growth.Unit 
FROM ( 
	WITH t_long_phan_project_sql_primary_final AS (
      SELECT DISTINCT 
      	food_name, 
        average_food_price, 
        year_measurement, 
        price_unit 
      FROM 
        t_long_phan_project_SQL_primary_final
    ), 
    t_long_phan_project_sql_primary_final_2 AS (
      SELECT DISTINCT 
      	food_name, 
        average_food_price, 
        year_measurement, 
        price_unit 
      FROM 
        t_long_phan_project_SQL_primary_final_2
    ) 
    SELECT DISTINCT 
    	tlp1.food_name, 
     	round((tlp2.average_food_price - tlp1.average_food_price) / tlp1.average_food_price * 100,2) AS difference_prices, 
     	tlp1.year_measurement AS year_1, 
     	tlp2.year_measurement AS year_2, 
     	tlp1.price_unit AS unit 
    FROM 
      t_long_phan_project_sql_primary_final tlp1 
    JOIN t_long_phan_project_sql_primary_final_2 tlp2 
    	ON tlp1.food_name = tlp2.food_name 
     	AND tlp1.year_measurement = tlp2.year_measurement - 1 
    ORDER BY 
      difference_prices
   ) AS growth 
GROUP BY 
  growth.food_name, 
  growth.unit 
ORDER BY 
  avg(difference_prices) 
LIMIT 1; /* We want to know only food category, which has the lowest percentage of growth */

/*
 *	4. Has there been a year in which the year-on-year increase in food prices was significantly higher than wage growth (higher than 10%)?
 *	
 *	Answer: The values that correspond to the given task can be seen in the comparative years 2010 - 2012 and 2014-2016. We can tell that seen data are after Eurozone debt crisis in 2009.
 *
 *	YoY = year-on-year
 */

SELECT DISTINCT 
  year1 AS 'year', 
  year2 AS 'compared_year',
  difference_wages AS 'YoY_increase_wages_percentage', 
  difference_prices AS 'YoY_increase_prices_percentage' /*We care only about the highest difference between compared food prices */
FROM (
    WITH t_long_phan_project_sql_primary_final AS (
      SELECT 
        food_name AS name1, 
        year_measurement AS year1, 
        round(avg(average_food_price),2) AS price1, 
        round(avg(average_wage)) AS wage1 
      FROM 
        t_long_phan_project_sql_primary_final 
      GROUP BY 
        name1, 
        year1
    ), 
    t_long_phan_project_sql_primary_final_2 AS (
      SELECT
      	food_name AS name2, 
      	year_measurement AS year2, 
      	round(avg(average_food_price),2) AS price2, 
      	round(avg(average_wage),2) AS wage2 
      FROM 
      	t_long_phan_project_sql_primary_final_2 
      GROUP BY 
      	name2, 
      	year2
    ) 
    SELECT 
    	name1, 
    	year1, 
    	year2, 
    	wage1, 
    	wage2, 
    	price1, 
    	price2, 
    	round((price2 - price1) / price1 * 100,2) AS difference_prices, 
    	round((wage2 - wage1) / wage1 * 100,2) AS difference_wages
    FROM 
    	t_long_phan_project_sql_primary_final tlp1 
    LEFT JOIN t_long_phan_project_sql_primary_final_2 tlp2 
    	ON year1 = year2 - 1 
    	AND name1 = name2 
    WHERE 
    	year1 != 2018 /* In 2018 we do not have any data, so we just use negation*/
    GROUP BY 
    	name1, 
    	year1, 
    	year2, 
    	wage1, 
    	wage2, 
    	price1, 
    	price2
  ) AS diff
WHERE 
	difference_prices > difference_wages
GROUP BY 
	year, 
	compared_year,
	difference_wages
ORDER BY 
	year, 
	difference_prices;
 
/*
 * 	5. Does the level of gdp affect changes in wages and food prices? Or, if the gdp increases more significantly in one year, will this be reflected in food prices or wages in the same or the following year by a more significant increase?
 * 
 * 	Answer: The data shows that there is some correlation between these values, but there are large deviations, and therefore it cannot be concluded that a significant increase in gdp will necessarily be reflected in price or wage growth in the following year.
 */
CREATE 
OR REPLACE VIEW v_lp_all_difference AS WITH t_long_phan_project_SQL_primary_final AS (
	SELECT 
	    year_measurement, 
	    gdp, 
	    round(avg(average_food_price),2) AS avg_food_price, 
	    round(avg(average_wage),2) AS avg_wage 
	FROM 
	    t_long_phan_project_SQL_primary_final 
	WHERE 
		average_wage IS NOT NULL 
		AND average_food_price IS NOT NULL 
	GROUP BY 
		year_measurement
	) 
	SELECT 
		year_measurement, 
		avg_food_price, 
		avg_wage, 
		gdp, 
		lag(gdp) OVER (ORDER BY year_measurement) AS gdp_last_year, 
	 	lag(avg_wage) OVER (ORDER BY year_measurement) AS avg_wage_last_year, 
	 	lag(avg_food_price) OVER (ORDER BY year_measurement) AS avg_food_price_last_year 
	FROM 
		t_long_phan_project_SQL_primary_final;
	
SELECT
	year_measurement AS 'year', 
	gdp, 
	gdp_last_year, 
	round((gdp - gdp_last_year) / gdp * 100,2) AS gdp_in_percentages, 
	round((avg_food_price - avg_food_price_last_year) / avg_food_price * 100,2) AS avg_food_prices_difference_in_percentages, 
	round((avg_wage - avg_wage_last_year) / avg_wage * 100,2) AS avg_wage_difference_in_percentages 
FROM 
	v_lp_all_difference 
WHERE 
	gdp_last_year IS NOT NULL 
ORDER BY 
	'year';


