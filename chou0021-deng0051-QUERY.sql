-- FileName: chou0021-deng0051-query.sql
-- Date    : June 11 2020
-- Author  : Harpal Choudhary & Feiqiong Deng
-- Comment : Assignment1-InventoryII-Tables-Queries

select * from country_t;
select * from customer_t;
select * from city_t;
select * from product_t;
select * from invoice_t;
select * from invoice_line_t;

-- display data from cut_can_chn_Ind view, all customers from Canada, China and India
select * from cust_can_chn_ind_V;
select * from cust_can_chn_ind_V 
where cust_country = 'CAN';

-- refresh after running DML file or inserting data in product table.
refresh materialized view Prod_rus_MV;

-- display data from prod_rus materialized  view displays all products mmade in Russia

select * from Prod_Rus_MV;

-- Join Statements left join customer table to country table and displays all the countries which doesnt have any customers 
select country_t.cntry_name, cust_fname, cust_lname 
from country_t
left join customer_t
on customer_t.cust_country = country_t.cntry_code where customer_t.cust_country is null;

-- right join displays all the countries where products are bought.
select country_t.cntry_name, prod_description 
from country_t
right join product_t
on product_t.cntry_origin = country_t.cntry_code;