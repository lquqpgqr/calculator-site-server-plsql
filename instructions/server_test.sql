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
CREATE TABLE data_table ( 
    id INTEGER , 
    data_name  VARCHAR2(10) NOT NULL, 
    type_name VARCHAR2(10) NOT NULL
);

INSERT INTO data_table
VALUES (1,'+','operator');
commit;
show errors;