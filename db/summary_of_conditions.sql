select bc.id, bc.book_condition_id, cc.book_condition_id from book_copies bc
left join copy_conditions cc on cc.book_copy_id = bc.id
where bc.book_edition_id = 566 and cc.id = (select id from copy_conditions 
where book_copy_id = bc.id order by academic_year_id desc, created_at desc
limit 1)
