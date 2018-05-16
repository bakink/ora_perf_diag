PROMPT
PROMPT  &_C_RED Real Time Diag STEP 2 &_C_RESET
PROMPT  &_C_RED ************************************************************************* &_C_RESET
PROMPT  &_C_YELLOW 1: &_C_BLUE Show SQL plan baseline from SQL text &_C_RESET
PROMPT  &_C_YELLOW 2: &_C_BLUE Load SQL plan from cursor cache for SQL_ID &_C_RESET
PROMPT  &_C_YELLOW 3: &_C_BLUE Purge SQL_ID from shared pool &_C_RESET
PROMPT  &_C_YELLOW 4: &_C_BLUE Show SQL handle from plan basename (using dba_sql_plan_baselines)&_C_RESET
PROMPT  &_C_YELLOW 5: &_C_BLUE Show sql_id from SQL handle&_C_RESET
PROMPT  &_C_YELLOW 6: &_C_BLUE run ash snapper &_C_RESET
PROMPT  &_C_YELLOW 7: &_C_BLUE go back &_C_RESET
PROMPT  &_C_YELLOW 8: &_C_BLUE exit &_C_RESET
accept selection PROMPT "&_C_RED Enter option 1-7: &_C_RESET"

set termout off feedback off echo off verify off
column script new_value v_script  
select case '&selection.' 
       when '1' then '@sqlplanbaseline_from_sqltext.sql'  
       when '2' then '@load_plan_from_cursorcache.sql'
	   when '4' then '@purge_sqlid.sql'
	   when '5' then '@sqlid_from_sqlhandle.sql'
	   when '6' then '@pre_snapper.sql' 
	   when '7' then '@oraPerfDiag1.sql'  
	   when '8' then '@exit.sql'
       else '@oraPerfDiag3.sql' --this script
       end as script 
from dual; 

set term on

@&v_script 
