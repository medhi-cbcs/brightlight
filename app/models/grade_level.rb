class GradeLevel < ActiveRecord::Base
	has_many :grade_sections, :dependent => :destroy
  accepts_nested_attributes_for :grade_sections
end
