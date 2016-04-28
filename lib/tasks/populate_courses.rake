namespace :db do
	desc "Populate database with courses and sections"
	task populate_courses: :environment do

		Course.delete_all

		puts "Populating Courses"
		['Math', 'English', 'Writing', 'Science', 'History', 'Bible',
			'Geography', 'Biology', 'Physics'
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
