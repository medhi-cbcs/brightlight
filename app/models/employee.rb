class Employee < ActiveRecord::Base
	belongs_to :department
	belongs_to :supervisor, class_name: "Employee"
	has_many :subordinates, class_name: "Employee", foreign_key: "supervisor_id"

	def to_s
		name 
	end
end
