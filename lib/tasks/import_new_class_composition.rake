namespace :data do
	desc "Import new class composition"
	task import_new_class_composition: :environment do

    xl = Roo::Spreadsheet.open('tmp/Class Composition 2016-2017.xlsx')
    sheet = xl.sheet('class-composition-2016-2017')

    header = {no:'No',name:'Name',student_no:'School UD ID', family_no:'Family UD ID', roster_no:'Roster No',
              track:'Track', gender:'Gender', grade_level_id:'Grade Level', section_name:'Section Name'}
    academic_year = AcademicYear.find_by_name '2016-2017'

    sheet.each_with_index(header) do |row,i|
			next if i < 1
      student = Student.find_by_student_no row[:student_no]
      grade_section = GradeSection.find_by_name row[:section_name]
      gss = GradeSectionsStudent.new(
                  grade_section_id: grade_section.id,
                  student_id: student.id,
                  academic_year_id: academic_year.id,
                  order_no: row[:roster_no],
                  track: row[:track],
                  notes: row[:student_no]
                )
      gss.save
      puts "#{i}. #{student.name} (No:#{student.student_no}/Fam:#{student.family_no})"
    end
  end
end
