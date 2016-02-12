namespace :db do
	desc "Populate database with school's structure"
	task populate_school: :environment do
		require 'populator'
		require 'forgery'
		
		AcademicYear.delete_all
		AcademicTerm.delete_all
		Department.delete_all
		Employee.delete_all

		# Academic Years and Terms
		n = 0
		year = 2009
		AcademicYear.populate 6 do |acad_year|
			n += 1
			year += 1
			acad_year.name = "#{year}-#{year+1}"
			acad_year.start_date = Date.new(year, 8, 10)
			acad_year.end_date = Date.new(year+1, 7, 17)

			t = 1
			AcademicTerm.populate 1 do |term|
				term.name = "Semester #{t} #{acad_year.name}"
				term.start_date = acad_year.start_date
				term.end_date = Date.new(year, 12, 15)
				term.academic_year_id = acad_year.id
			end
			t += 1
			AcademicTerm.populate 1 do |term|
				term.name = "Semester #{t} #{acad_year.name}"
				term.start_date = Date.new(year+1, 1, 5)
				term.end_date = acad_year.end_date
				term.academic_year_id = acad_year.id
			end
		end

		# Departments
		depts = [{name: 'Management', code:'MGT'},
						 {name: 'School of Rethoric', code:'SOR'},
						 {name: 'School of Logic', code:'SOL'},
						 {name: 'Grammar School', code:'GS'},
						 {name: 'Early Childhood', code:'EC'},
						 {name: 'Human Resources', code:'HR'},
						 {name: 'Business Operations', code:'BO'},
						 {name: 'General Affairs', code:'GA'},
						 {name: 'Public Relations', code:'PR'},
						 {name: 'Multimedia', code:'MM'},
						 {name: 'Information Technology', code:'IT'}
						]
		depts.each do |dept|
			Employee.populate 1 do |employee|
				employee.gender = Forgery('personal').abbreviated_gender
				employee.first_name = employee.gender == 'F' ? Forgery('name').female_first_name : Forgery('name').male_first_name
				employee.last_name  = Forgery::NameIndonesian.name
				employee.name = employee.first_name + ' ' + employee.last_name
				employee.date_of_birth = Forgery('date').date
				employee.place_of_birth = Forgery::CityIndonesia.name
				employee.blood_type = ['O+','O-','A+','A-','B+','B-','AB+','AB-'][rand(8)]
				employee.nationality = 'Indonesian'
				employee.joining_date = Forgery('date').date
				employee.home_address_line1 = Forgery::StreetNameIndonesia.name + " #{rand(249)}"
				employee.home_city = ['Bandung','Cimahi','Padalarang'][rand(0..2)]
				employee.home_state = 'Jawa Barat'
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
				employee.employment_status = 'Permanent'

				Department.populate 1 do |department|
					department.name = dept[:name]
					department.code = dept[:code]
					department.manager_id = employee.id
					employee.job_title = 'Head of ' + department.name
					employee.department_id = department.id
				end		
			end
		end

		# Employees
		n = 0
		Employee.populate 70 do |employee|
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
			dept = Department.all[rand(1..10)]
			employee.department_id = dept.id
			employee.job_title = if dept.code == 'SOR' || dept.code == 'SOL' || dept.code == 'GS' || dept.code == 'EC' then
				'Teacher' else Forgery('name').job_title end
			employee.supervisor_id = dept.manager_id
			employee.home_address_line1 = Forgery::StreetNameIndonesia.name + " #{rand(249)}"
			employee.home_city = ['Bandung','Cimahi','Padalarang'][rand(0..2)]
			employee.home_state = 'Jawa Barat'
			employee.home_postal_code = Forgery('address').zip
			employee.home_country = 'Indonesia'
			employee.mobile_phone = '0899-' + Forgery('address').phone[7..14]
			employee.home_phone = Forgery('address').phone[2..14]
			employee.other_phone = '0899-' + Forgery('address').phone[7..14]
			employee.email = employee.first_name.downcase + Forgery('email').address.match(/@.*/).to_s
			employee.emergency_contact_number = '0899-' + Forgery('address').phone[7..14]
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