column inst_id format 99
column owner format a15
column object_name format a40
column object_type format a15
column event format a30

select * from (
SELECT
  A.inst_id,   
  A.CURRENT_OBJ#,
  D.OWNER,
  D.OBJECT_NAME,
  D.OBJECT_TYPE,
  A.EVENT,
  SUM(A.WAIT_TIME + A.TIME_WAITED) TOTAL_WAIT_TIME
FROM
  gV$ACTIVE_SESSION_HISTORY A,
  DBA_OBJECTS D
WHERE
  A.CURRENT_OBJ# = D.OBJECT_ID
GROUP BY
  A.inst_id,
  A.CURRENT_OBJ#,
  D.OWNER,
  D.OBJECT_NAME,
  D.OBJECT_TYPE,
  A.EVENT
ORDER BY
  TOTAL_WAIT_TIME DESC
) 
where rownum<=20;

column inst_id clear;
column owner clear;
column object_name clear;
column object_type clear;
column event clear;

@@rtdiag_1.sql