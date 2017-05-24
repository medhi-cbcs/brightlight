class Budget < ActiveRecord::Base
  belongs_to :department
  belongs_to :owner
  belongs_to :grade_level
  belongs_to :grade_section
  belongs_to :academic_year
  belongs_to :approver
end
