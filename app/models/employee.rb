class Employee < ActiveRecord::Base
 	validates :name, presence: true
	belongs_to :department
	belongs_to :supervisor, class_name: "Employee"
	has_many :subordinates, class_name: "Employee", foreign_key: "supervisor_id"

	scope :all_teachers, lambda { where(job_title:'Teacher') }
	
	def to_s
		name 
	end
end
