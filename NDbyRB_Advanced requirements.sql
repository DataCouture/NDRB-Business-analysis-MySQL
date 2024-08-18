-- In your database, create a stored procedure and demonstrate how it runs
DELIMITER //

CREATE PROCEDURE GetTotalUnitsSoldByPrint4(IN print_id VARCHAR(50))
BEGIN
    SELECT Print_id, SUM(Units_Sold) AS total_units_sold
    FROM sales_CAFM
    WHERE Print_id = print_id
    GROUP BY Print_id;
END //

DELIMITER ;

call GetTotalUnitsSoldByPrint('RGS-01');

-- In your database, create a trigger and demonstrate how it runs
-- Create an INSERT trigger for the Print_dictionary
-- DROP TRIGGER IF EXISTS trg_after_new_item_insert;

-- Create the Items Logs table
create table Item_detail_dict_LOG(
    LogID int primary key auto_increment,
    LogMessage varchar(255),
    LogDate timestamp default current_timestamp);

DELIMITER //
create trigger trg_after_new_item_insert
after insert on Item_detail_dict
for each row
begin
    insert into Item_detail_dict_LOG (LogMessage)
    values (CONCAT('New Item added: ', new.Item_name));
end//
DELIMITER ;

-- test: Insert a new print to trigger the INSERT trigger

insert into Item_detail_dict (
				Item_name, 
                Item_ID, 
                Selling_price, 
                Cost_price, 
                CCF_Price)
values ('Fake_Item',
		'FIX',
         100.00, 
         80.00, 
         120.00); 
         
-- Gemma, It worked!! thank you for pointing out. 

-- delete from Item_detail_dict
-- where item_id = 'FIX';


select * 
from Item_detail_dict_LOG;

------------------------------------------------------------------
-- In your database, create an event and demonstrate how it runs

set global event_scheduler = ON;


create table archived_print_id_dict (
    Print_ID varchar(50),
    Print_name varchar(100),
    print_series_code varchar(50),
    archive_date DATETIME);

DELIMITER //
create event archive_old_prints
on schedule every 90 day -- every 3 quarter
do
begin
    insert into archived_print_id_dict (Print_ID, Print_name, print_series_code, archive_date)
    select Print_ID, Print_name, print_series_code, NOW()
    from print_id_dict
    where last_updated < NOW() - INTERVAL 3 YEAR;
	delete from print_id_dict
    where last_updated < NOW() - INTERVAL 3 YEAR;
end //

DELIMITER ;



-- Create a view that uses at least 3-4 base tables; 
-- prepare and demonstrate a query that uses the view to produce a logically arranged result set for analysis
-- Creating a view that gives a combined sales view of 3 exhibitions with reference to items
create view comparision_across_events as
select r.total_sales as total_Sales_at_RFM,
       m.total_sales as total_Sales_at_MonoCalcutta,
       SUM(c.total_sales) as total_Sales_at_CAFM,
       i.item_name,
       i.item_id
from item_detail_dict i
join Sales_CAFM c on i.item_id = c.item_id
join Sales_MonoCalcutta m on i.item_id = m.item_id
join Sales_REDFM r on i.item_id = r.item_id
group by
    r.total_sales,
    m.total_sales,
    i.item_name,
    i.item_id;
        
-- demonstrate a query that uses the view to produce a logically arranged result set for analysis
-- find out the item that crossed Rs. 10000/- aggregated sales across all three events.        
select
    item_name,
    item_id,
    (total_Sales_at_RFM + total_Sales_at_MonoCalcutta + total_Sales_at_CAFM) AS Best_selling_across_events
from 
    comparision_across_events
where
    (total_Sales_at_RFM + total_Sales_at_MonoCalcutta + total_Sales_at_CAFM) > 10000
order by  Best_selling_across_events desc;



-- Prepare an example query with group by and having to demonstrate how to extract data from your DB for analysis 
-- Finding out the items that are doing poorly across all events (aggregate sales below 2000)

select
    item_name, item_id,
    SUM(total_Sales_at_RFM) AS total_Sales_at_RFM,
    SUM(total_Sales_at_MonoCalcutta) AS total_Sales_at_MonoCalcutta,
    SUM(total_Sales_at_CAFM) AS total_Sales_at_CAFM,
    (SUM(total_Sales_at_RFM) + SUM(total_Sales_at_MonoCalcutta) + SUM(total_Sales_at_CAFM)) AS Performing_poorly
from
    comparision_across_events
group by
    item_name, item_id
having
    Performing_poorly < 2000;

---------------------------------------------------------------------------------

