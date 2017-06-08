update student_books s
set student_id = converted.stuid, student_no = converted.stuno
from (select s.id as sid, s.student_id, so.name, st.id as stuid, st.name, st.student_no as stuno
	from student_books s
	join grade_sections_students gss on cast(s.roster_no as integer) = gss.order_no 
	and gss.academic_year_id = s.academic_year_id
	and gss.grade_section_id = s.grade_section_id
	join students st on st.id = gss.student_id and gss.academic_year_id = 16
	join students so on so.id = s.student_id
	where s.academic_year_id = 16 and s.grade_section_id = 35) converted
where s.id = converted.sid