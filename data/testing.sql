truncate buildhooks;
truncate buildhook_results;

select
    (select count(*) from buildhooks) buildhooks,
    (select count(*) from buildhook_results) buildhook_results
;

select (finished_at - started_at) as sec_diff, count(*) as cnt
from buildhooks
group by sec_diff;


select
    count(*) as total_columns_updated
     ,max(revision) as revisions
     ,min(created_on) as first_created
     ,max(created_on) as last_updated
     ,timediff(max(created_on), min(created_on)) as diff
from audit_status
where pk_id = 3
group by pk_id
;