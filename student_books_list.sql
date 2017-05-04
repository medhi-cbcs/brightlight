select * from student_books
LEFT JOIN grade_sections_students gss ON gss.student_id = student_books.student_id
	AND gss.academic_year_id = student_books.academic_year_id
JOIN standard_books ON student_books.book_edition_id = standard_books.book_edition_id
            AND standard_books.grade_level_id = student_books.grade_level_id
            AND standard_books.book_category_id = 1
            AND standard_books.academic_year_id = student_books.academic_year_id
            AND (standard_books.track = gss.track OR standard_books.track is null)
LEFT JOIN book_editions ON student_books.book_edition_id = book_editions.id
WHERE student_books.academic_year_id = 16
	AND student_books.grade_level_id = 11
