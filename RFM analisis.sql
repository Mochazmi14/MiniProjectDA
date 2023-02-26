/** Customer Analisis **/
/* Step 1 Filter Data */
with dataset as (
	select 	
		Customers.CustomerID, 
		Customers.CompanyName,
		Orders.OrderID, 
		Orders.OrderDate, 
		sum([Order Details].UnitPrice*Quantity*(1-Discount)) as Total_Sales
	from Customers
		inner join Orders on Customers.CustomerID=Orders.CustomerID
		inner join [Order Details] on Orders.OrderID=[Order Details].OrderID
	where year (Orders.OrderDate) between '1997' and '1998'
	group by Customers.CompanyName, Customers.CustomerID, Orders.OrderID,Orders.OrderDate
),

/* Step 2 Summirized Data */
 Order_Summary as (
	select
		CustomerID, OrderID, OrderDate, Total_Sales
	from dataset
	group by CustomerID, OrderID,OrderDate, Total_Sales
)

/* Step 3 Put together the RFM Report */
select 
t1.CustomerID, --t1.OrderID, 
--t1.OrderDate,
--(select MAX(OrderDate) from Order_Summary) as max_order_date,
(select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID) as max_customer_order_date,
	datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) as Recency,
	count (t1.OrderID) as Frequency,
	sum (t1.Total_Sales) as Monetary,
	ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc) as R,
	ntile (5) over (order by count (t1.OrderID) asc) as F,
	ntile (5) over (order by sum (t1.Total_Sales) asc) as M,
	case
	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 15 THEN 'Champion'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 14 THEN 'Most loyal'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 13 THEN 'Most loyal'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 12 THEN 'Potential loyalist'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 11 THEN 'Potential loyalist'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 10 THEN 'Cant lose them'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 9 THEN 'Cant lose them'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 8 THEN 'Needs attention'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 7 THEN 'Needs attention'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 6 THEN 'About to lost'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 5 THEN 'About to lost'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 4 THEN 'Lost'

	when ntile (5) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc)
	+ ntile (5) over (order by count (t1.OrderID) asc)
	+ ntile (5) over (order by sum (t1.Total_Sales) asc) = 3 THEN 'Lost'
	end as Categories
from Order_Summary t1
group by t1.CustomerID  -- t1.OrderID, 
--t1.OrderDate
;