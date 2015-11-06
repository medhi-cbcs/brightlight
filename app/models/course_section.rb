class CourseSection < ActiveRecord::Base
  belongs_to :course
  belongs_to :grade_section
  belongs_to :instructor, class_name: "Employee"

  has_many :students, through: :rosters
end
