SET SERVEROUTPUT ON;
SET VERIFY OFF;


drop database link site_link;

create database link site_link
 connect to system identified by "12345"
 using '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.147.130)
		 (PORT = 1622))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )'
; 

drop table data_table;
drop table result_table;

CREATE TABLE data_table ( 
    id INTEGER , 
    data_name  VARCHAR2(10) NOT NULL, 
    type_name VARCHAR2(10) NOT NULL
);

/*
CREATE TABLE result_table ( 
    id INTEGER ,
    type_data VARCHAR2(10) NOT NULL,    
    result_data number
);
*/

CREATE OR REPLACE TYPE calculation_array as VARRAY(10000) of varchar2(10);
/

drop PACKAGE server_pack;
CREATE OR REPLACE PACKAGE server_pack AS
    
    FUNCTION fetch_function
    RETURN calculation_array;
    
    FUNCTION calculation_function(array_list in calculation_array, error_flag out INTEGER)
    RETURN calculation_array;
    PROCEDURE evaluation_procedure(output_array in calculation_array);
    
    
    FUNCTION check_precedence(ch in CHAR)
    RETURN INTEGER;
    
    --PROCEDURE truncate_table(tname in CHAR);
    
END server_pack;
/

create or replace package data_struct as
    type n_stack_data is varray(2147483647) of varchar2(10);
    type n_stack      is record (a n_stack_data, top pls_integer);
    function  new_n_stack(max_height pls_integer default 10000) return n_stack;
    procedure push(s in out n_stack, x CHAR);
    procedure  pop(s in out n_stack, x in out CHAR);
    function topp(s in out n_stack) return CHAR;
    function  empty(s n_stack) return boolean;
end data_struct;
/

CREATE OR REPLACE VIEW temp_table AS
SELECT * FROM data_table UNION select * FROM data_table@site_link;
commit;
--@"D:\4.1\CSE 4126 Distributed Database Systems\project\func_and_proc.sql"