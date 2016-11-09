class Guardian < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	belongs_to :family
	belongs_to :person	
end
