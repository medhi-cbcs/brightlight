namespace :data do
	desc "Import book loans"
	task import_book_loan: :environment do

  	header = {student_no:'RENTSTUDENTID',	family_no:'RENTFAMILYID',	class_order:'RENTSTUDENTNUM',	barcode:'RENTBARCODEID',	isbn:'RENTISBN',
  		refno:'RENTBKREFERENCE', category:'RENTCategory',	rent_status:'RENTSTATUS',	class_level:'RENTClassLevelID',	subject_id:'RENTSubjectID',
  		rent_date:'RENTDATEGET', rent_time:'RENTTIMEGET',	return_date:'RENTDATERETURN',	user_id:'RENTIDUSER',	date_input:'RENTDATEINPUT',
  		time_input:'RENTTIMEINPUT',	index:'RENTINDEX',	notes:'RENTNOTE',	new_academic_year:'RENTNewAcademicYear', academic_year:'RENTYearAcademic',
  		return_status:'RENTRETURNSTATUS',	bkudid:'BKUDID', noteqpr:'NOTEOPR', class_year:'DistributionYearAcademic'}

		subject_classes = ['CG011.1','CG011.2','CG012.1','CG012.2']

		client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
		results = client.execute("SELECT [RENTSTUDENTID]
						      ,[RENTFAMILYID]
						      ,[RENTSTUDENTNUM]
						      ,[RENTBARCODEID]
						      ,[RENTISBN]
						      ,[RENTBKREFERENCE]
						      ,[RENTCategory]
						      ,[RENTSTATUS]
						      ,[RENTClassLevelID]
						      ,[RENTSubjectID]
						      ,[RENTDATEGET]
						      ,[RENTTIMEGET]
						      ,[RENTDATERETURN]
						      ,[RENTIDUSER]
						      ,[RENTDATEINPUT]
						      ,[RENTTIMEINPUT]
						      ,[RENTINDEX]
						      ,[RENTNOTE]
						      ,[RENTNewAcademicYear]
						      ,[RENTYearAcademic]
						      ,[RENTRETURNSTATUS]
						      ,[BKUDID]
						      ,[NOTEOPR]
							  ,[DistributionYearAcademic]
						  FROM [PROBEST1_0LD].[dbo].[CBCS_INVBOOKSRENT]
						  LEFT JOIN [CBCS_CLASS_DISTRIBUTION] on ([RENTSTUDENTID] = [DistributionStudentID]
							and [DistributionClassLevelID] = RENTClassLevelID
							and [RENTSTUDENTNUM] = DistributionAbsenceListNumber)")
		# results = client.execute("SELECT RENTSTUDENTID, RENTFAMILYID, RENTSTUDENTNUM, RENTBARCODEID, RENTISBN, RENTBKREFERENCE, RENTCategory, RENTSTATUS, RENTClassLevelID,
    #                   RENTSubjectID, RENTDATEGET, RENTTIMEGET, RENTDATERETURN, RENTIDUSER, RENTDATEINPUT, RENTTIMEINPUT, RENTINDEX, RENTNOTE,
    #                   RENTNewAcademicYear, RENTYearAcademic, RENTRETURNSTATUS, CBCS_INVBOOKSRENT.BKUDID, NOTEOPR, TIMESTAMP
		# 									FROM CBCS_INVBOOKSRENT")

		results.each_with_index do |row, i|
			next if row[header[:index]] == 0

			book_copy = BookCopy.find_by_barcode(row[header[:barcode]].upcase)

			## Trying to 'fix' wrong data in PROBEST1_0LD. I'm not sure if this works. Might as well leave it alone as it is.
			##  because there are error with conflicting 'rules'
			##
			# year_name = if row[header[:student_no]].present?
			# 							row[header[:new_academic_year]]
			# 						elsif row[header[:class_year]].present? && (row[header[:new_academic_year]] != row[header[:class_year]])
			# 							row[header[:class_year]]
			# 						else
			# 							row[header[:new_academic_year]]
			# 						end

			year_name = row[header[:new_academic_year]]
			year = AcademicYear.find_by_name(year_name)
			prev_year = AcademicYear.find_by_name(row[header[:academic_year]])
			student = Student.find_by_student_no(row[header[:student_no]])
			grade_section = if subject_classes.include?(row[header[:class_level]]) && row[header[:subject_id]].present?
                        GradeSection.find_by_subject_code(row[header[:subject_id]])
											elsif row[header[:class_level]] == 'CG011.0'
												GradeSection.find_by_parallel_code('CG011.1')
                      else
                        GradeSection.find_by_parallel_code(row[header[:class_level]])
                      end

			# if student number is missing, look up from the grade_sections_students table
			if row[header[:student_no]].blank?
				student = GradeSectionsStudent.where(academic_year:AcademicYear.find_by_name(row[header[:new_academic_year]])).where(grade_section:grade_section).where(order_no:row[header[:class_order]]).first.try(:student)
			end

			# if Category != 'TB', it means that this record is for Teachers
			if row[header[:category]] != 'TB'
				employee_no = row[header[:student_no]]
				employee = Employee.find_by_employee_number(employee_no)
			end

			# grade_section = GradeSectionsStudent.where(academic_year:year).where(student:student).first.try(:grade_section)

			# if Category == 'TB', it means that this record is for Students
			if row[header[:category]] == 'TB'
				student_book = StudentBook.new(
					student: student,
					book_copy: book_copy,
					book_edition: book_copy.try(:book_edition),
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
					barcode: row[header[:barcode]],
					initial_copy_condition: (book_copy.start_condition_in_year(year.id) if book_copy.present?),
					end_copy_condition: (book_copy.return_condition_in_year(year.id) if book_copy.present?),
					deleted_flag: false
				)
				student_book.save(validate: false)
				puts "#{i}. #{student_book.student.try(:name) || 'Student N/A'} (#{student_book.grade_section.try(:name) || "Grade N/A"}) #{student_book.book_copy.try(:barcode) || "Book copy N/A"}" if i % 500 == 0

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
				student: student,
				deleted_flag: false
			)
			loan.save

			puts "#{i}. #{loan.employee.try(:name) || 'Empl N/A'} (#{loan.employee_no || "Empl No N/A"})" if employee.present? && i % 500 == 0
			puts " - #{loan.book_title.try(:title) || "Book title N/A"}: #{loan.out_date} - #{loan.due_date} (#{year.try(:name)}) (#{year_name})" if i % 500 == 0

 		end
  end
end
