SELECT * FROM pizza_db.pizza_sales;

SELECT ROUND(SUM(total_price),2) AS Total_Revenue
FROM pizza_sales;

SELECT ROUND(SUM(total_price) / COUNT(DISTINCT order_id),2) AS AVG_Order_Value
FROM pizza_sales;

SELECT SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales;

SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;

SELECT ROUND(SUM(quantity)/COUNT(DISTINCT order_id),0) AS AVG_Pizza_Per_Order
FROM pizza_sales;

SELECT 
    dayname(STR_TO_DATE(order_date, '%d/%m/%Y')) AS Order_Day
    ,COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY Order_Day
;
/*daily trend*/
SELECT 
    dayname(
        STR_TO_DATE(
            CASE
                WHEN order_date LIKE '%/%/%' THEN order_date  -- For M/D/YYYY or D/M/YYYY
                ELSE CONCAT(SUBSTRING(order_date, 4, 2), '/', SUBSTRING(order_date, 1, 2), '/', SUBSTRING(order_date, 7, 4))  -- For D/M/YYYY
            END, 
            '%m/%d/%Y')
    ) AS Order_Day,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY Order_Day;

/*Hourly Trend*/
SELECT HOUR(str_to_date(order_time,'%H:%i:%s')) AS Hour
,COUNT(distinct order_id)
FROM pizza_sales
GROUP BY Hour
ORDER BY Hour;

SELECT 
    pizza_category,
    ROUND(SUM(total_price),2) AS Total_SAles,
    CONCAT(ROUND(SUM(total_price) / (SELECT SUM(total_price) FROM pizza_sales), 2) * 100 , '%') AS Category_Sold_Proportion
FROM pizza_sales
GROUP BY pizza_category;

SELECT 
    pizza_size,
    ROUND(SUM(total_price), 2) AS Total_Sales,
    CONCAT(
        ROUND(SUM(total_price) / (SELECT SUM(total_price) FROM pizza_sales 
        WHERE QUARTER(STR_TO_DATE(
        CASE 
            WHEN order_date LIKE '%/%/%' THEN order_date 
            ELSE CONCAT(SUBSTRING(order_date, 4, 2), '/', SUBSTRING(order_date, 1, 2), '/', SUBSTRING(order_date, 7, 4)) 
        END, '%d/%m/%Y')) = 1 ), 4) * 100, 
        '%'
    ) AS Category_Sold_Proportion
FROM pizza_sales
WHERE QUARTER(STR_TO_DATE(
        CASE 
            WHEN order_date LIKE '%/%/%' THEN order_date 
            ELSE CONCAT(SUBSTRING(order_date, 4, 2), '/', SUBSTRING(order_date, 1, 2), '/', SUBSTRING(order_date, 7, 4)) 
        END, '%d/%m/%Y')) = 1  
GROUP BY pizza_size;

SELECT pizza_category, SUM(quantity) AS Total_Category_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Category_Sold DESC;

SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
limit 5;

SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
limit 5;














