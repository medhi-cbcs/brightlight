class Roster < ActiveRecord::Base
  belongs_to :course_section
  belongs_to :student
  belongs_to :academic_year
end
