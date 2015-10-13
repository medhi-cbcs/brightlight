class AcademicYear < ActiveRecord::Base
	has_many :academic_terms, :dependent => :destroy
  accepts_nested_attributes_for :academic_terms, allow_destroy: true
end
