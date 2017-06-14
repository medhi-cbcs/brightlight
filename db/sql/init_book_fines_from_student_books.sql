update book_fines
set grade_level_id = sbf.glid, 
    grade_section_id = sbf.gsid, 
    student_book_id = sbf.sbid
from (select book_fines.id as bid, sb.grade_level_id as glid, sb.grade_section_id as gsid, 
	sb.id as sbid
    from book_fines 
    join student_books sb on sb.book_copy_id = book_fines.book_copy_id 
	and sb.academic_year_id = 16) sbf
where book_fines.id = sbf.bid
