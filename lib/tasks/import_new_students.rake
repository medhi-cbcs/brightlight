namespace :data do
	desc "Import new students"
	task import_new_students: :environment do

    xl = Roo::Spreadsheet.open('tmp/Class Composition 2016-2017.xlsx')
    sheet = xl.sheet('new_students_2016-2017')

    header = {no:'No',name:'Name',student_no:'School UD ID', family_no:'Family UD ID', roster_no:'Roster No',
              track:'Track', gender:'Gender', grade_level_id:'Grade Level', section_name:'Section Name'}

    sheet.each_with_index(header) do |row,i|
			next if i < 1
      student = Student.new(
                  student_no: row[:student_no],
                  family_no:  row[:family_no],
                  name:       row[:name],
                  gender:     row[:gender].try(:downcase)
                )
      student.save
      puts "#{i}. #{student.name} (No:#{student.student_no}/Fam:#{student.family_no})"
    end
  end
end
