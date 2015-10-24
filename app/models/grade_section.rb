class GradeSection < ActiveRecord::Base
  belongs_to :grade_level
  belongs_to :homeroom, class_name: "Employee"
  has_many :courses_sections
end
