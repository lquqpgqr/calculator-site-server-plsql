

CREATE OR REPLACE VIEW temp_table AS
SELECT * FROM data_table UNION select * FROM data_table@site_link;
commit;

DECLARE

temp1_array calculation_array:=calculation_array();
temp2_array calculation_array:=calculation_array();
error_flag INTEGER;
input_error_flag INTEGER;

BEGIN
    input_error_flag:=0;
    FOR R IN (SELECT * FROM result_table@site_link) LOOP
        if R.type_data = 'error' then
            input_error_flag:=1;
        end if;
    end loop;
    
    if input_error_flag=0 then
    temp1_array := server_pack.fetch_function();
    temp2_array := server_pack.calculation_function(temp1_array,error_flag);
    
    
    server_pack.evaluation_procedure(temp2_array);
    
    elsif input_error_flag=1 then
        dbms_output.put_line('input was wrong');
    
    end if;
    
end;
/

select * from result_table@site_link;
