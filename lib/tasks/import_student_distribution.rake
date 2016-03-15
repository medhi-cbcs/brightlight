namespace :data do
	desc "Import student distribution"
	task import_student_distribution: :environment do

		# Read Book condition from CBCS_CLASS_CREW
    xl = Roo::Spreadsheet.open('lib/tasks/Database_2.xlsx')
    sheet = xl.sheet('CBCS_CLASS_DISTRIBUTION')

    header = {grade_id:"DistributionIDGrade", grade_name:"DistributionGradeName", list_no:"DistributionAbsenceListNumber",
              name:"DistributionStudentName", year:"DistributionYearAcademic", notes:"DistributionNote", user_id:"DistributionIDUser",
              date_input:"DistributionDateInput", time_input:"DistributionTimeInput", index: "DistributionIndex",
              employee_id:"DistributionIDEmployee", employee_name:"DistributionNameEmployee", student_id:"DistributionStudentID",
              class_level:"DistributionClassLevelID", group:"DistributionGroupID", subject_id:"DistributionSubjectID"}

    subject_classes = ['SC011.1', 'SC011.2', 'SC012.1', 'SC012.2']

    sheet.each_with_index(header) do |row,i|
      next if i < 1
      # break if i > 20

      if subject_classes.include? row[:subject_id]
        grade_section = GradeSection.find_by_subject_code(row[:subject_id])
      else
        grade_section = GradeSection.find_by_parallel_code(row[:class_level])
      end
      year = AcademicYear.find_by_name(row[:year])
      gss_history = row[:year] == '2015-2016' ? nil : grade_section.grade_section_histories.where(academic_year:year).first
      gss = GradeSectionsStudent.new(
        grade_section: grade_section,
        student: Student.find_by_student_no(row[:student_id]),
        order_no: row[:list_no],
        academic_year: year,
        grade_section_history: gss_history,
        notes: row[:student_id]
      )
      # puts "#{i}. #{gss.grade_section.name} (#{gss.academic_year.name}) ##{gss.order_no} #{gss.student.try(:name)}"
      gss.save
    end
  end
end
