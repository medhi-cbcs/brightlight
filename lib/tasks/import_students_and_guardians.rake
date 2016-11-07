namespace :data do
	desc "Import students and guardians"
	task import_students_and_guardians: :environment do

    xl = Roo::Spreadsheet.open('lib/tasks/class-composition-2016-2017.xlsx')
    sheet = xl.sheet('COMBINE')

    header = {no:'NO',family_no:'FAM.ID',student_no:'STUDENT ID', grade:'GRADE', name:'STUDENT NAME',
              dob:'BOD', denomination:'Denomination', email:'STUDENT EMAIL', fathers_name:"FATHER'S NAME",
              ft_contact: 'FT. HOME CONTACT', fathers_cell: 'FT. CELL PHONE', fathers_email: 'FT. EMAIL',
              mothers_name: "MOTHER'S NAME", mt_contact: 'MT. HOME CONTACT', mothers_cell: 'MT. CELL PHONE',
              mothers_email: 'MT. EMAIL' }

    sheet.each_with_index(header) do |row,i|
			next if i < 1
      student = Student.find_by_student_no row[:student_no]
      if student.present?
        student.update_attribute :email, :email
        create_guardians student, row
        puts "#{i}. #{student.name}: existing"        
      else 
        student = Student.new(
                    student_no: row[:student_no],
                    family_no:  row[:family_no],
                    name:       row[:name],
                    gender:     row[:gender].try(:downcase),
                    religion:   row[:denomination],
                    email:      row[:email],
                    date_of_birth:  row[:dob]
                  )
        student.save 
        create_guardians student, row
        puts "#{i}. #{student.name} (#{student.gender}) (No:#{student.student_no}/Fam:#{student.family_no})"      
      end
    end
  end
end

def create_guardians(student, data)
  father = Guardian.create(
      name: data[:fathers_name],
      home_phone: data[:mt_contact],
      mobile_phone: data[:fathers_cell],
      email: data[:fathers_email]
  )
  mother = Guardian.create(
      name: data[:mothers_name],
      home_phone: data[:mt_contact],
      mobile_phone: data[:mothers_cell],
      email: data[:mothers_email]
  )
  student.guardians.create [
    { guardian: father, relation: 'father' }, { guardian: mother, relation: 'mother' }
  ]
end