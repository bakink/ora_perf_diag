@inc/colors;
PROMPT
PROMPT  &_C_RED Real Time Diag STEP 1 &_C_RESET
PROMPT  &_C_RED ************************************************************************* &_C_RESET
PROMPT  &_C_YELLOW 1: &_C_BLUE Display top sql in ash &_C_RESET
PROMPT  &_C_YELLOW 2: &_C_BLUE Display top sqls in v$sql_monitor &_C_RESET
PROMPT  &_C_YELLOW 3: &_C_BLUE Display top sqls of high PGA &_C_RESET
PROMPT  &_C_YELLOW 4: &_C_BLUE Display daily top wait events &_C_RESET
PROMPT  &_C_YELLOW 5: &_C_BLUE Display objects of top wait events &_C_RESET
PROMPT  &_C_YELLOW 6: &_C_BLUE Display active sessions &_C_RESET
PROMPT  &_C_YELLOW 7: &_C_BLUE Display blocking sessions and objects &_C_RESET
PROMPT  &_C_YELLOW 7a: &_C_BLUE Display blocking sessions &_C_RESET
PROMPT  &_C_YELLOW 8: &_C_BLUE Session wait by username &_C_RESET
PROMPT  &_C_YELLOW 9: &_C_BLUE Session wait by sid &_C_RESET
PROMPT  &_C_YELLOW 10: &_C_BLUE Find sql_id from top wait event &_C_RESET
PROMPT  &_C_YELLOW 11: &_C_BLUE Find sid from sql_id &_C_RESET
PROMPT  &_C_YELLOW 12: &_C_BLUE Display sql_id by wait event &_C_RESET
PROMPT  &_C_YELLOW 13: &_C_BLUE Display sql_ids in a time range &_C_RESET
PROMPT  &_C_YELLOW 14: &_C_BLUE Display sql_ids  from an sid in a time range &_C_RESET
PROMPT  &_C_YELLOW 15: &_C_BLUE Display session PGA usage &_C_RESET
PROMPT  &_C_YELLOW 16: &_C_BLUE Top PGA sqls &_C_RESET
PROMPT  &_C_YELLOW 17: &_C_BLUE Top Sharedpool sqls &_C_RESET
PROMPT  &_C_YELLOW 18: &_C_BLUE Skip to step 2 (XPLAN) &_C_RESET
PROMPT  &_C_YELLOW 19: &_C_BLUE Skip to step 3 (PLAN MGMT)&_C_RESET
PROMPT  &_C_YELLOW 20: &_C_BLUE Skip to step 4 (ASH) &_C_RESET
PROMPT  &_C_YELLOW 21: &_C_BLUE Exit &_C_RESET
accept selection PROMPT "&_C_RED Enter option 1-21: &_C_RESET"

set termout off feedback off echo off verify off
set linesize 300
set pagesize 999
set long 2000000
column script new_value v_script  
select case '&selection.' 
       when '1' then '@top_sql_from_ash.sql'
	   when '2' then '@top20sqls.sql'
	   when '3' then '@find_high_pga_sql_id.sql'
	   when '4' then '@daily_top_waits.sql'
	   when '5' then '@find_object_on_wait.sql'
	   when '6' then '@as.sql'
	   when '7' then '@display_locks.sql'
	   when '7a' then '@display_sess_locks.sql'
	   when '8' then '@find_sesswait_byuser.sql'
       when '9' then '@find_sesswait_bysid.sql'
       when '10' then '@find_sqlid_from_topevent.sql'
	   when '11' then '@find_sid_by_sql_id.sql' 
	   when '12' then '@display_sqlid_by_wait.sql'
	   when '13' then '@sqls_in_time_range.sql'
	   when '14' then '@Sql_ids_from_sid_history.sql'
	   when '15' then '@sessions_orderby_PGA.sql'
	   when '16' then '@find_high_pga_sql_id.sql'
	   when '17' then '@top_sharedpool_sqls.sql'
	   when '18' then '@oraPerfDiag2.sql.sql'
	   when '19' then '@oraPerfDiag3.sql'
	   when '20' then '@oraPerfDiag4.sql'
	   when '21' then '@exit.sql'
       else '@oraPerfDiag0.sql' --this script
       end as script 
from dual; 

set termout on

@&v_script 
