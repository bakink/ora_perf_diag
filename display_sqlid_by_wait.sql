column event format a35 wrap
column sql_id format a14
column sample_time format a25
column execution format  999,999

set feedback off echo off verify off
PROMPT
accept _event PROMPT "&_C_RED Enter event: &_C_RESET" 

select event, sql_id, sample_time, count(sql_exec_id) execution from v$active_session_history where event like '&_event' group by event, sql_id,sample_time order by sample_time;

undefine _event
column event clear;
column sql_id clear;
column sample_time clear;
column execution clear;

@@rtdiag_1