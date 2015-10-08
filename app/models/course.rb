class Course < ActiveRecord::Base
  belongs_to :grade_level
  belongs_to :academic_year
  belongs_to :academic_term
  belongs_to :employee
end
