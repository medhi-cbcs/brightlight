SELECT *
  FROM book_fines
  LEFT JOIN students ON students.id = book_fines.student_id 
  LEFT JOIN grade_sections_students ON
   grade_sections_students.student_id = book_fines.student_id
   and book_fines.academic_year_id = grade_sections_students.academic_year_id
 WHERE book_fines.academic_year_id =15
 and grade_sections_students.id is null
