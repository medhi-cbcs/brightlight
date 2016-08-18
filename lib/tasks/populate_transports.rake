namespace :data do
	desc "Populate transports with passengers"
	task populate_transports: :environment do

		Passenger.delete_all
		Transport.delete_all
    AcademicYear.current_id = 16

    current_families = Student.current.pluck(:family_no).uniq
    current_families.each do |family_no|
      puts "Family no #{family_no}"
      private_car = Transport.create(category: "PrivateCar", name: "%03d" % family_no.to_i, family_no: family_no, active: true)
    end
    GradeSectionsStudent.where(academic_year_id:AcademicYear.current_id).each do |g|
      transport = Transport.where(category:"PrivateCar", family_no: g.student.family_no).take
      Passenger.create(transport: transport,
                        name: g.student.name,
                        student_id: g.student.id,
                        grade_section_id: g.grade_section.id,
                        class_name: g.grade_section.name,
                        family_no: g.student.family_no,
                        active: true)
    end


		name = "AA"
		number_of_students = Student.count
		30.times do
			shuttle = Transport.new
      shuttle.category = "Shuttle"
			shuttle.name = name
			shuttle.active = true
			shuttle.save
			puts "Creating shuttle #{name}"
			name = name.next
		end

    Transport.where(category:"Shuttle").each do |shuttle|
			8.times do
				gss = GradeSectionsStudent.where(academic_year:16).where(student_id:rand(number_of_students)).includes([:student]).take
        student = gss.try(:student)
				if student.present?
					passenger = Passenger.create(student_id: gss.student_id,
                                       name: student.name,
                                       family_no: student.family_no,
                                       class_name: gss.grade_section.name,
                                       grade_section_id: gss.grade_section_id,
                                       active: true)
					shuttle.passengers << passenger
					puts "Adding #{gss.student.name}"
				end
      end
    end


  end
end
