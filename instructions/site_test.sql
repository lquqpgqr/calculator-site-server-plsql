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
--select * from data_table@server_link;


