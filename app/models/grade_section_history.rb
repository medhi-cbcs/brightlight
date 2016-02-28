class GradeSectionHistory < ActiveRecord::Base
  belongs_to :grade_level
  belongs_to :grade_section
  belongs_to :academic_year
  belongs_to :homeroom, class_name: 'Employee'
end
