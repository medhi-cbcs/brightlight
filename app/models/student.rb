class Student < ActiveRecord::Base
	has_many :students_guardians
	has_many :guardians, through: :students_guardians
	has_many :grade_sections, through: :grade_sections_students
	has_many :course_sections, through: :rosters
end
