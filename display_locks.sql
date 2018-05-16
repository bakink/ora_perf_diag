prompt &_C_MAGENTA #####################################################################&_C_RESET
prompt &_C_MAGENTA ###   find blocking sessions with v$session &_C_RESET
prompt &_C_MAGENTA #####################################################################&_C_RESET

column blocking_session format 99999
column sid format 99999
column serial# format 99999999
column seconds_in_wait format 999,999,999
SELECT
   blocking_session, 
   sid, 
   serial#, 
   seconds_in_wait
FROM
   v$session s
WHERE
   blocking_session IS NOT NULL;
   
prompt &_C_MAGENTA #####################################################################&_C_RESET
prompt &_C_MAGENTA ###   find blocking sessions with v$session and v$lock &_C_RESET
prompt &_C_MAGENTA #####################################################################&_C_RESET

column   blocking_status format a50

SELECT s1.username || '@' || s1.machine
    || ' ( SID=' || s1.sid || ' )  is blocking '
    || s2.username || '@' || s2.machine || ' ( SID=' || s2.sid || ' ) ' AS blocking_status
    FROM v$lock l1, v$session s1, v$lock l2, v$session s2
    WHERE s1.sid=l1.sid AND s2.sid=l2.sid
    AND l1.BLOCK=1 AND l2.request > 0
    AND l1.id1 = l2.id1
    AND l1.id2 = l2.id2;
	
prompt &_C_MAGENTA #####################################################################&_C_RESET
prompt &_C_MAGENTA ###   find blocking sessions with v$session and v$lock &_C_RESET
prompt &_C_MAGENTA ###   TM: DML enqueue - acquired during the execution of a statement
prompt &_C_MAGENTA ###       when referencing a table so that the table is not dropped
prompt &_C_MAGENTA ###       or altered during the execution of it. for example, tb with fk
prompt &_C_MAGENTA ###   TX: Transaction enqueue - acquired exclusive when a transaction
prompt &_C_MAGENTA ###       initiates its first change and is held until the transaction
prompt &_C_MAGENTA ###       does a COMMIT or ROLLBACK. i.e. row locking
prompt &_C_MAGENTA #####################################################################&_C_RESET

column sid format 99999
column TYPE format a4
column OWNER format a12
column object_name format a20

-- EXPLAIN PLAN 
--  SET statement_id = 'ex_plan' FOR
-- have to define subquery block on l_obj and force nested loop on it
with l_obj as (SELECT /*+ QB_NAME(subq) */ sid, type, id1 FROM v$lock l WHERE l.TYPE in ('TM','TX'))
SELECT /*+ LEADING(o) USE_NL(@subq l) */ l.sid,l.type, o.owner, o.object_name FROM l_obj l, dba_objects o WHERE l.id1=o.object_id;

-- SELECT PLAN_TABLE_OUTPUT 
--  FROM TABLE(DBMS_XPLAN.DISPLAY(NULL, 'ex_plan','BASIC'));

column blocking_status clear;  
column sid clear;
column TYPE clear;
column OWNER clear;
column object_name clear;

@@rtdiag_1