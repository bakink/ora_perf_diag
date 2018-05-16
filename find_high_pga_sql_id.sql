PROMPT
accept _starttime PROMPT "&_C_RED Enter start time[YYYY/MM/DD HH24:MI:SS]: &_C_RESET" 
accept _endtime PROMPT "&_C_RED Enter end time[YYYY/MM/DD HH24:MI:SS]: &_C_RESET"

column sql_id format a16
column star format a10
column PGA_MB format 999,999.999
column percent format 99.99


select SQL_ID,round(PGA_MB,1) PGA_MB,percent,rpad('*',percent*10/100,'*') star
from
(
select SQL_ID,sum(DELTA_PGA_MB) PGA_MB ,(ratio_to_report(sum(DELTA_PGA_MB)) over ())*100 percent,rank() over(order by sum(DELTA_PGA_MB) desc) rank
from
(
select SESSION_ID,SESSION_SERIAL#,sample_id,SQL_ID,SAMPLE_TIME,IS_SQLID_CURRENT,SQL_CHILD_NUMBER,PGA_ALLOCATED,
greatest(PGA_ALLOCATED - first_value(PGA_ALLOCATED) over (partition by SESSION_ID,SESSION_SERIAL# order by sample_time rows 1 preceding),0)/power(1024,2) "DELTA_PGA_MB"
from
v$active_session_history
where
IS_SQLID_CURRENT='Y'
and sample_time > to_date('&_starttime','YYYY/MM/DD HH24:MI:SS') and sample_time < to_date('&_endtime','YYYY/MM/DD HH24:MI:SS')
order by 1,2,3,4
)
group by sql_id
having sum(DELTA_PGA_MB) > 0
)
where rank <10 order by rank;


column sql_id clear
column sql_id clear
column star clear
column PGA_MB clear
column percent clear

undef _starttime
undef _endtime

@@rtdiag_1
