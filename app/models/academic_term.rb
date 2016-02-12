class AcademicTerm < ActiveRecord::Base
	validates :name, presence: true
  belongs_to :academic_year
  has_and_belongs_to_many :courses
end
