UPDATE public.student_books
--SELECT *
   SET deleted_flag=true
  FROM copy_conditions
 WHERE student_books.book_copy_id = copy_conditions.book_copy_id
	AND student_books.academic_year_id = 15
	AND copy_conditions.academic_year_id = 15
	AND copy_conditions.deleted_flag = false
	AND copy_conditions.post = 0
	AND copy_conditions.book_condition_id = 4;
