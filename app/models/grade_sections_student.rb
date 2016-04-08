class GradeSectionsStudent < ActiveRecord::Base
  belongs_to :grade_section
  belongs_to :student
  belongs_to :academic_year
  belongs_to :grade_section_history

  validates :grade_section, presence: true
  validates :student, presence: true
  validates :academic_year, presence: true

  default_scope { order(:order_no) }

  scope :current, lambda { where(academic_year_id: current_academic_year_id) }
  scope :with_academic_year, lambda { |academic_year| where(academic_year: academic_year) }
  scope :for_section, lambda { |grade_section| where(grade_section: grade_section) }

  def self.students_for_section(section, year)
    self.for_section(section).with_academic_year(year)
  end

  def self.number_of_students(section, year)
    self.students_for_section(section, year).count
  end

end
