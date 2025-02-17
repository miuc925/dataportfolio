The data set is found at [Kaggle](https://www.kaggle.com/datasets/ahmedmohamed2003/cafe-sales-dirty-data-for-cleaning-training).

Original data set contains 10000 records of data.

**** Step 1: Checking data schema
```sql
pragma table_info(dirty_cafe_sales)
```

Outcome:
cid|name|type|notnull|dflt_value|pk
---
"0"|"Transaction_ID"|"TEXT"|"0"|"null"|"0"
"1"	"Item"	"TEXT"	"0"	"null"	"0"
"2"	"Quantity"	"TEXT"	"0"	"null"	"0"
"3"	"Price_Per_Unit"	"TEXT"	"0"	"null"	"0"
"4"	"Total_Spent"	"TEXT"	"0"	"null"	"0"
"5"	"Payment_Method"	"TEXT"	"0"	"null"	"0"
"6"	"Location"	"TEXT"	"0"	"null"	"0"
"7"	"Transaction_Date"	"TEXT"	"0"	"null"	"0"


**** Step 2: Checking data quality

Perform below query for column: [Item], [Quantity], [Price_Per_Unit],[ Total_Spent], [Payment_Method] & [Location]
```sql
SELECT DISTINCT(xxx) from dirty_cafe_sales
```

Common 


Perform below query for column: [Transaction_Date]
```sql
SELECT DISTINCT(xxx) from dirty_cafe_sales
where transaction_date not like '20%' --
```
