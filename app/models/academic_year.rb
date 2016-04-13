class AcademicYear < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	has_many :academic_terms, :dependent => :destroy
  accepts_nested_attributes_for :academic_terms, allow_destroy: true

	slug  :name
  scope :current_year, lambda { where("? between start_date and end_date", Date.today) }
  scope :for_date, lambda { |date| where("? between start_date and end_date", date) }

	class << self
    attr_accessor :current
 	end
	
  def self.current_id
  	self.current_year.take.id
  end

end
