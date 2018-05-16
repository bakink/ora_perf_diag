PROMPT
PROMPT  &_C_RED Information from v$active_session_history and dba_hist_active_sess_history
PROMPT  &_C_RED**********************************************************************************
PROMPT * The V$ACTIVE_SESSION_HISTORY view provides sampled session activity in the instance. 
PROMPT * Oracle samples the database every second and stores details of every session 
PROMPT * that is considered “active”, meaning that it is waiting on a non-idle wait event 
PROMPT * or is executing on a CPU.
PROMPT * The underlying data store for Active Session History is a circular memory buffer.
PROMPT * Every 10th sample from v$active_session_history is saved into 
PROMPT * the Active Workload Repository (AWR) and exposed via the view 
PROMPT * dba_hist_active_sess_history. From within v$active_session_history, 
PROMPT * you can tell which samples have been saved from the flag 
PROMPT * stored in the IS_AWR_SAMPLE column.
PROMPT * how long will an entry remain in the ASH buffer before being overwritten?
PROMPT * it depends on how many active sessions there have been in the database. 
PROMPT * You may find that it takes a day or more before details are overwritten 
PROMPT * or it could be a few hours or less.
PROMPT **********************************************************************************
PROMPT &_C_RESET

PROMPT  &_C_CYAN#####################################
PROMPT # using v$active_session_history
PROMPT  #####################################&_C_RESET
PROMPT  &_C_YELLOW 1: &_C_GREEN Display Minimum sample time in v$active_session_history &_C_RESET
PROMPT  &_C_YELLOW 2: &_C_GREEN Diaplay top wait events at each sample time &_C_RESET
PROMPT  &_C_YELLOW 3: &_C_GREEN Display most active sqls &_C_RESET
PROMPT  &_C_YELLOW 4: &_C_GREEN Display SQL_IDs of top elapsed_time &_C_RESET 
PROMPT  &_C_YELLOW 5: &_C_GREEN Display top ASH time (count of ASH samples) &_C_RESET

PROMPT  &_C_CYAN#####################################
PROMPT # using dba_hist_active_sess_history
PROMPT  #####################################&_C_RESET
PROMPT  &_C_YELLOW 6: &_C_GREEN Diaplay top wait events at each sample time &_C_RESET
PROMPT  &_C_YELLOW 7: &_C_GREEN Display SQL_IDs of top elapsed_time &_C_RESET
PROMPT  &_C_YELLOW 8: &_C_GREEN Display execution plan history &_C_RESET
PROMPT  &_C_YELLOW 9: &_C_GREEN Display top ASH time (count of ASH samples) &_C_RESET
PROMPT  &_C_YELLOW &_C_GREEN  &_C_RESET 

PROMPT  &_C_YELLOW 10a: &_C_GREEN run problematic query by SQL(not implemented yet) ID &_C_RESET
PROMPT  &_C_YELLOW 10b: &_C_GREEN (step 1 first to identify sql_id)eXplain from Memory with Stats by SQL ID &_C_RESET
PROMPT  &_C_YELLOW 11: &_C_BLUE go back &_C_RESET
PROMPT  &_C_YELLOW 12: &_C_BLUE exit &_C_RESET
accept selection PROMPT "&_C_RED Enter option 1-10: &_C_RESET"

set termout off feedback off echo off verify off
column script new_value v_script  
select case '&selection.' 
	   when '1' then '@display_ash_min_sample_time.sql'
	   when '2' then '@display_ash_top_wait_events.sql'
	   when '3' then '@display_ASH_most_active_sqls.sql'
	   when '4' then '@display_ASH_SQL_ID_elapsed_time.sql'
	   when '5' then '@display_ash_top_by_waitclass.sql'
	   when '6' then '@display_dash_top_wait_events.sql'
       when '7' then '@display_dash_sql_ids_top_eleapsed_time.sql'
	   when '8' then '@display_dash_execution_plan.sql' 
	   when '9' then '@display_hist_ash_top_by_waitclass.sql'
	   when '3a' then '@dummy.sql'	   
       when '3b' then '@xmsi.sql'
	   when '11' then '@oraPerfDiag1.sql'  
	   when '12' then '@exit.sql'
       else '@oraPerfDiag4.sql' --this script
       end as script 
from dual; 

set termout on

@&v_script 
