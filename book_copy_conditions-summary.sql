select c.id, c.code, count(bc.*)
from book_copies bc
left join copy_conditions cc on cc.book_copy_id = bc.id
	and cc.id = (select id from copy_conditions 
			where book_copy_id = bc.id order by academic_year_id desc, created_at desc
			limit 1) 
left join book_conditions c on cc.book_condition_id = c.id			
where bc.book_edition_id = 1203
group by c.id, c.code
order by c.id