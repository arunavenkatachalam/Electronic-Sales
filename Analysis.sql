-- Which product type have the highest sales volumes
Select product_type,Sum(quantity) as TotalSalesVolume,  EXTRACT(YEAR FROM Purchase_Date) AS Year
From sales
where order_status = 'Completed'
group by Year,product_type
Order by 
	Year DESC, 
    TotalSalesVolume DESC

-- loyalty members spend more than non-members
with overall_revenue as(
select round(sum(total_price :: numeric), 2) as revenue
from sales
where order_status = 'Completed'
)
Select loyalty_member,
round(sum(total_price :: numeric),2) as total_revenue,
round(sum(total_price :: numeric) /revenue * 100,2) as revenue_percentage
from sales,overall_revenue
where order_status = 'Completed'
group by loyalty_member, revenue



-- average rating for each product type
Select product_type,round(Avg(rating),2)
from sales
group by product_type

-- Highest purchased addon
WITH flattened_addons AS (
    -- Flatten all three "Add-ons Purchased" columns into one column
    SELECT addons_purchased_1 AS addon_name FROM sales where order_status = 'Completed'
    UNION ALL
    SELECT addons_purchased_2 AS addon_name FROM sales where order_status = 'Completed'
    UNION ALL
    SELECT addons_purchased_3 AS addon_name FROM sales where order_status = 'Completed'
)
SELECT addon_name, COUNT(*) AS addon_count
FROM flattened_addons
WHERE addon_name IS NOT NULL  
GROUP BY addon_name
ORDER BY addon_count DESC; 

-- Add-on revenue contribution towards Revenue based on product type
Select product_type, 
	Sum(quantity) as total_quantity,
	Round(CAST(Sum(total_price) + Sum(addon_total) AS Numeric),2) as revenue, 
	Sum(addon_total) as addon_revenue,
	Round((CAST(Sum(addon_total)AS numeric)/ CAST(Sum(total_price) + Sum(addon_total) AS numeric)) *100,2) as addon_percentage
from sales
where order_status = 'Completed'
group by product_type

-- Profit based on Gender
Select gender,
	product_type,
	count(product_type) as Product_count,
	sum(quantity) as Total_quantity,
	Round(CAST(sum(total_price+addon_total) as Numeric),2) as Revenue
from sales
where order_status = 'Completed'
group by gender, product_type

-- Loyalty member based on Gender
Select loyalty_member,
	gender,
	count(gender) as Gender_count
from sales
where order_status = 'Completed'
group by loyalty_member,gender
