select gss.order_no, gss.track, st.name, count(*) from book_loans bl
join students st ON st.id = bl.student_id
join grade_sections_students gss ON gss.student_id = st.id 
	and gss.academic_year_id = 16
where bl.academic_year_id = 16 and gss.grade_section_id = 41
group by st.id, gss.track, gss.order_no
order by gss.order_no