class Department < ActiveRecord::Base
	has_many :employees
	has_one :manager, class_name: "Employee"
end
