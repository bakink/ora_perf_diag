-- Query to find Top # wait events in database:
PROMPT
accept _num_event PROMPT "&_C_RED Enter # of top wait events to display [default 5]: &_C_RESET" default 5
accept _num_day PROMPT "&_C_RED Enter # of days to display [default 5]: &_C_RESET" default 5
break on day
column day format a9
column event_name format a30
column total_wait format 999,999,999

select Day, Event_name, Total_wait from (
select day, event_name, sum(event_time_waited) total_wait,
row_number() over (partition by day order by sum(event_time_waited) desc) rn from (
SELECT   to_date(to_char(begin_interval_time,'dd/mm/yyyy'),'dd/mm/yyyy') day,s.begin_interval_time, m.*
    FROM (SELECT ee.instance_number, ee.snap_id, ee.event_name,
                 ROUND (ee.event_time_waited / 1000000) event_time_waited,
                 ee.total_waits,
                 ROUND ((ee.event_time_waited * 100) / et.total_time_waited,
                        1
                       ) pct,
                 ROUND ((ee.event_time_waited / ee.total_waits) / 1000
                       ) avg_wait
            FROM (SELECT ee1.instance_number, ee1.snap_id, ee1.event_name,
                           ee1.time_waited_micro - ee2.time_waited_micro event_time_waited,
                         ee1.total_waits - ee2.total_waits total_waits
                    FROM dba_hist_system_event ee1 JOIN dba_hist_system_event ee2
                         ON ee1.snap_id = ee2.snap_id + 1
                       AND ee1.instance_number = ee2.instance_number
                       AND ee1.event_id = ee2.event_id
                       AND ee1.wait_class_id <> 2723168908
                       AND ee1.time_waited_micro - ee2.time_waited_micro > 0
                  UNION
                  SELECT st1.instance_number, st1.snap_id,
                         st1.stat_name event_name,
                         st1.VALUE - st2.VALUE event_time_waited,
                         1 total_waits
                    FROM dba_hist_sys_time_model st1 JOIN dba_hist_sys_time_model st2
                         ON st1.instance_number = st2.instance_number
                       AND st1.snap_id = st2.snap_id + 1
                       AND st1.stat_id = st2.stat_id
                       AND st1.stat_name = 'DB CPU'
                       AND st1.VALUE - st2.VALUE > 0
                         ) ee
                 JOIN
                 (SELECT et1.instance_number, et1.snap_id,
                         et1.VALUE - et2.VALUE total_time_waited
                    FROM dba_hist_sys_time_model et1 JOIN dba_hist_sys_time_model et2
                         ON et1.snap_id = et2.snap_id + 1
                       AND et1.instance_number = et2.instance_number
                       AND et1.stat_id = et2.stat_id
                       AND et1.stat_name = 'DB time'
                       AND et1.VALUE - et2.VALUE > 0
                         ) et
                 ON ee.instance_number = et.instance_number
               AND ee.snap_id = et.snap_id
                 ) m
         JOIN
         dba_hist_snapshot s ON m.snap_id = s.snap_id
) group by day ,event_name
order by day desc, total_wait desc
)where day > sysdate-&_num_day and rn <= &_num_event;

column day clear;
column event_name clear;
column total_wait clear;
undef _num_event
undef _num_day

@@rtdiag_1.sql