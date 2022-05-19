set serveroutput on;

DECLARE
	--r_type_data result_table@server_link%type;
	r_type_data varchar2(10);
	r_result_data number;
	flag INTEGER;

begin
	
	flag:=0;
	FOR R IN (SELECT * FROM result_table) LOOP
        r_type_data:=R.type_data;
		r_result_data:=R.result_data;
		flag:=1;
    end loop;
	if r_type_data='error' or flag=0 then
		dbms_output.put_line('No Result Found');
	else
		dbms_output.put_line('Result: '|| r_result_data);
	end if;
	

end;
/