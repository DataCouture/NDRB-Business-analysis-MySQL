
-- Create Database for NOODLE DOODLE BY RB
create database nd_by_rb;
use nd_by_rb;

-- Create Item Details Dictionary Table
Create Table IF NOT Exists Item_detail_dict(
	Item_name Varchar(255) NOT NULL,
	Item_ID Varchar(255) NOT NULL,
	Selling_Price decimal(10, 2),
	Cost_Price decimal(10, 2));
    
    -- ADD Primary Key to Item_detail_dict
Alter Table Item_detail_dict  -- ADD Primary Key
add constraint primary key (Item_ID);

Insert into Item_detail_dict (Item_name, Item_ID, Selling_price, Cost_price)
Values
    ('A5 Notebooks Wiro-Ruled', 'A5WR', 300.0, 120.0),
    ('A5 Journals Centre Bound Unruled', 'A5CUr', 300.0, 85.0),
    ('Pocket NoteBooks - Ruled', 'PNR', 150.0, 75.0),
    ('Magnetic To do List - Unruled', 'MTLUr', 200.0, 50.0),
    ('Gift Tags', 'GTX', 15.0, 2.0);
    
-- Create Print Details Dictionary Table

Create Table IF NOT Exists print_id_dict (
	Print_name Varchar(50),
    Print_series_code Varchar(50),
	Print_ID Varchar(50) NOT NULL);
-- Create Primary Key in the Print_id_dict table
Alter Table print_id_dict 
add constraint primary key (Print_ID);

-- Create Exhibitions Table
Create Table IF NOT Exists Exhibition_detail (
    Event_ID Varchar(50) Primary Key,
    Event_name Varchar(100),
    Date Varchar(50),
    Year Int,
    Month Varchar(50),
    No_of_days INT);

-- Create Costs Table
Create Table Costs_Exhibition (
    Cost_ID Int  Primary Key,
    Event_ID Varchar(50),
    Cost_Type Varchar(50),
    Cost_Amount Varchar(50),
    Details Varchar(255),
    Foreign Key (Event_ID) REFERENCES Exhibition_detail(Event_ID));

-- Create Table for Sales at Chennai Art and Flea
CREATE TABLE Sales_CAFM (
    Sale_ID Varchar (50) PRIMARY KEY,
    Event_ID Varchar (50),
    Item_ID Varchar (50),
    Print_ID Varchar (50),
    stock_available Int,
    stock_taken Int,
    stock_returned Int,
    Units_Sold Int,
    Total_Sales decimal(10, 2),
    Foreign key (Event_ID) References Exhibition_detail(Event_ID),
	Foreign key(Print_ID) References Print_id_dict(Print_ID),
    Foreign key(Item_ID) References Item_detail_dict(Item_ID));
    


-- Create Table for Sales at Mono Calcutta

CREATE TABLE Sales_MonoCalcutta (
    Sale_ID Varchar (50) PRIMARY KEY,
    Event_ID Varchar (50),
    Item_ID Varchar (50),
    stock_available Int,
    stock_taken Int,
    stock_returned Int,
    Units_Sold Int,
    Total_Sales decimal(10, 2),
    Foreign key (Event_ID) References Exhibition_detail(Event_ID),
    Foreign key(Item_ID) References Item_detail_dict(Item_ID));

CREATE TABLE Sales_REDFM (
    Sale_ID Varchar (50) PRIMARY KEY,
    Event_ID Varchar (50),
    Item_ID Varchar (50),
    stock_available Int,
    stock_taken Int,
    stock_returned Int,
    Units_Sold Int,
    Total_Sales decimal(10, 2),
    Foreign key (Event_ID) References Exhibition_detail(Event_ID),
    Foreign key(Item_ID) References Item_detail_dict(Item_ID));

select * from swiggy_custdetail_jm24;

ALTER TABLE swiggy_custdetail_jm24
CHANGE COLUMN full_name fullname VARCHAR(50);

ALTER TABLE swiggy_custdetail_jm24
ADD PRIMARY KEY (full_name);




