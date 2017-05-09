SELECT book_loans.*, subjects.name as subject, book_editions.title as title 
FROM book_loans
LEFT JOIN book_titles ON book_titles.id = book_loans.book_title_id
LEFT JOIN book_editions ON book_editions.id = book_loans.book_edition_id
LEFT JOIN subjects ON subjects.id = book_titles.subject_id
