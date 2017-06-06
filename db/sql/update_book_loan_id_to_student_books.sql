UPDATE student_books s
SET book_loan_id = b.id
FROM book_loans b
WHERE 
    s.book_copy_id = b.book_copy_id 
	AND s.academic_year_id = b.academic_year_id
	AND s.student_id = b.student_id
	AND b.student_id is not null