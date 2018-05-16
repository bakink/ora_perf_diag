PROMPT
accept _starttime PROMPT "&_C_RED Enter start time[YYYY/MM/DD HH24:MI:SS]: &_C_RESET" 
accept _endtime PROMPT "&_C_RED Enter end time[YYYY/MM/DD HH24:MI:SS]: &_C_RESET"

column sql_id format a14
column sqltext format a200 wrap

-- select sql_id, TO_CHAR(SUBSTR(sql_text,0,3999)) sql_text from dba_hist_sqltext where sql_text like 'SELECT COUNT(*) FROM TD_Member%AND ROWNUM <= 20000';


select t.sql_id,TO_CHAR(SUBSTR(p.sql_text,0,3999)) sqltext,sum(t.elapsed_time_delta/1000000) t_elaps, sum(t.executions_delta) execs, case when sum(t.executions_delta)=0 then 0 else ROUND((sum(t.elapsed_time_delta/1000000)/sum(t.executions_delta)),2) end elap
from   dba_hist_sqlstat t, dba_hist_snapshot s,  dba_hist_sqltext p
where  t.snap_id = s.snap_id and t.sql_id=p.sql_id
and    t.dbid = s.dbid
and    t.instance_number = s.instance_number
and    s.begin_interval_time between to_date ('&_starttime','YYYY/MM/DD HH24:MI:SS') and to_date ('&_endtime','YYYY/MM/DD HH24:MI:SS')
group  by t.sql_id,TO_CHAR(SUBSTR(p.sql_text,0,3999))
order by elap desc, execs desc;

undef _starttime
undef _endtime

@@rtdiag_1
