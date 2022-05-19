DELETE FROM data_table;
DELETE FROM data_table@server_link;
DELETE FROM result_table;
commit;

ACCEPT X1 CHAR PROMPT   "input= "

DECLARE
	
	A1 varchar2(100);
	d number;
	array_list_site input_array;

BEGIN
	
    --postfix notation with calculation
	--comma separate input
	A1 := '&X1';
	--array_list_site := input_array('(','10','*','66',')','-','34','/','17');
    
    d:=site_pack.input_function(A1);
	if d = 1 then
		dbms_output.new_line;
		dbms_output.put_line('wrong input.');
		INSERT INTO result_table values(1, 'error',0);
		commit;
		
	else
		dbms_output.put_line('input success.');
		
	end if;
    
    
END;
/
commit;