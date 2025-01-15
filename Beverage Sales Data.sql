--Take a quick look at the table. What do the columns and values look like. What kind of questions can we ASk to find some important data?
SELECT TOP 5 *
FROM beverages;

--Some of the names of the regions didn't transfer properly, so they need updating.

UPDATE beverages
SET Region = 'Baden-Wurttemberg'
WHERE Region = 'Baden-WÃ¼rttemberg'

UPDATE beverages
SET Region = 'Thuringen'
WHERE Region = 'ThÃ¼ringen'

--Some products need to be updated as well

UPDATE beverages
SET Product = 'Moet & Chandon'
WHERE Product = 'MoÃ«t & Chandon'

UPDATE beverages
SET Product = 'Rotkappchen Sekt'
WHERE Product = 'RotkÃ¤ppchen Sekt'

UPDATE beverages
SET Product = 'Kolsch'
WHERE Product = 'KÃ¶lsch'

UPDATE beverages
SET Product = 'Erdinger Weißbier'
WHERE Product = 'Erdinger WeiÃŸbier'

--Calculate Total Sales by Customer Type and Region

SELECT Region, Customer_Type, SUM(Total_Price) AS TotalSales
FROM beverages
GROUP BY Region, Customer_Type
ORDER BY Region

--Create a permament view in the datASet

CREATE VIEW RegionalSales AS
SELECT Region, Customer_Type, SUM(Total_Price) AS TotalSales
FROM beverages
GROUP BY Region, Customer_Type

--Calculate Total Sales Per Category

SELECT Category, ROUND(SUM(total_price), 2) AS TotalCategorySales
FROM beverages
GROUP BY Category
ORDER BY TotalCategorySales DESC

--Calculate Total Sales by Product in Each Category (in DESCending order)

SELECT Category, Product, ROUND(SUM(total_price), 2) AS TotalSales
FROM beverages
GROUP BY Category, Product
ORDER BY Category, TotalSales DESC

--The discrepancy in alcoholic beverage sales compared to everything else is expected but still pretty large.

--Looking into the difference in quantity sold by category

SELECT Category, SUM(quantity) AS TotalSold
FROM beverages
GROUP BY category
ORDER BY 2 DESC

--Same info but broken down by Region
SELECT Region, category, SUM(quantity) AS TotalSold
FROM beverages
GROUP BY Region, Category
ORDER BY Region, TotalSold DESC

--Total Daily Sales Per Region

SELECT Order_Date, Region, ROUND(SUM(Total_Price), 2) AS TotalSales
FROM beverages
GROUP BY Order_Date, Region
ORDER BY Order_Date, Region

--Total Monthly Sales Per Region

SELECT month(Order_Date), Region, ROUND(SUM(Total_Price), 2) AS TotalSales
FROM beverages
GROUP BY month(Order_Date), Region
ORDER BY month(Order_Date)

--Same thing but formatting the Month and Year

SELECT 
    FORMAT(order_date, 'MM-yyyy') AS Order_Month, 
    Region, 
    ROUND(SUM(Total_Price), 2) AS Total_Sales
FROM 
    beverages
GROUP BY 
    FORMAT(order_date, 'MM-yyyy'),
    YEAR(Order_Date), 
    MONTH(order_date), 
    Region
ORDER BY 
    YEAR(order_date), 
    MONTH(order_date),
    Total_Sales DESC


--Total Monthly Sales Per Product

SELECT 
    FORMAT(order_date, 'MM-yyyy') AS Order_Month, 
    Product,
    ROUND(SUM(Total_Price), 2) AS Total_Sales
FROM 
    beverages
GROUP BY 
    FORMAT(order_date, 'MM-yyyy'),
    YEAR(Order_Date), 
    MONTH(order_date), 
    Product
ORDER BY 
    YEAR(order_date), 
    MONTH(order_date),
    Total_Sales DESC