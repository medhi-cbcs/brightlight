class CourseSection < ActiveRecord::Base
  belongs_to :course
  belongs_to :grade_section
  belongs_to :instructor, class_name: "Employee"
end
