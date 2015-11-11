namespace :db do
	desc "Populate database with courses and sections"
	task populate_courses: :environment do
		require 'populator'

		Course.delete_all
		GradeLevel.delete_all
		GradeSection.delete_all
		GradeSectionsStudent.delete_all

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
				s += 1				
			end
		end

		no_of_sections = GradeSection.all.count
		
		# Randomly assign each student to a grade section
		puts "Assigning students to grade sections"
		Student.find_each do |student|
			gs = GradeSection.all[rand(no_of_sections)]
			GradeSectionsStudent.create student_id:student.id, grade_section_id:gs.id, academic_year_id:year.id
		end

		puts "Populating Courses"
		['Math', 'English', 'PE', 'Writing', 'Arts', 'Science', 'History', 'Bible',
			'Geography', 'Music', 'Biology', 'Physics'
		].each do |course_name|
			# Create courses in each grade level
			GradeLevel.find_each do |grade_level|
				course = Course.new
				course.name = course_name + ' Grade ' + grade_level.name
				course.number = course_name[0..3].upcase + grade_level.name
				course.grade_level_id = grade_level.id
				course.academic_year = year
				course.academic_terms << year.academic_terms.first
				course.academic_terms << year.academic_terms.last	
				course.save
				puts course.name

				# Randomly pick 3 book titles for each course that closely match the title
				book_selection = BookTitle.where("title like '%#{course_name}%'")
				3.times do
					course.book_titles << book_selection[rand(book_selection.count)]
				end

				# Create course sections in each grade section
				grade_level.grade_sections.each do |grade_section|
					course_section = course.course_sections.new
					course_section.grade_section = grade_section
					course_section.name = "#{course.name} Section #{grade_section.name}"
					course_section.instructor = teachers[rand(teachers_count)]
					course_section.save

					# Add students to each course section, here we'll just copy it from the grade section students
					puts "Adding students to #{grade_section.name}"
					grade_section.students.all.each do |student|
						Roster.create course_section_id:course_section.id, student_id:student.id, academic_year_id:year.id
					end
				end
			end
		end
	end
end