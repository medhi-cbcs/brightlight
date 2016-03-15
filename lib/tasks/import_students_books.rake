namespace :data do
	desc "Import grade_sections attributes"
	task import_grade_section_attributes: :environment do

		# Read Book rent from CBCS_INVBOOKSRENT
    xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    sheet = xl.sheet('CBCS_INVBOOKSRENT')
  	
  	header = {student_no:'RENTSTUDENTID',	family_no:'RENTFAMILYID',	class_order:'RENTSTUDENTNUM',	barcode:'RENTBARCODEID',	isbn:'RENTISBN', 
  		refno:'RENTBKREFERENCE', category:'RENTCategory',	rent_status:'RENTSTATUS',	class_level:'RENTClassLevelID',	subject_code:'RENTSubjectID',	
  		rent_date:'RENTDATEGET', rent_time:'RENTTIMEGET',	return_date:'RENTDATERETURN',	user_id:'RENTIDUSER',	date_input:'RENTDATEINPUT',	
  		time_input:'RENTTIMEINPUT',	index:'RENTINDEX',	notes:'RENTNOTE',	new_academic_year:'RENTNewAcademicYear',	academic_year:'RENTYearAcademic',	
  		return_status:'RENTRETURNSTATUS',	bkudid:'BKUDID',	noteqpr:'NOTEOPR',}
    
    sheet.each_with_index(header) do |row,i|
			next if i < 1
		  next if row[:index] == 0

		  book_copy = BookCopy.find_by_barcode(row[:barcode])
		  student_book = StudentBook.new(
		  	student: Student.find_by_student_no(row[:student_no]),
		  	book_copy: book_copy,
		  	academic_year: AcademicYear.find_by_name(row[:academic_year]),
		  	issue_date: row[:rent_date],
		  	return_date: row[:return_date],
		  	copy_no: row[:class_order]
		  )
		  # student_book.save

		  loan = BookLoan.new(
		  	book_copy: book_copy,
		  	book_edition: book_copy.book_edition,
		  	book_title: BookTitle.find_by_bkudid(row[:bkudid]),
		  	academic_year: AcademicYear.find_by_name(row[:academic_year]),
				out_date: row[:rent_date],
		  	due_date: row[:return_date],
		  	book_category: BookCategory.find_by_code(row[:category])
		  )
		  # loan.save

 		end
  end
end

# create_table "student_books", force: :cascade do |t|
#   t.integer  "student_id"
#   t.integer  "book_copy_id"
#   t.integer  "academic_year_id"
#   t.integer  "course_text_id"
#   t.string   "copy_no"
#   t.integer  "grade_section_id"
#   t.integer  "grade_level_id"
#   t.integer  "course_id"
#   t.date     "issue_date"
#   t.date     "return_date"
#   t.integer  "initial_copy_condition_id"
#   t.integer  "end_copy_condition_id"
#   t.datetime "created_at",                null: false
#   t.datetime "updated_at",                null: false
# end	

# create_table "book_loans", force: :cascade do |t|
#   t.integer  "book_copy_id"
#   t.integer  "book_edition_id"
#   t.integer  "book_title_id"
#   t.integer  "person_id"
#   t.integer  "book_category_id"
#   t.integer  "loan_type_id"
#   t.date     "out_date"
#   t.date     "due_date"
#   t.integer  "academic_year_id"
#   t.integer  "user_id"
#   t.datetime "created_at",       null: false
#   t.datetime "updated_at",       null: false
# end