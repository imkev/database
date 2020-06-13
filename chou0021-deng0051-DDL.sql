-- FileName: chou0021-deng0051-DDL.sql
-- Date    : June 11 2020
-- Author  : Harpal Choudhary & Feiqiong Deng
-- Comment : Assignment1-InventoryII-Tables with Constraints

DROP VIEW IF EXISTS Cust_CAN_CHN_IND_V;
DROP MATERIALIZED VIEW IF EXISTS Prod_Rus_MV;

DROP TABLE IF EXISTS Invoice_Line_T;
DROP TABLE IF EXISTS Product_T;
DROP TABLE IF EXISTS Invoice_T;
DROP TABLE IF EXISTS Customer_T;
DROP TABLE IF EXISTS City_T;
DROP TABLE IF EXISTS Country_T;

-- create country table
CREATE TABLE Country_T(
   Cntry_Code         CHAR(3),
   Cntry_Name         VARCHAR(30),
   Cntry_Population   BIGINT DEFAULT NULL,
   CONSTRAINT Cntry_Code_PK PRIMARY KEY(Cntry_Code)
);

-- create city table
CREATE TABLE City_T(
   City_ID            INT,
   City_Name          VARCHAR(30),
   Cntry_Code         CHAR(3),
   City_Population    BIGINT DEFAULT NULL,
   CONSTRAINT City_ID_PK PRIMARY KEY(City_ID),
   CONSTRAINT Cntry_Code_FK FOREIGN KEY(Cntry_Code) REFERENCES Country_T(Cntry_Code)
);

-- create customer table
CREATE TABLE Customer_T(
   cust_id        character(4) NOT NULL,
   cust_fname     character varying(30),
   cust_lname     character varying(30) NOT NULL,
   cust_phone     character varying(15) NOT NULL,
   cust_address   character varying(20) NOT NULL,
   cust_city      character varying(15) NOT NULL,
   cust_prov      character(15),
   cust_postcode  character(6) NOT NULL,
   cust_balance   numeric(9,2),
   cust_country   CHAR(3),  
   CONSTRAINT pk_customer PRIMARY KEY (cust_id),
   CONSTRAINT fk_cust_country FOREIGN KEY (cust_country) REFERENCES Country_T(Cntry_Code)
);

-- create invoice table
CREATE TABLE Invoice_T(
   invoice_number   character(6) NOT NULL,
   cust_id          character(4) NOT NULL,
   invoice_date     date DEFAULT now(),
   CONSTRAINT pk_invoice PRIMARY KEY (invoice_number),
   CONSTRAINT fk_customer FOREIGN KEY(cust_id) REFERENCES Customer_T(cust_id)
);

-- create product table
CREATE TABLE Product_T(
   prod_code         character(5) NOT NULL,
   prod_description  character varying(60) NOT NULL,
   prod_indate       date NOT NULL DEFAULT now(),
   prod_qoh          integer NOT NULL,
   prod_min          integer,
   prod_price        numeric(5,2) NOT NULL,
   prod_discount     integer,
   cntry_origin      CHAR(3),
   CONSTRAINT pk_product PRIMARY KEY (prod_code),
   CONSTRAINT fk_cntry_origin FOREIGN KEY (cntry_origin) REFERENCES Country_T (Cntry_Code)
);

-- create invoice_line table
CREATE TABLE Invoice_Line_T(
   invoice_number    character(6) NOT NULL,
   invoice_line      integer NOT NULL,
   prod_code         character(5) NOT NULL,
   line_unit         integer NOT NULL,
   line_price        numeric(9,2) NOT NULL,
   CONSTRAINT pk_invoice_line PRIMARY KEY (invoice_number,invoice_line),
   CONSTRAINT fk_product FOREIGN KEY (prod_code) REFERENCES Product_T(prod_code)
);

-- create a dynamic view named as "Cust_CAN_CHN_IND" which  display all the customers from Canada, China and India.
CREATE VIEW Cust_CAN_CHN_IND_V AS
  select Cust_fname, cust_lname, cust_city, cust_country from Customer_T
  where cust_country in ('CAN', 'CHN', 'IND') order by cust_country;

-- create a materialized view named as Prod_Rus that display all the prouducts made in Russia
CREATE MATERIALIZED VIEW Prod_Rus_MV AS 
  Select Prod_Description, Prod_Code, Cntry_Origin from Product_T
  where Cntry_Origin = 'RUS';
  
-- eof: InventoryII-DDL.sql
