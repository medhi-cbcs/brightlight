class Roster < ActiveRecord::Base
  belongs_to :course_section
  belongs_to :student
  belongs_to :academic_year

  validates :course_section, presence: true
  validates :student, presence: true
  validates :academic_year, presence: true
end
