class GradeSectionsStudent < ActiveRecord::Base
  belongs_to :grade_section
  belongs_to :student
  belongs_to :academic_year

  validates :grade_section, presence: true
  validates :student, presence: true
  validates :academic_year, presence: true
  
  default_scope { order(:order_no) }
end
