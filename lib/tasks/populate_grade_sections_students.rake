namespace :db do
	desc "Populate grade sections with students"
	task populate_grade_sections_students: :environment do
		require 'populator'

		GradeSectionsStudent.delete_all
		Roster.delete_all

		# Academic Years and Terms
		n = 0
		year = AcademicYear.current

		students = Student.all
		students_count = students.count
		no_of_sections = GradeSection.all.count

		# Randomly assign each student to a grade section
		puts "Assigning students to grade sections"
		Student.find_each do |student|
			gs = GradeSection.all[rand(no_of_sections)]
			GradeSectionsStudent.create student_id:student.id, grade_section_id:gs.id, academic_year_id:year.id
		end

		# Create student roster for each course sections
		puts "Create student roster"
		GradeSection.all.order(:grade_level_id, :id).each do |section|
			puts "Section #{section.name}"
			section.course_sections.each do |cs|
				Roster.create(section.students.map {|s| {:course_section_id => cs.id, :student_id => s.id, :academic_year_id => year.id} })
			end
		end

  end
end
