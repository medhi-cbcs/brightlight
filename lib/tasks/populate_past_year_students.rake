namespace :db do
	desc "Populate database with courses and sections"
	task populate_past_year_students: :environment do

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
			puts "Populating year before #{year.name}"
			past_year_id = year.id-1							# assuming academic_year ids are sequential
			GradeSectionsStudent.with_academic_year_id(year.id).find_each do |gss|
				student_id = gss.student_id
				grade_level = gss.grade_section.grade_level
				if grade_level.id > 1 							# assuming grade_level ids are sequential
					prev_level = GradeLevel.find(grade_level.id-1)
					random_section = prev_level.grade_sections[rand(prev_level.grade_sections.count)]
					GradeSectionsStudent.create student_id:student_id, grade_section_id:random_section.id, academic_year_id:past_year_id
				end
			end
		end
	end
end