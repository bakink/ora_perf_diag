set feedback off echo off verify off
PROMPT
accept _sql_id PROMPT "&_C_RED Enter SQL_ID: &_C_RESET" 
accept _num_days PROMPT "&_C_RED Enter number of days: &_C_RESET" 

column SAMPLE_TIME format a26
column sql_opname format a10
column sql_exec_start format a26
column machine format a12
column program format a20 trunc
column sql_text format a40 wrap
column osuer format a10
select a.session_id, a.SAMPLE_TIME, a.SQL_OPNAME, a.SQL_EXEC_START, a.machine, a.program, a.client_id, b.SQL_TEXT
--from DBA_HIST_ACTIVE_SESS_HISTORY a, 
from v$ACTIVE_SESSION_HISTORY a,
     dba_hist_sqltext b --v$sqltext b
where a.SQL_ID = b.SQL_ID and a.SQL_ID='&_sql_id'
--and a.SAMPLE_TIME > sysdate-.0625
order by a.SQL_EXEC_START asc;

col SAMPLE_TIME clear
col sql_opname clear
col sql_exec_start clear
col machine clear
col program clear
col sql_text clear
col osuer clear

undef _sql_id
undef _num_days

&&rtdiag_1