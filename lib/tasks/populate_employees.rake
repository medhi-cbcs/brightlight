namespace :db do
	desc "Create employees with random names"
	task populate_employees: :environment do
		require 'populator'
		require 'forgery'
		n = 0
		Employee.populate 50 do |employee|
			n += 1
			employee.gender = Forgery('personal').abbreviated_gender
			employee.first_name = employee.gender == 'F' ? Forgery('name').female_first_name : Forgery('name').male_first_name
			employee.last_name  = Forgery::NameIndonesian.name
			employee.name = employee.first_name + ' ' + employee.last_name
			employee.date_of_birth = Forgery('date').date
			employee.place_of_birth = Forgery::CityIndonesia.name
			employee.blood_type = ['O+','O-','A+','A-','B+','B-','AB+','AB-'][rand(8)]
			employee.nationality = 'Indonesian'
			employee.joining_date = Forgery('date').date
			employee.job_title = Forgery('name').job_title
			employee.home_address_line1 = Forgery('address').street_address
			employee.home_city = Forgery('address').city
			employee.home_state = Forgery('address').state
			employee.home_postal_code = Forgery('address').zip
			employee.home_country = 'Indonesia'
			employee.mobile_phone = '0899-'+Forgery('address').phone[7..14]
			employee.home_phone = Forgery('address').phone[2..14]
			employee.other_phone = '0899-'+Forgery('address').phone[7..14]
			employee.email = employee.first_name.downcase + Forgery('email').address.match(/@.*/).to_s
			employee.emergency_contact_number = '0899-'+Forgery('address').phone[7..14]
			employee.emergency_contact_name = Forgery('name').full_name
			employee.education_degree = Forgery::Degree.sarjanaS1
			employee.education_graduation_date = Forgery('date').date
			employee.education_school = Forgery::Universitas.universitas_swasta
			employee.education_degree2 = Forgery::Degree.sarjanaS2
			employee.education_graduation_date2 = Forgery('date').date
			employee.education_school2 = Forgery::Universitas.universitas_negeri	
		end
	end
end