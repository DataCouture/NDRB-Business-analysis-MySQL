
use nd_by_rb ;

-- Joining tables to find out the total expenditure at Chennai Art and flea
-- Using any type of the joins create a view that combines multiple tables in a logical way
-- 1. Join cost_exhibition & exhibition_detail to see all expenditure detailes relared to chennai art and flea
select * 
from Exhibition_detail as ed
cross join costs_exhibition as ce
on ed.event_id = ce.event_id
where ce.event_id = 'CAFM24';

-- 2. Join cost_exhibition & exhibition_detail to see all expenditure detailes relared to all exhibitions
select ce.event_id, ed.event_name,
sum(ce.cost_amount) as total_expenditure
from costs_exhibition as ce
left join nd_by_rb.exhibition_detail as ed 
on ce.Event_ID = ed.Event_ID
group by ce.event_id;

-- 3. join cost_exhibition & exhibition_detail to see total expenditure only (without detailes)
--  related to chennai art and flea
select ce.Event_ID, ed.event_name,
SUM(ce.cost_amount) as total_expenditure
from costs_exhibition as ce 
left join nd_by_rb.exhibition_detail as ed 
on ce.Event_ID = ed.Event_ID
where ce.Event_ID = 'CAFM24'
group by ce.Event_ID;

-- 4.Joining tables to find out print wise sales at Chennai Art and Flea

select sc.print_id, 
	   SUM(sc.total_sales),
	   pd.Print_name
from Sales_CAFM as sc
join print_id_dict as pd
on sc.print_id = pd.print_id
group by sc.print_id,  -- Learning: we need to include all non-aggregated columns in the GROUP BY clause. Help taken from CHAT GPT here.
         pd.print_name,
         sc.total_sales
order by Total_Sales desc;

-- In your database, create a stored function that can be applied to a query in your DB
-- STORED FUNCTION to find out PROFIT PERCENTAGE of an item by input function item_id.

DELIMITER // 

create function calculate_profit_percentage(Item_id varchar (50))
returns decimal(10,2)
DETERMINISTIC
begin 
declare profit_percentage DECIMAL(10,2);
select ((selling_price - cost_price) / cost_price * 100 )
into profit_percentage
from item_detail_dict
where item_id = item_id
LIMIT 1; -- learning: limit the return value to 1 else it can return multiple rows and create error

return profit_percentage;
end //

DELIMITER ;


select calculate_profit_percentage('A5WR');


-- Prepare an example query with a subquery to demonstrate how to extract data from your DB for analysis 
-- Using subquery to find out the 'Print Name' from a Sales ID at Chennai Art and Flea.

select print_name
from print_id_dict
where Print_ID in (select print_id
					from Sales_CAFM
					where sale_id = 'CAFM_24_234');


---------------------------------------------------------------------------------------------------------

