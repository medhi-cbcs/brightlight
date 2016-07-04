class AcademicYear < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	has_many :academic_terms, :dependent => :destroy
  accepts_nested_attributes_for :academic_terms, allow_destroy: true

	slug  :name
  scope :current_year, lambda { where("? between start_date and end_date", Date.today) }
  scope :for_date, lambda { |date| where("? between start_date and end_date", date) }
	default_scope { order(:slug) }

	class << self
    attr_accessor :current_id
	end

	def self.current
		AcademicYear.current_year.take
	end
	
  # def self.current_id
  # 	self.current_year.take.id
  # end

end
