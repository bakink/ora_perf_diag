col "Stmt" for a100 wrap

select * from (SELECT sql_text "Stmt", sql_id, count(*),
  sum(sharable_mem)/1024/1024 "Mem",
  sum(users_opening) "Open",
  sum(executions) "Exec"
  FROM v$sql
GROUP BY sql_text, sql_id
order by "Mem" desc)
where rownum<20;

--HAVING sum(sharable_mem) > (select current_size*0.01 from v$sga_dynamic_components where component='shared pool');

col "Stmt" clear