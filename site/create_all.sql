SET SERVEROUTPUT ON;
SET VERIFY OFF;


drop database link server_link;

create database link server_link
 connect to system identified by "12345"
 using '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.0.150)
		 (PORT = 1722))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )'
; 

CREATE OR REPLACE TYPE input_array as VARRAY(1000) of varchar2(10);
/

drop table data_table;
drop table result_table;

CREATE TABLE data_table ( 
    id INTEGER , 
    data_name  VARCHAR2(10) NOT NULL, 
    type_name VARCHAR2(10) NOT NULL
);

CREATE TABLE result_table ( 
    id INTEGER ,
    type_data VARCHAR2(10) NOT NULL,    
    result_data number
);


drop package site_pack;
CREATE OR REPLACE PACKAGE site_pack AS
    
	FUNCTION is_number (p_string IN VARCHAR2)
	RETURN INTEGER;
	
    FUNCTION input_function(input_string varchar2)
	RETURN INTEGER;
END site_pack;
/
show errors;
--@"C:\Users\abir\Desktop\New folder\input_func.sql";