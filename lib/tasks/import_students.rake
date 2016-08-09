namespace :data do
	desc "Import students"
	task import_students: :environment do

    xl = Roo::Spreadsheet.open('lib/tasks/Database_2.xlsx')
    sheet = xl.sheet('CBCS_Students_Diknas')

    header = {student_no:"STUDENT_ID", family_no:"FAMILY_ID", name:"STUDENT_NAME", nick_name:"STUDENT_NICK", gender:"STUDENT_GENDER", place_of_birth:"STUDENT_POB",
              date_of_birth:"STUDENT_DOB", religion:"STUDENT_RELIGION", nationality:"STUDENT_NATIONALITY", email:"STUDENT_EMAIL", address_line1:"STUDENT_ADDRESS",
              address_rt:"STUDENT_RT", address_rw:"STUDENT_RW", address_kelurahan:"STUDENT_KELURAHAN", address_kecamatan:"STUDENT_KECAMATAN", postal_code:"STUDENT_ZIP",
              country:"STUDENT_COUNTRY", home_phone:"STUDENT_PHONE", mobile_phone:"STUDENT_CELLPHONE", language:"STUDENT_LANGUAGE", living_with:"STUDENT_LIVING",
              home_to_school_1:"STUDENT_HOMETOSCHOOL1", home_to_school_2:"STUDENT_HOMETOSCHOOL2", transport:"STUDENT_CARWALKER", siblings:"STUDENT_NUMBEROFSIBLINGS",
              birth_order:"STUDENT_BIRTHORDER", step_siblings:"STUDENT_STEPSIBLINGS", adopted_siblings:"STUDENT_ADOPSIBLINGS", parental_status:"STUDENT_PARENTINFO",
              parents_status:"STUDENT_PARENTSTATUS", prev_sch_name:"STUDENT_PREVSNAME", prev_sch_grade:"STUDENT_PREVSCGRADE", prev_sch_address:"STUDENT_PREVSCADDRESS",
              skhun:"STUDENT_SKHUN", skhun_date:"STUDENT_SKHUNDATE",diploma:"STUDENT_DIPLOMA", diploma_date:"STUDENT_DIPLOMADATE", nisn:"STUDENT_NISN",
              duration:"STUDENT_DURATION", acceptance_date_1:"STUDENT_ACCEPTEDDATE2", acceptance_date_2:"STUDENT_ACCEPTEDDATE", reason:"STUDENT_REASON",
              status:"STUDENT_STATUS", user_id:"USERID", notes:"STUDENT_NOTE", academic_year:"STUDENT_ACADEMICYEAR"}

    sheet.each_with_index(header) do |row,i|
			next if i < 1
			# break if i > 50

      gender = ['MALE','FEMALE'].include? row[:gender] ? row[:gender].titleize : '0 '
      student = Student.new(
        student_no:row[:student_no], family_no:row[:family_no], name:row[:name].titleize, nick_name:row[:nick_name].titleize, gender:gender,
				place_of_birth:row[:place_of_birth].titleize, date_of_birth:row[:date_of_birth],
        religion:row[:religion].titleize, nationality:row[:nationality].titleize, email:row[:email],
				address_line1:row[:address_line1].split.map {|s| !s.match(/\A[^AUIEO]+\z/) ? s.capitalize : s}.join(' '),
				address_rt:row[:address_rt].split.map {|s| !s.match(/\A[^AUIEO]+\z/) ? s.capitalize : s}.join(' '), address_rw:row[:address_rw],
        address_kelurahan:row[:address_kelurahan].titleize, address_kecamatan:row[:address_kecamatan].titleize, postal_code:row[:postal_code],
				city:row[:country].titleize, country:'Indonesia',
        home_phone:row[:home_phone], mobile_phone:row[:mobile_phone], language:row[:language], living_with:row[:living_with], birth_order:row[:birth_order], siblings:row[:siblings],
        step_siblings:row[:step_siblings], adopted_siblings:row[:adopted_siblings], parental_status:row[:parental_status], parents_status:row[:parents_status]
      )

      student_admission_info = student.build_student_admission_info(
        prev_sch_name:row[:prev_sch_name].titleize, prev_sch_grade:row[:prev_sch_grade],
				prev_sch_address:row[:prev_sch_address].split.map {|s| !s.match(/\A[^AUIEO]+\z/) ? s.capitalize : s}.join(' '), skhun:row[:skhun], skhun_date:row[:skhun_date],
        diploma:row[:diploma], diploma_date:row[:diploma_date], nisn:row[:nisn], duration:row[:duration], acceptance_date_1:row[:acceptance_date_1],
				acceptance_date_2:row[:acceptance_date_2], reason:row[:reason], status:row[:status], notes:row[:notes], academic_year:AcademicYear.find_by_name(row[:academic_year])
      )
			puts "#{i}. #{student.name} (No:#{student.student_no}/Fam:#{student.family_no}) - #{student.student_admission_info.academic_year.try(:name)} - Valid: #{student.valid?}"
      student.save
    end
  end
end
