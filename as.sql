-- display Active Sessions
set pagesize 999
set lines 300
col username format a13
col prog format a30 wrap
col machine format a15
col sql_text format a80 wrap
col sid format 9999
col child for 99999
col avg_etime for 999,999.999999
col execs for 999,999,999
break on sql_text
select username, sid, serial#, substr(program,1,30) prog, machine, b.sql_id, child_number child, plan_hash_value, executions execs, 
(elapsed_time/decode(nvl(executions,0),0,1,executions))/1000000 avg_etime, 
sql_text
from v$session a, v$sql b
where status = 'ACTIVE'
and username is not null
and a.sql_id = b.sql_id
and a.sql_child_number = b.child_number
and sql_text not like 'select sid, substr(program,1,19) prog, b.sql_id, child_number child,%' -- don't show this query
and sql_text not like 'declare%' -- skip PL/SQL blocks
order by sql_id, child
/

@@rtdiag_1.sql