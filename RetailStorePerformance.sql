/* The dataset named as "Retail Store Performance" is found at https://www.kaggle.com/datasets/pereprosov/retail-store-performance.
Here you will find proposed business questions along with attempts to address them with SQL.

Built with: SQLite
Skills used: Common Table Expressions, Joins, Window Functions, Aggregate Functions  */


/* Question 1
Stores need to be selected for renovation to improve competitiveness */

-- criteria 1: store age > 25
-- criteria 2: monthly revenue ($ k) > average revenue
-- criteria 3: distance with competitor < 10

select storeage, monthlysalesrevenue, round((select avg(monthlysalesrevenue) from Store_CA),2) as average_revenue, competitordistance, storelocation, storecategory
from Store_CA
where storeage > 25 
  and monthlysalesrevenue < average_revenue 
  and competitordistance <= 10 


/* Question 2
Is additional manpower necessary? If yes, for which stores? */

-- Suppose employee efficiency score lower than 60 is considered as low efficiency

select storesize, employeeefficiency, monthlysalesrevenue, storelocation, storecategory
from Store_CA

where employeeefficiency <= 60 
	and storesize > (select avg(storesize) from Store_CA)
  and monthlysalesrevenue < (select avg(monthlysalesrevenue) from Store_CA)
order by employeeefficiency asc


/* Question 3
How are different product categories perform among different locations? */

select sum(monthlysalesrevenue) as total, storelocation, storecategory
from Store_CA
group by storelocation, storecategory
order by storecategory, total desc


/* Question 4
How are the revenues affected with stores distances with competitors? */

-- Create revenue rank numbers for better view of comparison
  
with rankedstores AS (
    select monthlysalesrevenue, rank() over (ORDER BY monthlysalesrevenue desc) as revenue_rank
    from Store_CA
)

select rs.monthlysalesrevenue, rs.revenue_rank, og.competitordistance
from rankedstores rs
left join Store_CA as og 
  on rs.monthlysalesrevenue = og.monthlysalesrevenue

order by rs.revenue_rank
