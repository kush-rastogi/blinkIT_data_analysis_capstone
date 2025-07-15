SELECT * FROM blinkit_data;

SELECT COUNT(*) FROM blinkit_data;

UPDATE blinkit_data
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END


--1) Total Sales: 
SELECT CAST(SUM(Sales)/ 1000000 AS DECIMAL(10,2)) 
AS Total_Sales_Millions
FROM blinkit_data;


--2) Average Sales:
SELECT CAST(AVG(Sales) AS DECIMAL(10,2))
AS Average_Sales
FROM blinkit_data;


--3) Total No Of Items:
SELECT COUNT(*) 
AS No_Of_Items 
FROM blinkit_data;


--4) Average Rating:
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) 
AS Average_Rating 
FROM blinkit_data;


--5) Total Sales By Fat Content:
SELECT Item_Fat_Content, 
	CAST(SUM(Sales)/ 1000 AS DECIMAL(10,2)) AS Total_Sales_By_Fat_Content_In_Thousands,
	CAST(AVG(Sales) AS DECIMAL(10,2)) AS Average_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Rating
FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_By_Fat_Content_In_Thousands DESC;


--6) Total Sales By Item Type:
SELECT Item_Type, 
	CAST(SUM(Sales)/ 1000 AS DECIMAL(10,2)) AS Total_Sales_By_Item_Type_Per_Thousand,
	CAST(AVG(Sales) AS DECIMAL(10,2)) AS Average_Sales_By_Item_Type,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Rating
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales_By_Item_Type_Per_Thousand DESC;


--7) Fat Content By Outlet For Total Sales:
SELECT Outlet_Location_Type,
	ISNULL([Low Fat], 0) AS Low_Fat,
	ISNULL([Regular], 0) AS Regular
FROM
(
	SELECT Outlet_Location_Type, Item_Fat_Content,
		CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
	FROM blinkit_data
	GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT
(
	SUM(Total_Sales)
	FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


--8) Total Sales By Outlet Establishment 
SELECT Outlet_Establishment_Year,
	CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC;


--9) Percentage Of Sales By Outlet Size:
SELECT 
	Outlet_Size,
	CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST((SUM(Sales) * 100.00 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Outlet_Size DESC;


--10) Total Sales By Outlet Location Type
SELECT Outlet_Location_Type,
	CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales_By_Outlet_Location_Type,
	CAST((SUM(Sales) * 100.00 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage_By_Outlet_Location_Type
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales_By_Outlet_Location_Type DESC;


--11) Total Sales By Outlet Types:
SELECT Outlet_Type,
	CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales_By_Outlet_Type,
	CAST((SUM(Sales) * 100.00 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage_By_Outlet_Type
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales_By_Outlet_Type DESC;
