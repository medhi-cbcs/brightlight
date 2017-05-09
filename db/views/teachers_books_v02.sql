SELECT book_loans.*, subjects.name as subject, 
    e.title as title, e.authors, e.isbn10, e.isbn13, e.publisher, e.small_thumbnail,
    l.id as check_id, l.user_id as checked_by, l.loaned_to, l.scanned_for, l.emp_flag, l.matched, l.notes as check_notes
FROM book_loans
LEFT JOIN book_titles ON book_titles.id = book_loans.book_title_id
LEFT JOIN book_editions e ON e.id = book_loans.book_edition_id
LEFT JOIN subjects ON subjects.id = book_titles.subject_id
LEFT JOIN loan_checks l ON l.book_loan_id = book_loans.id
	and l.academic_year_id = book_loans.academic_year_id
	and l.loaned_to = book_loans.employee_id
	and l.matched = true