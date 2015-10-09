class GradeSectionsStudent < ActiveRecord::Base
  belongs_to :grade_section
  belongs_to :student
end
