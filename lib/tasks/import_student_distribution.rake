namespace :data do
	desc "Import student distribution"
	task import_student_distribution: :environment do

		# Read Book condition from CBCS_CLASS_CREW
    # xl = Roo::Spreadsheet.open('lib/tasks/Database_2.xlsx')
    # sheet = xl.sheet('CBCS_CLASS_DISTRIBUTION')

    header = {grade_id:"DistributionIDGrade", grade_name:"DistributionGradeName", list_no:"DistributionAbsenceListNumber",
              name:"DistributionStudentName", year:"DistributionYearAcademic", notes:"DistributionNote", user_id:"DistributionIDUser",
              date_input:"DistributionDateInput", time_input:"DistributionTimeInput", index: "DistributionIndex",
              employee_id:"DistributionIDEmployee", employee_name:"DistributionNameEmployee", student_id:"DistributionStudentID",
              class_level:"DistributionClassLevelID", group:"DistributionGroupID", subject_id:"DistributionSubjectID"}

    subject_classes = ['SC011.1', 'SC011.2', 'SC012.1', 'SC012.2']

		client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
		results = client.execute('SELECT * FROM CBCS_CLASS_DISTRIBUTION')

		columns = [:grade_section_id, :student_id, :order_no, :academic_year_id, :grade_section_history_id, :notes]
		values = []
		n = 0
		results.each_with_index do |row, i|
			next if row[header[:index]] == 0

      if subject_classes.include? row[header[:subject_id]]
        grade_section = GradeSection.find_by_subject_code(row[header[:subject_id]])
      else
        grade_section = GradeSection.find_by_parallel_code(row[header[:class_level]])
      end
			grade_section_id = grade_section.id
      year_id = AcademicYear.find_by_name(row[header[:year]]).id
      gss_history_id = row[header[:year]] == '2015-2016' ? nil : grade_section.grade_section_histories.where(academic_year_id:year_id).first.id
			student_id = Student.find_by_student_no(row[header[:student_id]]).try(:id)
			order_no = row[header[:list_no]]
			data = [grade_section_id, student_id, order_no, year_id, gss_history_id, row[header[:student_id]]]
			values << data

			# insert to DB every 100 rows
			if i % 100 == 0
      	puts "#{i}. #{row[header[:subject_id]]} (#{row[header[:year]]}) ##{order_no}"
				GradeSectionsStudent.import columns, values, validates: false
				values = []
			end
			n = i
    end

		# insert the remaining rows, if any
		if values.count > 0
			GradeSectionsStudent.import columns, values, validates: false
		end
		puts "Last row #{n}"
		results.cancel
  end
end
