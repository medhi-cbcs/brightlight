SELECT
    id, x.book_copy_id, x.barcode, x.employee_id, x.student_id
FROM book_loans x
INNER JOIN 
	(SELECT
	    book_copy_id, barcode, employee_id, student_id, academic_year_id, COUNT(*)
	FROM book_loans
	WHERE academic_year_id = 16
	GROUP BY book_copy_id, academic_year_id, employee_id, student_id, barcode
	HAVING COUNT(*) > 1	
	) y ON x.book_copy_id = y.book_copy_id
ORDER BY x.employee_id, x.book_copy_id

    