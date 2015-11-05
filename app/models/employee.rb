require 'forgery'

class Employee < ActiveRecord::Base
	belongs_to :department
	belongs_to :supervisor, class_name: "Employee"
	has_many :subordinates, class_name: "Employee", foreign_key: "supervisor_id"

	def to_s
		name 
	end

	# def gelar_s1
	# 	Forgery::Degree.sarjanaS1
	# end

	# def gelar_s2
	# 	Forgery::Degree.sarjanaS2
	# end

	# def universitas
	# 	if Forgery::Basic.boolean
	# 		Forgery::Universitas.universitas_negeri
	# 	else
	# 		Forgery::Universitas.universitas_swasta
	# 	end
	# end

	# def nama
	# 	Forgery::Name.first_name + ' ' + Forgery::NameIndonesian.name
	# end
end
