<h1> Engeto project in SQL </h1>
<p>In this project, I will be dealing with food comparisons of the general public based on average incomes over a certain period of time.</p>

<h3>Data sets that can be used to obtain a suitable data base</h3>
<p>The data set comes from the <a href = "https://data.gov.cz/english/"> Open Data Portal of the Czech Republic </a></p> 
<b>Primary tables:</b>
<ul>
  <li>czechia_payroll – Information on wages in various sectors over a period of several years. The data set comes from the Open Data Portal of the Czech Republic </li>
  <li>czechia_payroll_calculation – Index of calculations in the salary table </li>
  <li>czechia_payroll_industry_branch – Branch number in the salary table </li>
  <li>czechia_payroll_unit – Number of units of values in the salary table </li>
  <li>czechia_payroll_value_type – Index of value types in the salary table </li>
  <li>czechia_price – Information on the prices of selected foods over a period of several years. The data set comes from the Open Data Portal of the Czech Republic </li>
  <li> czechia_price_category – Index of food categories that appear in our overview </li>
</ul>  

<b>Codes of shared information about the Czech Republic:</b>
<ul>
<li>czechia_region – Code of the regions of the Czech Republic according to the CZ-NUTS 2 standard </li>
<li>czechia_district – Number list of districts of the Czech Republic according to the LAU standard </li>
</ul>

<b>Additional tables:</b>
<ul>
<li>countries - All kinds of information about countries in the world, for example the capital city, currency, national food or average height of the population </li>
<li>economies - GDP, GINI, tax burden, etc. for a given state and year </li>
</ul>

<h2>Reseach questions:</h2>
<ol>
<li>Have wages been rising in all industries over the years, or falling?</li>
<li>How many liters of milk and kilograms of bread can be bought in the first and last comparable periods in the available price and wage dataset?</li>
<li>Which food category is increasing in a price the slowest (has the lowest percentage of year-on-year increase)?</</li>
<li>Has there been a year in which the year-on-year increase in food prices was significantly higher than wage growth (greater than 10%)?</li>
<li>Does the level of GDP affect changes in wages and food prices? Or, if the GDP increases more significantly in one year, will this be reflected in food prices or wages in the same or the following year by a more significant increase?</li>
</ol>
