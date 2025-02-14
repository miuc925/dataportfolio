The dataset named as "Retail Store Performance" is found [here](https://www.kaggle.com/datasets/pereprosov/retail-store-performance).

Here you will find proposed business questions along with attempts to address them with SQL.
- [Question 1](#Question-1)
- [Question 2](#Question-2)
- [Question 3](#Question-3)
- [Question 4](#Question-4)

***

Built with: SQLite

Skills used: Common Table Expressions, Joins, Window Functions, Aggregate Functions

***

#### Question 1
Stores in Los Angeles need to be selected for renovation to improve competitiveness.

- Criteria 1: Location -> Los Angeles
- Criteria 2: store age > 25
- Criteria 3: monthly revenue > average revenue
- Criteria 4: distance with competitor < 10


```sql
select storeage, monthlysalesrevenue, competitordistance
from Store_CA

where storelocation = 'Los Angeles'
  and storeage > 25
  and monthlysalesrevenue < average_revenue 
  and competitordistance <= 10 
```

#### Result
| storeage | monthlysalesrevenue | competitordistance |
| --- | --- | --- |
| 30 | 233.89 | 9 |
| 30 | 294.81 | 7 |
| 30 | 272.02 | 10 |

***

#### Question 2
Is additional manpower necessary? If yes, for which stores?

- Criteria 1: Employee efficiency score lower than 60 is considered as low efficiency.
- Criteria 2: Focus on stores with revenue lower than the average.

```sql
select employeeefficiency, monthlysalesrevenue, storelocation, storecategory
from Store_CA

where employeeefficiency <= 60
  and storesize > (select avg(storesize) from Store_CA)
  and monthlysalesrevenue < (select avg(monthlysalesrevenue) from Store_CA)
order by employeeefficiency asc
```

#### Result
|employeeefficiency|monthlysalesrevenue|storelocation|storecategory|
|---|---|---|---|
|50|277.21|Sacramento|Grocery|
|50.1|283.63|San Francisco|Grocery|
|50.2|220.86|Sacramento|Clothing|

***

#### Question 3
How are different product categories perform among different locations?

```sql
select storelocation, storecategory, sum(monthlysalesrevenue) as total
from Store_CA
group by storelocation, storecategory
order by storecategory, total desc
```

#### Result
|storelocation|storecategory|total|
|---|---|---|
|San Francisco|Clothing|41891.76|
|Palo Alto|Clothing|39414.49|
|Sacramento|Clothing|39327.37|

***

#### Question 4
How are the revenues affected with stores distances with competitors?

- Create revenue rank numbers for better view of comparison

```sql
with rankedstores AS (
    select monthlysalesrevenue, rank() over (ORDER BY monthlysalesrevenue desc) as revenue_rank
    from Store_CA
)

select rs.revenue_rank,rs.monthlysalesrevenue,og.competitordistance
from rankedstores rs
left join Store_CA as og
  on rs.monthlysalesrevenue = og.monthlysalesrevenue

order by rs.revenue_rank
```

#### Result
|revenue_rank|monthlysalesrevenue|competitordistance|
|---|---|---|
|1|543.26|10|
|2|496.7|7|
|3|492.38|8|
