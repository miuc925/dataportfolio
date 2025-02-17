The data set is found at [Kaggle](https://www.kaggle.com/datasets/ahmedmohamed2003/cafe-sales-dirty-data-for-cleaning-training).

Original data set contains 10000 rows of data.
Expected the goal is to clean the data as much as possible and to be available for further analysis.

Content:
- [Step 1: Checking data schema](#Step-1-Checking-data-schema)
- [Step 2: Checking data quality](#Step-2-Checking-data-quality)
- [Step 3: FirstAid and surgery](#Step-3-FirstAid-and-surgery)
- [Step 4: Finding a new home](#Step-4-Finding-a-new-home)
- [Conclusion](#Conclusion)

***

#### Step 1: Checking data schema
```sql
pragma table_info(dirty_cafe_sales)
```

Outcome:
cid|name|type|notnull|dflt_value|pk
---|---|---|---|---|---
0|Transaction_ID|TEXT|0|null|0
1|Item|TEXT|0|null|0
2|Quantity|TEXT|0|null|0
3|Price_Per_Unit|TEXT|0|null|0
4|Total_Spent|TEXT|0|null|0
5|Payment_Method|TEXT|0|null|0
6|Location|TEXT|0|null|0
7|Transaction_Date|TEXT|0|null|0


Incorrect data types found among the columns, that means we need to reset the data type in a new table.
***

#### Step 2: Checking data quality

Perform below query for column: [Item], [Quantity], [Price_Per_Unit],[ Total_Spent], [Payment_Method] & [Location]
```sql
SELECT DISTINCT(xxx) from dirty_cafe_sales
```

Perform below query for column: [Transaction_Date]
```sql
SELECT DISTINCT(xxx) from dirty_cafe_sales
where transaction_date not like '20%' --
```

Common issue found: Besides of incorrect data type in step 1, either 'UNKNOWN', 'ERROR' or '' (blank value) among the results.

***
#### Step 3: FirstAid and surgery

Counting number of 'problematic' data:
```SQL
select count(*) from dirty_cafe_sales
where item in ('UNKNOWN','ERROR','')
    OR quantity in ('UNKNOWN','ERROR','')
    OR price_per_unit in ('UNKNOWN','ERROR','')
    OR total_spent in ('UNKNOWN','ERROR','')
    OR payment_method IN ('UNKNOWN','ERROR','')
    OR location in ('UNKNOWN','ERROR','')
    OR transaction_date in ('UNKNOWN','ERROR','')
```
Outcome: 6911

Sounds scary, right? But we can still save some of them!

Known calculations of the data:
- Total_Spent = Quantity * Price_Per_Unit
- quantity = total_spent / price_per_unit
- price_per_unit = total_spent / quantity

Performing following query so that if there is missing data in any of the columns [Total_Spent], [Quantity] or [Price_per_unit], calculations would be performed with available numbers, or if any 2 of the numbers are missing, records would be replaced as 0 (zero).

```sql
UPDATE dirty_cafe_sales
set
    price_per_unit = CASE 
        WHEN price_per_unit IN ('ERROR', 'UNKNOWN', '') THEN total_spent/ NULLIF(quantity, 0)
        ELSE price_per_unit
    END,
    quantity = CASE 
        WHEN quantity IN ('ERROR', 'UNKNOWN', '') THEN total_spent / NULLIF(price_per_unit, 0)
        ELSE quantity 
    END,
    total_spent = CASE 
        WHEN total_spent IN ('ERROR', 'UNKNOWN', '') THEN price_per_unit * quantity
        ELSE total_spent
    END
WHERE 
    price_per_unit IN ('ERROR', 'UNKNOWN', '') OR 
    quantity IN ('ERROR', 'UNKNOWN', '') OR 
    total_spent IN ('ERROR', 'UNKNOWN', '')
```

Now its time to remove the un-usable data.
```sql
DELETE from dirty_cafe_sales
where item in ('UNKNOWN','ERROR','')
	OR quantity in ('UNKNOWN','ERROR','')
    OR price_per_unit in ('UNKNOWN','ERROR','')
    OR total_spent in ('UNKNOWN','ERROR','')
    OR payment_method IN ('UNKNOWN','ERROR','')
    OR location in ('UNKNOWN','ERROR','')
    OR transaction_date in ('UNKNOWN','ERROR','')
    or price_per_unit = 0 or quantity = 0 or total_spent = 0
```
***
#### Step 4: Finding a new home
Now the data is being clean and we need to copy them to a new place.
```sql
create table clean_cafe_sales (
  transaction_id text PRIMARY key,
  item text,
  quantity integer, --new data type
  price_per_unit real, --new data type
  total_spent real, --new data type
  payment_method text,
  location text,
  transaction_date date --new data type
)
```
```sql
insert into clean_cafe_sales(transaction_id,item,quantity,price_per_unit,total_spent,payment_method,location,transaction_date)
select transaction_id,item,quantity,price_per_unit,total_spent,payment_method,location,transaction_date
from dirty_cafe_sales
```

Also have a find check of the 'cleaned' data:
```sql
SELECT count(*) from clean_cafe_sales
```
Outcome: 3576
***
#### Conclusion
After cleaning, only 36% of the original data is ready to use. Details in data processing have to be checked to ensure meaningful insight could be found after analysis.
