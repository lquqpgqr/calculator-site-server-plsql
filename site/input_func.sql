CREATE OR REPLACE PACKAGE BODY site_pack AS


	FUNCTION is_number(p_string IN VARCHAR2)
	RETURN INTEGER
	IS
	v_new_num NUMBER;
	BEGIN
	v_new_num := TO_NUMBER(p_string);
	RETURN 1;
	EXCEPTION
	WHEN VALUE_ERROR THEN
	RETURN 0;
	END is_number;



    FUNCTION input_function(input_string in varchar2)
    RETURN INTEGER
    IS
    
    total_length integer;
    temp varchar2(10);
	temp1 varchar2(10);
    temp2 number;
    flag number;
    op_exp EXCEPTION;
	i number;
	j number;
	
    BEGIN
    
		i:=1;
		j:=1;
        total_length := length(input_string);
		temp1 := '';
        flag:= 0;
        WHILE i <= total_length LOOP
			temp := substr(input_string,i,1);
            IF temp = '+' or temp = '-' or temp = '*' or temp = '/' THEN
				IF temp1 is not null THEN
					INSERT INTO data_table values(j, temp1,'number');
					j := j+1;
					temp1 := '';
				END IF;
				INSERT INTO data_table values(j, temp,'operator');
				j := j+1;
				
			ELSIF temp = '(' or temp = ')' THEN
				IF temp1 is not null THEN
					INSERT INTO data_table values(j, temp1,'number');
					j := j+1;
					temp1 := '';
				END IF;
				INSERT INTO data_table values(j, temp,'bracket');
				j := j+1;
			
			ELSIF is_number(temp) = 1 THEN
				temp1 := concat(temp1,temp);
			
			ELSE
				temp2 := TO_NUMBER(temp);
			END IF;
			i:=i+1;
			
        END LOOP;
		
		IF temp1 is not null THEN
			INSERT INTO data_table@server_link values(j, temp1,'number');
			temp1 := '';
		END IF;

        dbms_output.new_line;
        RETURN flag;
    
    
    EXCEPTION
	WHEN op_exp then
		flag:= 1;
		RETURN flag;
    WHEN OTHERS
		then flag:=1;
		RETURN flag;
        
    END input_function;
	
    

END site_pack;
/

show errors;
