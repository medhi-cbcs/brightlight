namespace :db do
	desc "Populate database with courses and sections"
	task populate_grade_levels: :environment do
		require 'populator'

		GradeLevel.delete_all
		GradeSection.delete_all

		# Academic Years and Terms
		n = 0
		year = AcademicYear.where(name:'2015-2016').first

		teachers = Employee.where(job_title:'Teacher')
		teachers_count = teachers.count
		students = Student.all
		students_count = students.count

		# Grade Levels
		puts "Populating Grade Levels"
		g = 0
		GradeLevel.populate 12 do |grade|
			g += 1
			grade.name = "#{g}"

			s = 0
			GradeSection.populate 3 do |section|
				section.name = "#{grade.name}#{["A","B","C"][s]}"
				section.grade_level_id = grade.id
				section.homeroom_id = teachers[rand(teachers_count)].id
				section.academic_year_id = year.id
				s += 1
			end
		end
	end
end
