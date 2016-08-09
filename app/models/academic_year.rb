class AcademicYear < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	has_many :academic_terms, :dependent => :destroy
  accepts_nested_attributes_for :academic_terms, allow_destroy: true

	# slug  :name
  scope :current_year, lambda { where("? between start_date and end_date", Date.today) }
  scope :for_date, lambda { |date| where("? between start_date and end_date", date) }
	scope :list_for_menu, lambda { where("id>? and id<?", AcademicYear.current_id-7, AcademicYear.current_id+3) }
	default_scope { order(:id) }

	class << self
    attr_accessor :current_id
	end

	def self.current
		AcademicYear.current_year.take
	end

end
