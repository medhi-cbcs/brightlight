class CoursesSection < ActiveRecord::Base
  belongs_to :course
  belongs_to :grade_section
  belongs_to :employee
end
