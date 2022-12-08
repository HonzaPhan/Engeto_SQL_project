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
    AVG(average_wage) AS Average_Wage_2006,
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
    AVG(average_wage) AS Average_Wage_2018
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
  ROUND(Average_Wage_2006 / Food_price_2006) AS Amount_2006, 
  ROUND(Average_Wage_2018 / Food_price_2018) AS Amount_2018,
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
 *
 *	Answer: Food category with the slowest year-on-year growth is granulated Sugar ("Krystalový cukr").
 *
 *	YoY = year-on-year
 */

SELECT 
  growth.food_name AS 'Name_of_food', 
  ROUND(AVG(growth.Difference_prices), 2) AS 'YoY_growth', 
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
     	ROUND((tlp2.average_food_price - tlp1.average_food_price) / tlp1.average_food_price * 100, 2) AS Difference_prices, 
     	tlp1.year_measurement AS Year_1, 
     	tlp2.year_measurement AS Year_2, 
     	tlp1.price_unit AS Unit 
    FROM 
      t_long_phan_project_sql_primary_final tlp1 
    JOIN t_long_phan_project_sql_primary_final_2 tlp2 
    	ON tlp1.food_name = tlp2.food_name 
     	AND tlp1.year_measurement = tlp2.year_measurement - 1 
    ORDER BY 
      Difference_prices
   ) AS Growth 
GROUP BY 
  growth.food_name, 
  growth.unit 
ORDER BY 
  AVG(Difference_prices) 
LIMIT 1; /* We want to know only food category, which has the lowest percentage of growth */

/*
 *	4. Has there been a year in which the year-on-year increase in food prices was significantly higher than wage growth (higher than 10%)?
 *	
 *	Answer: The values that correspond to the given task can be seen in the comparative years 2010 - 2012 and 2014-2016. We can tell that seen data are after Eurozone debt crisis in 2009.
 *
 *	YoY = year-on-year
 */

SELECT DISTINCT 
  Year1 AS 'Year', 
  Year2 AS 'Compared_Year',
  Difference_wages AS 'YoY_increase_wages_percentage', 
  Difference_prices AS 'YoY_increase_prices_percentage' /*We care only about the highest difference between compared food prices */
FROM (
    WITH t_long_phan_project_sql_primary_final AS (
      SELECT 
        food_name AS Name1, 
        year_measurement AS Year1, 
        ROUND(AVG(average_food_price), 2) AS Price1, 
        ROUND(AVG(average_wage)) AS Wage1 
      FROM 
        t_long_phan_project_sql_primary_final 
      GROUP BY 
        name1, 
        year1
    ), 
    t_long_phan_project_sql_primary_final_2 AS (
      SELECT
      	food_name AS Name2, 
      	year_measurement AS Year2, 
      	ROUND(AVG(average_food_price), 2) AS Price2, 
      	ROUND(AVG(average_wage)) AS Wage2 
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
    	Wage1, 
    	Wage2, 
    	price1, 
    	price2, 
    	ROUND((Price2 - Price1) / Price1 * 100, 2) AS Difference_prices, 
    	ROUND((Wage2 - Wage1) / Wage1 * 100, 2) AS Difference_wages
    FROM 
    	t_long_phan_project_sql_primary_final tlp1 
    LEFT JOIN t_long_phan_project_sql_primary_final_2 tlp2 
    	ON Year1 = Year2 - 1 
    	AND Name1 = Name2 
    WHERE 
    	Year1 != 2018 /* In 2018 we do not have any data, so we just use negation*/
    GROUP BY 
    	name1, 
    	year1, 
    	year2, 
    	Wage1, 
    	Wage2, 
    	price1, 
    	price2
  ) AS diff
WHERE 
	Difference_prices > Difference_wages
GROUP BY 
	Year, 
	Compared_Year,
	Difference_wages
ORDER BY 
	Year, 
	Difference_prices;
 
/*
 * 	5. Does the level of GDP affect changes in wages and food prices? Or, if the GDP increases more significantly in one year, will this be reflected in food prices or wages in the same or the following year by a more significant increase?
 * 
 * 	Answer: The data shows that there is some correlation between these values, but there are large deviations, and therefore it cannot be concluded that a significant increase in GDP will necessarily be reflected in price or wage growth in the following year.
 */
CREATE 
OR REPLACE VIEW v_lp_all_difference AS WITH t_long_phan_project_SQL_primary_final AS (
	SELECT 
	    year_measurement, 
	    GDP, 
	    ROUND(AVG(average_food_price),2) AS avg_food_price, 
	    ROUND(AVG(average_wage)) AS avg_wage 
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
		LAG(GDP) OVER (ORDER BY year_measurement) AS GDP_last_year, 
	 	LAG(avg_wage) OVER (ORDER BY year_measurement) AS avg_wage_last_year, 
	 	LAG(avg_food_price) OVER (ORDER BY year_measurement) AS avg_food_price_last_year 
	FROM 
		t_long_phan_project_SQL_primary_final;
	
SELECT
	year_measurement AS 'Year', 
	gdp, 
	GDP_last_year, 
	ROUND((GDP - GDP_last_year) / GDP * 100, 2) AS GDP_in_percentages, 
	ROUND((avg_food_price - avg_food_price_last_year) / avg_food_price * 100, 2) AS AVG_food_prices_difference_in_percentages, 
	ROUND((avg_wage - avg_wage_last_year) / avg_wage * 100, 2) AS AVG_Wage_difference_in_percentages 
FROM 
	v_lp_all_difference 
WHERE 
	GDP_last_year IS NOT NULL 
ORDER BY 
	'Year';


