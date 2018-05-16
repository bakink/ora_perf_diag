column sample_time format a25
column event_name format a30
column waits format 999,999
column time_waited format 999,999 heading 'time waited(ms)'
column sid format a10
column state format a15
column sql_id format a20
column sql_text format a120 word_wrap

set linesize 999

SELECT '&_C_MAGENTA'||A.SESSION_ID sid,
TRIM(A.SAMPLE_TIME) sample_time,
TRIM(B.NAME) event_name,
COUNT(*) waits, 
SUM(TIME_WAITED/1000) time_waited,
'&_C_BLUE'||A.SESSION_STATE state,
'&_C_RED'||C.SQL_ID sql_id,
'&_C_GREEN'||C.SQL_TEXT||'&_C_RESET' sql_text
FROM v$ACTIVE_SESSION_HISTORY A,v$EVENT_NAME B,v$SQLAREA C 
WHERE to_char(A.SAMPLE_TIME, 'DD-MON-YY HH24.MI.SS')BETWEEN '25-JUN-14 21:00:00' AND '25-JUN-14 22:00:00' 
AND A.EVENT=B.NAME 
AND A.SQL_ID = C.SQL_ID 
GROUP BY A.SESSION_ID,A.SAMPLE_TIME, C.SQL_TEXT, B.NAME, C.SQL_ID,A.SESSION_STATE
ORDER BY 4,3 DESC;

column sample_time clear;
column event_name clear;
column waits clear;
column time_waited clear;
column sql_id clear;
column sql_text clear;

@@rtdiag_1.sql