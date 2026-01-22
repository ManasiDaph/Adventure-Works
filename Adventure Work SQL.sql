
Create database Adventure_Work;    /* to create database*/
Use Adventure_Work;               /* use database*/
drop database Adventure_Work;

Create table Append                /*create table append*/
(
Product_Key int,
OrderDateKey int,
DueDateKey int,
ShipDateKey int,
CustomerKey int,
PromotionKey int,
CurrencyKey int,
SalesOrderNumber varchar(10),
SalesOrderLineNumber int,
intRevisionNumber int,
OrderQuantity int,
UnitPrice float,
ExtendedAmount float,
UnitPriceDiscountPct int,
DiscountAmount int,
ProductStandardCost float,
TotalProductCost float,
SalesAmount float,
TaxAmt float,
Freight float,
CarrierTrackingNumber int,
CustomerPONumber int,
OrderDate date,
DueDate	date,
ShipDate date);

/* insert data into table created*/
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/ADMIN/Desktop/MANASI PROJECT 1/UNION.csv'
INTO TABLE Append
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
Select * from Append;

/* ceate table customer*/
Create table Customer
(
CustomerKey	int,
GeographyKey	int,
CustomerAlternateKey	varchar(20),
Title	varchar(20),
FirstName	varchar(20),
MiddleName	varchar(20),
LastName	varchar(20),
NameStyle	varchar(20),
BirthDate	date,
MaritalStatus	varchar(10),
Suffix	varchar(20),
Gender	varchar(20),
EmailAddress	varchar(20),
YearlyIncome	int,
TotalChildren	int,
NumberChildrenAtHome	int,
EnglishEducation	varchar(50),
SpanishEducation	varchar(50),
FrenchEducation	varchar(50),
EnglishOccupation	varchar(50),
SpanishOccupation	varchar(50),
FrenchOccupation	varchar(50),
HouseOwnerFlag	varchar(50),
NumberCarsOwned	int,
AddressLine1	varchar(50),
AddressLine2	varchar(50),
Phone	varchar(20),
DateFirstPurchase	date,
CommuteDistance varchar(50));

/* insert values into table*/
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/ADMIN/Desktop/MANASI PROJECT 1/Dimcustomer.csv'
INTO TABLE Customer
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

Select * from Customer;

/* create table sale*/
Create Table Sales
(
SalesTerritoryKey	int,
SalesTerritoryAlternateKey	int,
SalesTerritoryRegion	varchar(50),
SalesTerritoryCountry	varchar(50),
SalesTerritoryGroup varchar(50));

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/ADMIN/Desktop/MANASI PROJECT 1/DimSalesterritory.csv'
INTO TABLE Sales
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

Select * from Sales;

Create table product
(
ProductKey	int,
Unit_price	float,
ProductAlternateKey	varchar(50),
ProductSubcategoryKey	varchar(50),
WeightUnitMeasureCode	varchar(50),
SizeUnitMeasureCode	varchar(50),
EnglishProductName	varchar(50),
SpanishProductName	varchar(50),
FrenchProductName	varchar(50),
StandardCost	int,
FinishedGoodsFlag	varchar(50),
Color	varchar(50),
SafetyStockLevel	int,
ReorderPoint	int,
ListPrice	int,
Size	int,
SizeRange	varchar(50),
Weight	varchar(50),
DaysToManufacture	int,
ProductLine	varchar(50),
DealerPrice	varchar(50),
Class	varchar(50),
Style	varchar(50),
ModelName	varchar(50),
EnglishDescription	varchar(50),
FrenchDescription	varchar(50),
ChineseDescription	varchar(50),
ArabicDescription	varchar(50),
HebrewDescription	varchar(50),
ThaiDescription	varchar(50),
GermanDescription	varchar(50),
JapaneseDescription	varchar(50),
TurkishDescription	varchar(50),
StartDate	date,
EndDate	date,
Status varchar(50));

/* insert values into table*/
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE "C:/Users/ADMIN/Desktop/MANASI PROJECT 1/DimProduct.csv"
INTO TABLE Product
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

Select * from Product;

/*1.Lookup the productname from the Product sheet to Sales sheet.*/
Alter table Append 
Add column productname varchar(100);

SET SQL_SAFE_UPDATES = 0;

update append a
join product p
on a.Product_Key = p.ProductKey
set a.productname = p.EnglishProductName
where productname is null ;


select * from append;
select * from product;
desc append;


UPDATE append a
JOIN product p
ON a.Product_Key = p.ProductKey
SET a.productname = p.EnglishProductName
WHERE a.productname IS NULL;

Alter table Sales 
Add column productname varchar(100);

UPDATE Sales s
JOIN append ap
ON s.SalesTerritoryKey=ap.Sales_Territory_Key
SET s.productname=ap.productname
WHERE s.productname IS NULL;

/*2.Lookup the Customerfullname from the Customer sheet to Sales sheet.*/


Alter table customer
add column Customer_name varchar(50);

update customer
set Customer_name = Concat(FirstName,' ',MiddleName,' ',LastName);

alter table sales
add column customerkey int;
update sales s
join append a 
on s.SalesTerritoryKey=a.Sales_Territory_Key
set s.customerkey=a.CustomerKey;
Alter table sales
add column Customer_name varchar(50);
update sales s
join customer c
on s.customerkey=c.CustomerKey
set s.Customer_name=c.Customer_name;

/*2.Lookup the Unit Price from Product sheet to Sales sheet.*/


Alter table sales
add column ProductKey int;

update sales s 
join append a 
on s.SalesTerritoryKey=a.Sales_Territory_Key
set s.ProductKey=a.Product_Key;

Alter table sales
add column unitprice float;

update sales s 
join product p
on s.ProductKey=p.ProductKey
set s.unitprice=p.Unit_price;

select * from append;

/*3.calcuate the following fields from the Orderdatekey field ( First Create a Date Field from Orderdatekey)*/

Alter table append
add column Date_field date;
UPDATE append
SET Date_field = STR_TO_DATE(OrderDateKey, '%Y%m%d');

/* Find Year*/

Alter table append
Add column Year int;

update append
set Year= year(Date_field);

/*Find Month*/

Alter table append
Add column Month int;

update append
set Month= Month(Date_field);

/* Find Monthname*/

alter table append
modify Month_Name varchar(10);

update append
set Month_Name= monthname(Date_field);

/* Find Quater*/

Alter table append
Add column Quater varchar(2);

update append
set Quater= quarter(Date_field);

/* Find Year and mond*/

alter table append
Add column Yearmonth varchar(7);

UPDATE append
SET YearMonth = DATE_FORMAT(Date_field, '%Y-%m');

/* find weekdday number*/

alter table append
add column Weekday_number int;

update append
set Weekday_number=dayofweek(Date_field);

/*Find weekday name*/

alter table append
Add column Weekday_name varchar(10);

UPDATE append
SET Weekday_name = dayname(Date_field);

/* Find Financial Month*/

alter table append
Add column Financial_Month int;

UPDATE append
SET Financial_Month = MOD(MONTH(Date_field) + 8, 12) + 1;

/*Find Financial Qater*/

Select*from append;


ALTER TABLE Append
ADD COLUMN financial_quarter VARCHAR(2);


UPDATE Append
SET financial_quarter = 
    IF(MONTH(Date_field) BETWEEN 4 AND 6, 'Q1',
    IF(MONTH(Date_field) BETWEEN 7 AND 9, 'Q2',
    IF(MONTH(Date_field) BETWEEN 10 AND 12, 'Q3', 'Q4')));

/* 4.Calculate the Sales amount uning the columns(unit price,order quantity,unit discount)*/
Alter table append
Add column Sales_amount float;

update append
set Sales_amount=OrderQuantity*UnitPrice-DiscountAmount;
Select * from append;

/*5.Calculate the Productioncost uning the columns(unit cost ,order quantity)*/

Alter table append
add column Product_amount float;


update append
set Product_amount=OrderQuantity*TotalProductCost;

/*6.Calculate the profit.*/

Alter table append
Add column Profit float;

update append
set Profit=Sales_amount-Product_amount;

Alter table append 
Add column customer_name varchar(50);

update append a 
join customer c
on a.CustomerKey=c.CustomerKey
set a.customer_name=c.Customer_name;

Alter table append 
Add column Product_name  varchar(50);

update append a 
join product p
on a.Product_Key=p.ProductKey
set a.Product_name=p.EnglishProductName;

Select * from append;

/* Find Total sales*/
SELECT CONCAT('$', FORMAT(SUM(Sales_amount)/1000000, 3), 'M')Total_Sales from append;

/* Find Total Profit*/
Select concat('$',Format(sum(Profit)/1000000,3),'M') Profit from append;

/*Find Total orders*/
select count(OrderDateKey) Total_Orders from append;

/*Find Top 5 Products*/
SELECT 
    Product_name,
    SUM(Sales_amount) AS total_quantity_sold
FROM append
GROUP BY  Product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

/*Find top 5 Customrs*/
SELECT 
    customer_name,
    SUM(Sales_amount) AS total_orders
FROM append
GROUP BY  customer_name
ORDER BY total_orders DESC
LIMIT 5;



