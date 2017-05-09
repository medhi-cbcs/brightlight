SELECT * FROM book_receipts
JOIN grade_sections_students gss ON gss.order_no = book_receipts.roster_no 
	AND gss.academic_year_id = book_receipts.academic_year_id
	AND gss.grade_section_id = book_receipts.grade_section_id
WHERE book_receipts.academic_year_id = 16
AND book_receipts.grade_level_id = 11
AND book_copy_id not in (
SELECT book_copy_id FROM book_loans
WHERE academic_year_id = 16
AND grade_level_id = 11
)