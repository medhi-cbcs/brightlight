/* This will update book_copies.book_condition_id with the latest 
   book condition inputted for the corresponding book in copy_conditions
   table.
*/
update book_copies bc
set book_condition_id =
 (SELECT book_conditions.id FROM "copy_conditions" 
	INNER JOIN "book_conditions" 
	ON "book_conditions"."id" = "copy_conditions"."book_condition_id" 
	WHERE "copy_conditions"."book_copy_id" = bc.id 
	AND (deleted_flag = false OR deleted_flag is NULL)  
	ORDER BY copy_conditions.academic_year_id DESC,copy_conditions.created_at DESC LIMIT 1)
