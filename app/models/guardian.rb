class Guardian < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	belongs_to :family
	belongs_to :person	

	def self.including_family_no
		joins(:family).select('guardians.*, families.family_no as fn')
	end
end
