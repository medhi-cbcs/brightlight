class GradeSectionHistory < ActiveRecord::Base
  belongs_to :grade_level
  belongs_to :grade_section
  belongs_to :academic_year
  belongs_to :homeroom, class_name: 'Employee'
  belongs_to :assistant, class_name: 'Employee'
  has_many :grade_sections_students

  validates :academic_year, presence: true
  validates :grade_section, presence: true
  validates :grade_section_id, uniqueness: {scope: [:academic_year_id]}

  def students_for_academic_year(academic_year)
    grade_sections_students.where(academic_year:academic_year).includes([:student])
  end
end
