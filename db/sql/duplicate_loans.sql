select academic_year_id, name, barcode, title, count(*)
from book_loans
join employees on employee_id = employees.id
join book_editions on book_editions.id = book_loans.book_edition_id
group by academic_year_id, employee_id, book_copy_id, barcode, employees.name, book_editions.title
having count(*) > 1
	--and academic_year_id = 16
order by academic_year_id DESC,employee_id, book_copy_id