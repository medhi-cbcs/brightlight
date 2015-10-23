namespace :db do
	desc "Create students with random names"
	task populate_students: :environment do
		require 'populator'
		require 'forgery'
		n = 0
		Student.populate 100 do |student|
			n += 1
			student.gender = Forgery('personal').abbreviated_gender
			student.first_name = student.gender == 'F' ? Forgery('name').female_first_name : Forgery('name').male_first_name
			student.last_name  = Forgery::NameIndonesian.name
			student.name = student.first_name + ' ' + student.last_name
			student.date_of_birth = Forgery('date').date
			student.admission_no = 200 + n
			student.family_id = 100 + n 
			student.blood_type = ['O+','O-','A+','A-','B+','B-','AB+','AB-'][rand(8)]
			student.nationality = 'Indonesian'
			student.religion = 'Christian'
			student.address_line1 = Forgery('address').street_address
			student.city = Forgery('address').city
			student.state = Forgery('address').state
			student.postal_code = Forgery('address').zip
			student.country = 'Indonesia'
			student.mobile_phone = '0899-'+Forgery('address').phone[7..14]
			student.home_phone = Forgery('address').phone[2..14]
			student.email = student.first_name + Forgery('email').address.match(/@.*/).to_s
			student.enrollment_date = Forgery('date').date
		end
	end
end