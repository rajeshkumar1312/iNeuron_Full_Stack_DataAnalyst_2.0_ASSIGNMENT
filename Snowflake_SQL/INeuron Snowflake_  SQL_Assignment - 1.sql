
Ineuron _Assignment-1 (In create table , primary_key, Date and time format, substring_function, case_statement)

   --1. Load the given dataset into snowflake with a primary key to Order Date column.

	use database demo_database;
  create or replace table RK_sales_data_final (
    order_id varchar(30),
    order_date	Date Primary key,
	ship_date	date,
	ship_mode	varchar(30),
	customer_name varchar(30),
	segment	varchar(30),
	state varchar(50),
	country	varchar(50),
	market	varchar(50),
	region  varchar(50),
	product_id  varchar(50),
	category  varchar(50),
	sub_category  varchar(50),
	product_name  varchar(255),
	sales number(30,0),
	quantity number(30,0),
	discount number(30,0),
	profit number(30,0),
	shipping_cost	 varchar(50),
	order_priority varchar(50),
	year int
	);

	desc table RK_sales_data_final;

	select * from RK_sales_data_final;

	-- Make a copy of original data 

	create or replace table RK_sales_data_final_COPY as
	select * from RK_sales_data_final ;

	select * from RK_sales_data_final_COPY;

	desc table RK_sales_data_final_COPY;

	--2. Change the Primary key to Order Id Column.

	alter table RK_sales_data_final_COPY
	add primary key (ORDER_ID);


	/*3. Check the data type for Order date and Ship date and mention in what data type it should be?
		 Changed in Excel and covert to "DD-MM-YYYY" Format in snowflake
	*/

	create or replace table RK_sales_data_final_COPY as
	select *,
		(TO_CHAR(DATE(ORDER_DATE,'YYYY-MM-DD'),'DD-MM-YYYY') ) as order_date2
	FROM RK_sales_data_final_COPY;

	create or replace table RK_sales_data_final_COPY as
	select *,
      (TO_CHAR(DATE(SHIP_DATE,'YYYY-MM-DD'),'DD-MM-YYYY') ) as SHIP_DATE2
    FROM RK_sales_data_final_COPY;



 -- 4. Create a new column called order_extract and extract the number after the last ‘–‘from Order ID column.   

	create or replace table RK_sales_data_final_COPY as
	select *,
       substring(order_id,9,12) as order_extract
       from RK_sales_data_final_COPY;


	/*5. Create a new column called Discount Flag and categorize it based on discount. 
     Use ‘Yes’ if the discount is greater than zero else ‘No’.  
		*/     
	create or replace table RK_sales_data_final_COPY as  
	select *, 
       case 
           when DISCOUNT>0 then 'Yes'
              else 'NO'
            end as DISCOUNT_FLAG1
        from RK_sales_data_final_COPY;
        
 /*6. Create a new column called process days and calculate how many days
   it takes for each order id to process from the order to its shipment.
   */
   
   create or replace table RK_sales_data_final_COPY as 
   select *,
         datediff('day',order_date, ship_date)
          as process_days
             from RK_sales_data_final_COPY ; 
   
/*7. Create a new column called Rating and then based on the Process dates give rating like given below.
   a. If process days less than or equal to 3days then rating should be 5
   b. If process days are greater than 3 and less than or equal to 6 then rating should be 4
   c. If process days are greater than 6 and less than or equal to 10 then rating should be 3
   d. If process days are greater than 10 then the rating should be 2.
   */
   
   create or replace table RK_sales_data_final_COPY as 
   select *,
            case 
               when  process_days  <=3  then 5  
               when  process_days  >=3  and process_days <=6  then 4
               when  process_days  >=6  and process_days <=10 then 3
               when  process_days  >=10 then 2
            else process_days 
          end as Rating
       from RK_sales_data_final_COPY;
        