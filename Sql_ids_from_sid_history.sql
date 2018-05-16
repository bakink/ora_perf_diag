select t.session_id, t.SESSION_SERIAL#,t.sql_id,t.program, t.BLOCKING_SESSION,t.BLOCKING_SESSION_SERIAL#,TO_CHAR(SUBSTR(p.sql_text,0,3999)) sqltext
from   dba_hist_active_sess_history t, dba_hist_snapshot s,  dba_hist_sqltext p
where  t.snap_id = s.snap_id and t.sql_id=p.sql_id
and    t.dbid = s.dbid
and    t.instance_number = s.instance_number
and    t.session_id = &_sid
and    t.SESSION_SERIAL# = &_serial
and    s.begin_interval_time between to_date ('&_starttime','YYYY/MM/DD HH24:MI:SS') and to_date ('&_endtime','YYYY/MM/DD HH24:MI:SS');

@@rtdiag_1