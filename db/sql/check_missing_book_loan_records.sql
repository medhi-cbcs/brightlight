SELECT b.id, s.book_loan_id, s.id, s.student_id, students.name, s.barcode, s.book_copy_id, s.academic_year_id, s.created_at
FROM student_books s
LEFT JOIN book_loans b ON s.book_copy_id = b.book_copy_id AND s.academic_year_id = b.academic_year_id AND s.student_id = b.student_id
JOIN students ON s.student_id = students.id
WHERE s.student_id is not null and s.book_loan_id is null and s.academic_year_id = 16
ORDER BY s.created_at DESC