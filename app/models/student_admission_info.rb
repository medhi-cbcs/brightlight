class StudentAdmissionInfo < ActiveRecord::Base
  belongs_to :student
  belongs_to :academic_year
end
