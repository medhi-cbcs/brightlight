namespace :db do
	desc "Populate database with courses and sections"
	task populate_past_year_students: :environment do
		require 'populator'

		year2015 = AcademicYear.where(name:'2015-2016').first
		year2014 = AcademicYear.where(name:'2014-2015').first
		year2013 = AcademicYear.where(name:'2013-2014').first
		year2012 = AcademicYear.where(name:'2012-2013').first
		year2011 = AcademicYear.where(name:'2011-2012').first

		teachers = Employee.all_teachers
		teachers_count = teachers.count
		students = Student.all
		students_count = students.count

		no_of_sections = GradeSection.all.count
		
		# Randomly assign each student to a grade section
		puts "Assigning students to grade sections"
		[year2015, year2014, year2013, year2012, year2011].each do |year|

			past_year_id = year.id-1							# assuming academic_year ids are sequential
			ay = AcademicYear.find(past_year_id)

			puts "Creating past Grade Sections for year #{ay.name}"
			GradeLevel.find_each do |grade|
				s = 0
				GradeSection.populate 3 do |section|
					section.name = "#{grade.name}#{["A","B","C"][s]}"
					puts section.name
					section.grade_level_id = grade.id
					section.homeroom_id = teachers[rand(teachers_count)].id
					section.academic_year_id = past_year_id
					s += 1			
				end
			end

			puts "Populating students for year #{ay.name}"
			GradeSectionsStudent.with_academic_year_id(year.id).find_each do |gss|
				student_id = gss.student_id
				grade_level = gss.grade_section.grade_level
				if grade_level.id > 2 							# assuming grade_level ids are sequential
					prev_level = GradeLevel.find(grade_level.id-1)
					prev_sections = prev_level.grade_sections.where(academic_year_id:past_year_id)
					random_section = prev_sections[rand(prev_sections.count)]
					GradeSectionsStudent.create student_id:student_id, grade_section_id:random_section.id, academic_year_id:past_year_id
				end
			end

		end
	end
end