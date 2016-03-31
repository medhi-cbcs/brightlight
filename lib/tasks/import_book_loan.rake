namespace :data do
	desc "Import book loans"
	task import_book_loan: :environment do

		use_sql_server = true

  	header = {student_no:'RENTSTUDENTID',	family_no:'RENTFAMILYID',	class_order:'RENTSTUDENTNUM',	barcode:'RENTBARCODEID',	isbn:'RENTISBN',
  		refno:'RENTBKREFERENCE', category:'RENTCategory',	rent_status:'RENTSTATUS',	class_level:'RENTClassLevelID',	subject_id:'RENTSubjectID',
  		rent_date:'RENTDATEGET', rent_time:'RENTTIMEGET',	return_date:'RENTDATERETURN',	user_id:'RENTIDUSER',	date_input:'RENTDATEINPUT',
  		time_input:'RENTTIMEINPUT',	index:'RENTINDEX',	notes:'RENTNOTE',	new_academic_year:'RENTNewAcademicYear', academic_year:'RENTYearAcademic',
  		return_status:'RENTRETURNSTATUS',	bkudid:'BKUDID',	noteqpr:'NOTEOPR'}

		subject_classes = ['CG011.1','CG011.2','CG012.1','CG012.2']

		if use_sql_server
			client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
			results = client.execute('SELECT * FROM CBCS_INVBOOKSRENT')

			results.each_with_index do |row, i|
				# next if i > 58683
				next if row[header[:index]] == 0

				book_copy = BookCopy.find_by_barcode(row[header[:barcode]])
				year = AcademicYear.find_by_name(row[header[:new_academic_year]])
				prev_year = AcademicYear.find_by_name(row[header[:academic_year]])
				student = Student.find_by_student_no(row[header[:student_no]])
				grade_section = if subject_classes.include? row[header[:class_level]]
                          GradeSection.find_by_subject_code(row[header[:subject_id]])
                        else
                          GradeSection.find_by_parallel_code(row[header[:class_level]])
                        end

				# if student number is missing, look up from the grade_sections_students table
				if row[header[:student_no]].blank?
					student = GradeSectionsStudent.where(academic_year:year).where(grade_section:grade_section).where(order_no:row[header[:class_order]]).first.try(:student)
				end

				# if RENTSTUDENTNUM > 26, it means that this record is for an Employee
				if row[header[:class_order]].blank? || row[header[:class_order]] > 26
					employee_no = row[header[:student_no]]
					employee = Employee.find_by_employee_number(employee_no)
				end

				# grade_section = GradeSectionsStudent.where(academic_year:year).where(student:student).first.try(:grade_section)

				# if RENTSTUDENTNUM < 26, it means that this record is for a Student
				if row[header[:class_order]].blank? || row[header[:class_order]] < 26
					student_book = StudentBook.new(
						student: student,
						book_copy: book_copy,
						academic_year: year,
						prev_academic_year: prev_year,
						issue_date: row[header[:rent_date]],
						return_date: row[header[:return_date]],
						student_no: row[header[:student_no]],
						roster_no: row[header[:class_order]],
						grade_section_code: row[header[:class_level]],
						grade_subject_code: row[header[:subject_id]],
						notes: row[header[:notes]],
						grade_section: grade_section,
						grade_level: grade_section.try(:grade_level),
						barcode: row[header[:barcode]]
					)
					student_book.save(validate: false)
					if i % 500 == 0
						puts "#{i}. #{student_book.student.try(:name) || 'Student N/A'} (#{student_book.grade_section.try(:name) || "Grade N/A"}) #{student_book.book_copy.try(:barcode) || "Book copy N/A"}"
					end
				end

				loan = BookLoan.new(
					book_copy: book_copy,
					book_edition: book_copy.try(:book_edition),
					book_title: BookTitle.find_by_bkudid(row[header[:bkudid]]),
					bkudid: row[header[:bkudid]],
					barcode: row[header[:barcode]],
					refno: row[header[:refno]],
					student_no: (row[header[:student_no]] if student.present?),
					roster_no: row[header[:class_order]],
					grade_section_code: row[header[:class_level]],
					grade_subject_code: row[header[:subject_id]],
					academic_year: year,
					prev_academic_year: prev_year,
					out_date: row[header[:rent_date]],
					due_date: row[header[:return_date]],
					book_category: BookCategory.find_by_code(row[header[:category]]),
					notes: row[header[:notes]],
					loan_status: row[header[:rent_status]],
					return_status: row[header[:return_status]],
					employee_no: employee_no,
					employee: employee,
					return_date: row[:return_date],
					student: student
				)
				loan.save
				if i % 500 == 0
					if employee.present?
						puts "#{i}. #{loan.employee.try(:name) || 'Empl N/A'} (#{loan.employee_no || "Empl No N/A"})"
					end
					puts " - #{loan.book_title.try(:title) || "Book title N/A"}: #{loan.out_date} - #{loan.due_date} (#{year.name})"
				end
			end

		else
			# Read Book rent from CBCS_INVBOOKSRENT
	    xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
	    sheet = xl.sheet('CBCS_INVBOOKSRENT')

	    sheet.each_with_index(header) do |row,i|
				next if i < 1
			  next if row[:index] == 0

			  book_copy = BookCopy.find_by_barcode(row[:barcode])
				year = AcademicYear.find_by_name(row[:academic_year])
				new_year = AcademicYear.find_by_name(row[:new_academic_year])
				student = Student.find_by_student_no(row[:student_no])
				grade_section = GradeSectionsStudent.where(academic_year:year).where(student:student).first.try(:grade_section)

			  student_book = StudentBook.new(
			  	student: student,
			  	book_copy: book_copy,
					academic_year: year,
					prev_academic_year: prev_year,
					issue_date: row[:rent_date],
			  	return_date: row[:return_date],
					student_no: row[:student_no],
			  	roster_no: row[:class_order],
					grade_section_code: row[:class_level],
					grade_subject_code: row[:subject_id],
					notes: row[:notes],
					grade_section: grade_section,
					grade_level: grade_section.try(:grade_level),
					barcode: row[:barcode]
			  )
			  # student_book.save
				puts "#{i}. #{student_book.student.try(:name) || 'Student N/A'} (#{student_book.grade_section.try(:name) || "Grade N/A"}) #{student_book.book_copy.try(:barcode) || "Book copy N/A"}"

			  loan = BookLoan.new(
			  	book_copy: book_copy,
			  	book_edition: book_copy.try(:book_edition),
			  	book_title: BookTitle.find_by_bkudid(row[:bkudid]),
					bkudid: row[:bkudid],
					barcode: row[:barcode],
					refno: row[:refno],
					student_no: row[:student_no],
			  	roster_no: row[:class_order],
					grade_section_code: row[:class_level],
					grade_subject_code: row[:subject_id],
					academic_year: year,
					prev_academic_year: prev_year,
					out_date: row[:rent_date],
			  	due_date: row[:return_date],
			  	book_category: BookCategory.find_by_code(row[:category]),
					notes: row[:notes],
					loan_status: row[:rent_status],
					return_status: row[:return_status],
					student: student
			  )
			  # loan.save
				puts " - #{loan.book_title.try(:title) || "Book title N/A"}: #{loan.out_date} - #{loan.due_date} (#{year.name})"
			end
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
