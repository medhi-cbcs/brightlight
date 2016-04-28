class CourseSectionHistory < ActiveRecord::Base
  belongs_to :course
  belongs_to :grade_section
  belongs_to :instructor, class_name: 'Employee'
  belongs_to :academic_year
  belongs_to :academic_term
end
