update book_copies bc
set status_id = 5
where exists (select * from (
select cc.book_copy_id as id, cc.book_condition_id , bc.book_condition_id, bc.status_id, l.student_id, l.employee_id
from copy_conditions cc
inner join (
    select book_copy_id, max(created_at) as time_stamp
    from copy_conditions where academic_year_id = 16
    group by book_copy_id) q
on cc.book_copy_id = q.book_copy_id and cc.created_at = q.time_stamp
inner join book_copies bc on bc.id = cc.book_copy_id
left join book_loans l on l.book_copy_id = bc.id and l.academic_year_id = 16
where cc.book_condition_id = 5 and student_id is null and employee_id is null
order by cc.book_copy_id
) x where x.id = bc.id)