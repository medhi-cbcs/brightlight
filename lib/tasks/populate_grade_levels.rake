namespace :db do
	desc "Populate database with grade levels and sections"
	task populate_grade_levels: :environment do

		SchoolLevel.delete_all
		GradeLevel.delete_all
		GradeSection.delete_all

		school_level_data = [['PS', 'Pre-School'],['KG',"Kindergarten"],['SOG','School of Grammar'],['SOL','School of Logic'],['SOR','School of Rethoric']]
    grade_level_data =  [[["CG013", "PS"]],
							 [["CG014", "K-1"], ["CG015", "K-2"]],
							 [["CG001", "Grade 1"], ["CG002", "Grade 2"], ["CG003", "Grade 3"], ["CG004", "Grade 4"], ["CG005", "Grade 5"], ["CG006", "Grade 6"]],
							 [["CG007", "Grade 7"], ["CG008", "Grade 8"], ["CG009", "Grade 9"]],
							 [["CG010", "Grade 10"], ["CG011", "Grade 11"], ["CG012", "Grade 12"]]]
		grade_section_data = [["PS-A", "PS-B", "PS-C"],
							["K-1A", "K-1B", "K-1C"], ["K-2A", "K-2B", "K-2C"],
 							["Grade 1A", "Grade 1B", "Grade 1C"], ["Grade 2A", "Grade 2B", "Grade 2C"],
 							["Grade 3A", "Grade 3B", "Grade 3C"], ["Grade 4A", "Grade 4B", "Grade 4C"],
							["Grade 5A", "Grade 5B", "Grade 5C"], ["Grade 6A", "Grade 6B", "Grade 6C"],
							["Grade 7A", "Grade 7B", "Grade 7C"], ["Grade 8A", "Grade 8B", "Grade 8C"],
							["Grade 9A", "Grade 9B", "Grade 9C"], ["Grade 10A", "Grade 10B", "Grade 10C"],
							["Grade 11A", "Grade 11B", "Grade 11C"], ["Grade 12A", "Grade 12B","Grade 12C"]]

		k = 0
		school_level_data.each_with_index do |data, i|
			sl = SchoolLevel.new(code:data.first, name:data.last)
			sl.save
			puts "#{i}. SL:" + data.first
			grade_level_data[i].each do |data|
				gl = GradeLevel.create(code:data.first, name:data.last)
				gl.save
				sl.grade_levels << gl
				puts "   #{k} GL: " + data.first
				grade_section_data[k].each do |name|
					# gs = gl.grade_sections.create(name:name)
					gs = GradeSection.create(name:name)
					gs.save
					puts "      - GS: " + name
					gl.grade_sections << gs
				end
				k += 1
			end
		end

	end
end
