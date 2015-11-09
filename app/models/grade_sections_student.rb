class GradeSectionsStudent < ActiveRecord::Base
  belongs_to :grade_section
  belongs_to :student

  default_scope { order(:order_no) }
end
