class Employee < ActiveRecord::Base
	belongs_to :department
	belongs_to :reporting_supervisor, class_name: :employee
	has_many :subordinates, class_name: "Employee",
                          foreign_key: "reporting_supervisor_id"
end
