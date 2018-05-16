PROMPT
PROMPT  &_C_RED Real Time Diag STEP 2 &_C_RESET
PROMPT  &_C_RED ************************************************************************* &_C_RESET
PROMPT  &_C_YELLOW 1: &_C_BLUE Show long op status for SID-SERIAL &_C_RESET
PROMPT  &_C_YELLOW 2: &_C_BLUE Show sql_id xplan history &_C_RESET
PROMPT  &_C_YELLOW 3: &_C_BLUE Show SQL text, child cursors and execution stats for SQL_ID &_C_RESET
PROMPT  &_C_YELLOW 4: &_C_BLUE Show current execution plan for SQL_ID &_C_RESET
PROMPT  &_C_YELLOW 5: &_C_BLUE Show historic execution plan for SQL_ID from awr&_C_RESET
PROMPT  &_C_YELLOW 6: &_C_BLUE Generate sql_monitor report from awr&_C_RESET
PROMPT  &_C_YELLOW 6a: &_C_BLUE Generate active sql_monitor report from awr&_C_RESET
PROMPT  &_C_YELLOW 7: &_C_BLUE Disaply sql_id pga usage per execution from awr&_C_RESET
PROMPT  &_C_YELLOW 8: &_C_BLUE run ash snapper &_C_RESET
PROMPT  &_C_YELLOW 9: &_C_BLUE go back &_C_RESET
PROMPT  &_C_YELLOW 10: &_C_BLUE exit &_C_RESET
accept selection PROMPT "&_C_RED Enter option 1-10: &_C_RESET"

set termout off feedback off echo off verify off
column script new_value v_script  
select case '&selection.' 
       when '1' then '@display_longop_on_sid_serial.sql'
	   when '2' then '@display_sqlid_plan_history.sql'
	   when '3' then '@sqlid.sql'	   
       when '4' then '@xplan.sql'
	   when '5' then '@xplan_awr.sql'
	   when '6' then '@gen_sql_mon_rpt.sql'
	   when '6a' then '@gen_sql_mon_rpt_active.sql'
	   when '7' then '@gen_sql_id_pga_rpt.sql'
	   when '8' then '@pre_snapper.sql' 
	   when '9' then '@oraPerfDiag2'  
	   when '10' then '@exit.sql'
       else '@rtdiag_2.sql' --this script
       end as script 
from dual; 

set termout on

@&v_script 
