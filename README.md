# calculator-site-server-plsql
This is an Calculator app. This app is built using PL/SQL.

Project Name: Postfix Notation with Actual Calculation
Project Member: Abir

Project Description:
This is an Calculator app.
This app is built using PL/SQL.

It uses postfix notation method to calculate
a valid basic numeric expression.
valid char : [(] [)] [+] [-] [*] [/] [any integer number]
example: (12+8)/10

*How to USE the App*

-----Server-----
1. First run the 'create_all.sql' and the 'func_and_proc.sql' sequentially.
2. Wait for site input.
3. Run the 'server_calculate.sql' to calcute the input expression.

-----Site-----
1. First run the 'create_all.sql' and the 'input_func.sql' sequentially.
2. Run the 'site_to_server_input.sql' to give input in the prompt.
3. Wait for the site to run 'server_calculate.sql'.
4. Run the 'site_to_server_output.sql' to get the result.

Required Softwares to run the project:
Oracle 10g.
There is an instruction file to setup the invironment, to run the project.
