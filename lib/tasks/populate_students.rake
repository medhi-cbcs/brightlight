namespace :db do
	desc "Create students with random names"
	task populate_students: :environment do
		require 'forgery'

		Student.delete_all
		Guardian.delete_all
		StudentsGuardian.delete_all

		n = 0
		117.times do
			n += 1
			moms_name = Forgery('name').female_first_name
			dads_name = Forgery('name').male_first_name
			moms_id = 0

			dad = Guardian.new
			dad.first_name = dads_name
			dad.last_name =  Forgery::NameIndonesian.name
			dad.name = dads_name + ' ' + dad.last_name
			dad.address_line1 = Forgery::StreetNameIndonesia.name + " #{rand(249)}"
			dad.city = ['Bandung','Cimahi','Padalarang'][rand(0..2)]
			dad.state = 'Jawa Barat'
			dad.postal_code = Forgery('address').zip
			dad.country = 'Indonesia'
			dad.mobile_phone = '0899-'+Forgery('address').phone[7..14]
			dad.other_phone = '0899-'+Forgery('address').phone[7..14]
			dad.home_phone = Forgery('address').phone[2..14]
			dad.office_phone = Forgery('address').phone[2..14]
			dad.family_no = 134 + n
			dad.save!

			mom = Guardian.new
			mom.first_name = moms_name
			mom.last_name=  dad.last_name
			mom.name = moms_name + ' ' + dad.last_name
			mom.address_line1 = dad.address_line1
			mom.city = dad.city
			mom.state = dad.state
			mom.postal_code = dad.postal_code
			mom.country = dad.country
			mom.mobile_phone = '0899-'+Forgery('address').phone[7..14]
			mom.other_phone = '0899-'+Forgery('address').phone[7..14]
			mom.home_phone = dad.home_phone
			mom.office_phone = Forgery('address').phone[2..14]
			mom.family_no = dad.family_no
			mom.save!

			rand(1..3).times do
				student = Student.new
				student.gender = Forgery('personal').abbreviated_gender
				student.first_name = student.gender == 'F' ? Forgery('name').female_first_name : Forgery('name').male_first_name
				student.last_name  = dad.last_name
				student.name = student.first_name + ' ' + dad.last_name
				student.date_of_birth = Forgery('date').date
				student.admission_no = 340 + n
				student.family_id = dad.family_no
				student.blood_type = ['O+','O-','A+','A-','B+','B-','AB+','AB-'][rand(8)]
				student.nationality = 'Indonesian'
				student.religion = 'Christian'
				student.address_line1 = dad.address_line1
				student.city = dad.city
				student.state = dad.state
				student.postal_code = dad.postal_code
				student.country = dad.country
				student.mobile_phone = '0899-'+Forgery('address').phone[7..14]
				student.home_phone = dad.home_phone
				student.email = student.first_name.downcase + Forgery('email').address.match(/@.*/).to_s
				student.enrollment_date = Forgery('date').date
				student.save!

				StudentsGuardian.create(student_id: student.id, guardian_id: mom.id, relation: 'Mother')
				StudentsGuardian.create(student_id: student.id, guardian_id: dad.id, relation: 'Father')
			end
		end

	end
end
