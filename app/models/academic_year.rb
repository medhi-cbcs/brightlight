class AcademicYear < ActiveRecord::Base
	# include ActiveModel::Validations
	# attr_accessor :name, :start_date, :end_date

	# validates :start_date, date: true
	# validates :end_date, date: true
	has_many :academic_terms, :dependent => :destroy
  accepts_nested_attributes_for :academic_terms
end
