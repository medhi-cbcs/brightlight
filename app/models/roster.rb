class Roster < ActiveRecord::Base
  belongs_to :course_section
  belongs_to :student

  validates :course_section, presence: true
  validates :student, presence: true
end
