namespace :db do
	desc "Populate database with AcademicYear"
	task populate_academic_years: :environment do
		require 'populator'

		AcademicYear.delete_all
		AcademicTerm.delete_all

		# Academic Years and Terms
		n = 0
		year = 2001
		AcademicYear.populate 20 do |acad_year|
			n += 1
			year += 1
			acad_year.name = "#{year}-#{year+1}"
			acad_year.start_date = Date.new(year, 6, 1)
			acad_year.end_date = Date.new(year+1, 5, 31)

			t = 1
			AcademicTerm.populate 1 do |term|
				term.name = "Semester #{t} #{acad_year.name}"
				term.start_date = acad_year.start_date
				term.end_date = Date.new(year, 12, 31)
				term.academic_year_id = acad_year.id
			end
			t += 1
			AcademicTerm.populate 1 do |term|
				term.name = "Semester #{t} #{acad_year.name}"
				term.start_date = Date.new(year+1, 1, 1)
				term.end_date = acad_year.end_date
				term.academic_year_id = acad_year.id
			end
		end
  end
end
