

CREATE OR REPLACE PACKAGE BODY server_pack AS

    FUNCTION fetch_function
    RETURN calculation_array
    IS
    
    i INTEGER;
    total_length INTEGER;
    array_list calculation_array :=calculation_array();
    
    BEGIN
        i:=0;
        
        FOR R IN (SELECT * FROM temp_table) LOOP
            
            i:=i+1;
            array_list.extend;
            array_list(i) := R.data_name;
            --dbms_output.put_line(R.data_name);
            
        END LOOP;
        
        total_length := array_list.count;
        
        DBMS_OUTPUT.PUT_LINE('input line:');
        FOR i in 1 .. total_length LOOP
            dbms_output.put(array_list(i));
        end LOOP;
        dbms_output.new_line;
        
        RETURN array_list;
    
    END fetch_function;





    FUNCTION calculation_function (array_list in calculation_array,error_flag OUT INTEGER)
    RETURN calculation_array
    IS
    
    
    j INTEGER;
    op_flag INTEGER;
    
    total_length INTEGER;
    op_exp EXCEPTION;
    
    temp VARCHAR2(10);
    temp2 varchar(10);
    
    output_array calculation_array :=calculation_array();
    s data_struct.n_stack;
    
    BEGIN
        op_flag:=0;
        error_flag:=0;
        s := data_struct.new_n_stack(10000000);
        data_struct.push(s,'#');
        total_length := array_list.count;
        j:=1;
        FOR i in 1 .. total_length LOOP
            
            temp:= array_list(i);
            
            IF temp = '(' THEN
                data_struct.push(s,temp);
            ELSIF temp = ')' THEN
            
                WHILE (data_struct.topp(s) != '#') AND (data_struct.topp(s) != '(') LOOP
                    
                    output_array.extend;
                    output_array(j) := ',';
                    j:=j+1;
                    data_struct.pop(s,temp2);
                    output_array.extend;
                    output_array(j) := TRIM(temp2);
                    --dbms_output.put_line('.|'||output_array(j)||'|.');
                    j:=j+1;
                    
                end loop;
                
                IF data_struct.topp(s) ='(' THEN
                    data_struct.pop(s,temp2);
                END IF;
                
            ELSIF temp = '+' OR temp = '-' OR temp = '*' OR temp = '/' THEN
                    IF op_flag=1 THEN
                        RAISE op_exp;
                    end IF;
                    
                    op_flag:=1;
                    output_array.extend;
                    output_array(j) := ',';
                    j:=j+1;

                WHILE (data_struct.topp(s) != '#') AND check_precedence(temp)<= check_precedence(data_struct.topp(s)) LOOP
                    data_struct.pop(s,temp2);
                    output_array.extend;
                    output_array(j) := TRIM(temp2);
                    --dbms_output.put_line('.|'||output_array(j)||'|.');
                    j:=j+1;
                    output_array.extend;
                    output_array(j) := ',';
                    j:=j+1;
                    
                
                END LOOP;
                
                data_struct.push(s,temp);
                
           ELSE
                output_array.extend;
                output_array(j) := temp;
                j:=j+1;
                op_flag:=0;
                
            END IF;
        
        END LOOP;
        
        WHILE data_struct.topp(s) != '#' LOOP
            
            output_array.extend;
            output_array(j) := ',';
            j:=j+1;
            data_struct.pop(s,temp2);
            output_array.extend;
            output_array(j) := TRIM(temp2);
            --dbms_output.put_line('.|'||output_array(j)||'|.');
            j:=j+1;
            
    
        END LOOP;
        
        
        total_length := output_array.count;
        
        DBMS_OUTPUT.PUT_LINE('output line:');
        FOR i in 1 .. total_length LOOP
            dbms_output.put(output_array(i));
        end LOOP;
        dbms_output.new_line;
        
        RETURN output_array;
        
        /*
        EXCEPTION
        WHEN op_exp then
            INSERT INTO result_table values(1, 'Error',0);
            error_flag:= 1;
            RETURN output_array;
        WHEN OTHERS then
            INSERT INTO result_table values(1, 'Error',0);
            error_flag:= 1;
            RETURN output_array;
        */   
        
    END calculation_function;
    
    
    PROCEDURE evaluation_procedure(output_array in calculation_array)
    IS
    
    total_length INTEGER;
    temp_op varchar2(10);
    temp VARCHAR2(10);
    temp2 varchar(10);
    temp_result number;
    
    s data_struct.n_stack;
    
    BEGIN
    
     s := data_struct.new_n_stack(10000000);
    total_length := output_array.count;
    --dbms_output.put_line('Result: '||total_length);
    
    FOR i in 1 .. total_length LOOP
            
            temp:= output_array(i);
            --dbms_output.put_line('item: '||temp);
            
            IF temp = '+' OR temp = '-' OR temp = '*' OR temp = '/' THEN
                temp_op := temp;
                
                data_struct.pop(s,temp);
                data_struct.pop(s,temp2);
                
                dbms_output.put_line('item1: '||temp||' item2:'||temp2);
                CASE 
                    WHEN temp_op ='+' then
                    temp_result := TO_NUMBER(TRIM(temp2)) + TO_NUMBER(TRIM(temp));
                    data_struct.push(s,temp_result);
                    
                    WHEN temp_op ='-' then
                    temp_result := TO_NUMBER(TRIM(temp2))-TO_NUMBER(TRIM(temp));
                    data_struct.push(s,temp_result);
                    
                    WHEN temp_op ='*' then
                    temp_result := TO_NUMBER(TRIM(temp2))*TO_NUMBER(TRIM(temp));
                    data_struct.push(s,temp_result);
                    
                    WHEN temp_op ='/' then
                    temp_result := TO_NUMBER(TRIM(temp2))/TO_NUMBER(TRIM(temp));
                    data_struct.push(s,temp_result);
                    
                END CASE;
                
            
            ELSIF temp != ',' THEN
                data_struct.push(s,temp);
            --ELSE data_struct.push(s,temp);
                
            
            END IF;
    END LOOP;
    
    data_struct.pop(s,temp_result);
    dbms_output.put_line('Result: '||temp_result);
    DELETE from result_table@site_link;
    
    INSERT INTO result_table@site_link values(1, 'Result',temp_result); 
    commit;
    
    
    END evaluation_procedure;
    
    
    
    FUNCTION check_precedence(ch CHAR)
    RETURN INTEGER
    IS
    
    n INTEGER;
    
    BEGIN
        n:=0;
        CASE 
            WHEN ch ='+' then n:=1;
            
            WHEN ch ='-' then n:=1;
            
            WHEN ch ='*' then n:=2;
            
            WHEN ch ='/' then n:=2;
            
            ELSE n:=0;
        END CASE;
        RETURN n;
    
    END check_precedence;
    
    
    

END server_pack;
/
show errors;





create or replace package body data_struct as

    function new_n_stack(max_height pls_integer default 10000) return n_stack
    is
    s n_stack;
    begin
        s.a := n_stack_data();
        s.a.extend(max_height);
        s.top := 0;
        return s;
    end new_n_stack;

    procedure push(s in out n_stack, x CHAR)
    is
    begin
        s.top      := s.top + 1;
        s.a(s.top) := x;
    end push;

    procedure pop(s in out n_stack, x in out CHAR)
    is
    begin
        x     := s.a(s.top);
        s.top := s.top - 1;
        
    end pop;
    
    function topp(s in out n_stack) return char
    is
    
    begin
        return s.a(s.top);
    end topp;

    function empty (s n_stack) return boolean is
    begin
        return (s.top = 0);
    end empty;

end data_struct;
/

show errors;