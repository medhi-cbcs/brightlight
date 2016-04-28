class Guardian < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
  validates :person, presence: true
	belongs_to :person	
	has_many :students_guardians
	has_many :students, through: :students_guardians
end
