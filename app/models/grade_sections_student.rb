class GradeSectionsStudent < ActiveRecord::Base
  belongs_to :grade_section
  belongs_to :student
  belongs_to :academic_year

  validates :grade_section, presence: true
  validates :student, presence: true
  validates :academic_year, presence: true
  
  default_scope { order(:order_no) }

  scope :current, lambda { where(academic_year: AcademicYear.current) }
  scope :with_academic_year_id, lambda { |id| where(academic_year_id: id) }
end
