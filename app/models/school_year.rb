class SchoolYear < ActiveRecord::Base
	has_many :school_terms, dependent: :destroy
  accepts_nested_attributes_for :school_terms, allow_destroy: true	
end
