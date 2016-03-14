class GradeSectionHistory < ActiveRecord::Base
  belongs_to :grade_level
  belongs_to :grade_section
  belongs_to :academic_year
  belongs_to :homeroom, class_name: 'Employee'
  belongs_to :assistant, class_name: 'Employee'

  validates :academic_year, presence: true
end
