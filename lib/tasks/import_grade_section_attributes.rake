namespace :data do
	desc "Import grade_sections attributes"
	task import_grade_section_attributes: :environment do

		# Read Book condition from CBCS_CLASS_CREW
    # xl = Roo::Spreadsheet.open('lib/tasks/Database_2.xlsx')
    # sheet = xl.sheet('CBCS_CLASS_CREW')
		client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
    results = client.execute("SELECT * FROM CBCS_CLASS_CREW WHERE ClassIndex = 1")

    parallel_codes = ['CG001.1', 'CG001.2', 'CG001.3', 'CG002.1', 'CG002.2', 'CG002.3', 'CG003.1', 'CG003.2', 'CG003.3', 'CG004.1', 'CG004.2', 'CG004.3', 'CG005.1',
		 									'CG005.2', 'CG005.3', 'CG006.1', 'CG006.2', 'CG006.3', 'CG007.1', 'CG007.2', 'CG007.3', 'CG008.1', 'CG008.2', 'CG008.3', 'CG009.1', 'CG009.2',
								      'CG009.3', 'CG010.1', 'CG010.2', 'CG010.3', 'CG011.1', 'CG011.1', 'CG012.1', 'CG012.1', 'CG013.1', 'CG013.2', 'CG013.3', 'CG014.1',
									    'CG014.2', 'CG014.3', 'CG015.1','CG015.2', 'CG015.3']
		subject_codes = ['CG001.1', 'CG001.2', 'CG001.3', 'CG002.1', 'CG002.2', 'CG002.3', 'CG003.1', 'CG003.2', 'CG003.3', 'CG004.1', 'CG004.2', 'CG004.3', 'CG005.1',
											'CG005.2', 'CG005.3', 'CG006.1', 'CG006.2', 'CG006.3', 'CG007.1', 'CG007.2', 'CG007.3', 'CG008.1', 'CG008.2', 'CG008.3', 'CG009.1', 'CG009.2',
											'CG009.3', 'CG010.1', 'CG010.2', 'CG010.3', 'SC011.1', 'SC011.2', 'SC012.1', 'SC012.2', 'CG013.1', 'CG013.2', 'CG013.3', 'CG014.1',
											'CG014.2', 'CG014.3', 'CG015.1','CG015.2', 'CG015.3']

		section_names = ["Grade 1A", "Grade 1B", "Grade 1C", "Grade 2A", "Grade 2B", "Grade 2C", "Grade 3A", "Grade 3B", "Grade 3C", "Grade 4A", "Grade 4B", "Grade 4C",
 										 "Grade 5A", "Grade 5B", "Grade 5C", "Grade 6A", "Grade 6B", "Grade 6C", "Grade 7A", "Grade 7B", "Grade 7C", "Grade 8A", "Grade 8B", "Grade 8C",
 										 "Grade 9A", "Grade 9B", "Grade 9C", "Grade 10A", "Grade 10B", "Grade 10C", "Grade 11NS", "Grade 11SS", "Grade 12NS", "Grade 12SS",
 										 "PS-A", "PS-B", "PS-C", "K-1A", "K-1B", "K-1C", "K-2A", "K-2B", "K-2C"]

    header = { grade_id:"ClassIDGrade", employee_no:"ClassIDEmployee",name:"ClassEmployeeName", position:"ClassStatusCrew",
    					 academic_year: "ClassAcademicYear", index:"ClassIndex", user_id:"ClassIDUser", date_input:"ClassDateInput", time_input:"ClassTimeInput",
    					 notes:"ClassNote", level:"CLassLevelID", parallel_code:"ClassParalelID", subject_code:"SubjectClasasID"}

		subject_classes = ['SC011.1', 'SC011.2', 'SC012.1', 'SC012.2']

		results.each_with_index do |row,i|
			puts "#{i}. #{row[header[:parallel_code]]} #{row[header[:academic_year]]}"
		  if subject_classes.include? row[header[:subject_code]]
				section_name = section_names[subject_codes.index(row[header[:subject_code]])]
			else
				section_name = section_names[parallel_codes.index(row[header[:parallel_code]])]
			end
		  grade_section = GradeSection.find_by_name(section_name)

		  if row[header[:academic_year]] == "2015-2016"
			  grade_section.subject_code = row[header[:subject_code]]
			  grade_section.parallel_code = row[header[:parallel_code]]
			  grade_section.homeroom = Employee.find_by_employee_number(row[header[:employee_no]]) if row[header[:position]] == '001'
			  grade_section.assistant = Employee.find_by_employee_number(row[header[:employee_no]]) if row[header[:position]] == '003'
				grade_section.academic_year = AcademicYear.find_by_slug(row[header[:academic_year]])
			  grade_section.save
			else
				year = AcademicYear.find_by_slug(row[header[:academic_year]])
				grade_section_history = grade_section.grade_section_histories.find_by_academic_year_id(year.id)
			  grade_section_history.subject_code = row[header[:subject_code]]
			  grade_section_history.parallel_code = row[header[:parallel_code]]
			  grade_section_history.homeroom = Employee.find_by_employee_number(row[header[:employee_no]]) if row[header[:position]] == '001'
			  grade_section_history.assistant = Employee.find_by_employee_number(row[header[:employee_no]]) if row[header[:position]] == '003'
			  grade_section_history.save
  		end

    end

  end
end
