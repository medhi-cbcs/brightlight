namespace :data do
	desc "Import students and guardians"
	task import_students_and_guardians: :environment do

    # create_families

    xl = Roo::Spreadsheet.open('tmp/class-composition-2016-2017.xlsx')
    sheet = xl.sheet('COMBINE')

    header = {no:'NO',family_no:'FAM.ID',student_no:'STUDENT ID', grade:'GRADE', name:'STUDENT NAME',
              dob:'BOD', denomination:'Denomination', email:'STUDENT EMAIL', fathers_name:"FATHER'S NAME",
              ft_contact: 'FT. HOME CONTACT', fathers_cell: 'FT. CELL PHONE', fathers_email: 'FT. EMAIL',
              mothers_name: "MOTHER'S NAME", mt_contact: 'MT. HOME CONTACT', mothers_cell: 'MT. CELL PHONE',
              mothers_email: 'MT. EMAIL' }

    sheet.each_with_index(header) do |row,i|
			next if i < 1
      family = Family.find_by_family_no row[:family_no]
      student = Student.find_by_student_no row[:student_no]
      if student.blank?
        student = Student.where('name LIKE ?', "%#{row[:name]}%").take
        student.admission_no = row[:student_no]
      end   
      if student.present?
        if row[:email].present?
          student.email = row[:email]
        end
        student.family_id = family.id
        student.save
        create_guardians family, student, row
        puts "#{i}. #{student.name}: existing #{student.admission_no}"        
      else 
        student = Student.new(
                    student_no: row[:student_no],
                    family_no:  row[:family_no],
                    family_id:  family.id,
                    name:       row[:name],
                    religion:   row[:denomination],
                    email:      row[:email],
                    date_of_birth:  row[:dob]
                  )
        student.save
        add_to_grade_section student, row
        create_guardians family, student, row
        puts "#{i}. #{student.name} (#{student.gender}) (No:#{student.student_no}/Fam:#{student.family_no})"      
      end
    end
  end
end

def create_families
  (1..5000).each { |n| Family.create family_number:n, family_no:"%05d" % n }
end

def create_guardians(family, student, data)
  ft_emails = data[:fathers_email] ? data[:fathers_email].split(',') : []
  ft_params = { 
      name:         data[:fathers_name],
      home_phone:   data[:ft_contact],
      mobile_phone: data[:fathers_cell],
      email:        ft_emails[0].try(:trim),
      email2:       ft_emails[1].try(:trim),
      family_id:    family.id
  }
  father = Guardian.where(ft_params).first_or_create(ft_params)
  mt_emails = data[:mothers_email] ? data[:mothers_email].split(',') : []
  mt_params = {
      name:         data[:mothers_name],
      home_phone:   data[:mt_contact],
      mobile_phone: data[:mothers_cell],
      email:        mt_emails[0].try(:trim),
      email2:       mt_emails[1].try(:trim),
      family_id:    family.id
  }
  mother = Guardian.where(mt_params).first_or_create(mt_params) 
  family.family_members << FamilyMember.new(guardian: mother, relation: 'mother')
  family.family_members << FamilyMember.new(guardian: father, relation: 'father')
  family.family_members << FamilyMember.new(student: student, relation: 'child')
end

def add_to_grade_section(student, data)
  grade_level = GradeLevel.find data[:grade][0..1].to_i
  grade_section = grade_level.grade_sections.where('name LIKE ?', "%#{g.last}" ).take
  grade_section.grade_sections_students.create student: student, academic_year:AcademicYear.current, notes: data[:student_no]
end