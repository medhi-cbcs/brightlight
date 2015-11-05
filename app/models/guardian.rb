class Guardian < ActiveRecord::Base
	has_many :students_guardians
	has_many :students, through: :students_guardians
end
