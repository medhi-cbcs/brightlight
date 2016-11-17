select ss.id, ss.name, f.total from (
select s.id, s.name, count(bc.*) total from book_copies bc 
left join statuses s on s.id = bc.status_id --where bc.book_edition_id = 1576
group by s.id, s.name order by s.id
) f full outer join statuses ss on ss.id = f.id