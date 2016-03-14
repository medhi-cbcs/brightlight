namespace :data do
	desc "Setup data"
	task setup_data: :environment do

    BookCondition.delete_all
    columns = [:code, :description, :color]
    values = [['New', 'New', 'blue'], ['Good', 'Good', 'green'], ['Fair', 'Fair', 'yellow'], ['Poor', 'Poor', 'red'], ['Missing', 'Missing', 'maroon']]
    BookCondition.import columns, values

		Status.delete_all
		columns = [:name, :order_no]
		values = [{name:'Available', order_no: 1}, {name:'On loan', order_no: 2}, {name:'In repair', order_no: 3},
		 					{name:'Missing', order_no: 4}]
		Status.import columns, values

    BookCategory.delete_all
    columns = [:code, :name]
    values = [['TB', 'Textbook'],['TM',"Teacher's Manual"],['SB','Story Book'],['PC','Packet'],['S','Sample']]
    BookCategory.import columns, values

		SchoolLevel.delete_all
    columns = [:code, :name]
    values = [['PS', 'Pre-School'],['KG',"Kindergarten"],['SOG','School of Grammar'],['SOL','School of Logic'],['SOR','School of Rethoric']]
    SchoolLevel.import columns, values

		GradeLevel.delete_all
    columns = [:code, :name, :school_level_id]
		levels = SchoolLevel.all.map(&:id)
    values =  [["CG001", "Grade 1", levels[2]], ["CG002", "Grade 2", levels[2]], ["CG003", "Grade 3", levels[2]],
							 ["CG004", "Grade 4", levels[2]], ["CG005", "Grade 5", levels[2]], ["CG006", "Grade 6", levels[2]],
							 ["CG007", "Grade 7", levels[3]], ["CG008", "Grade 8", levels[3]], ["CG009", "Grade 9", levels[3]],
							 ["CG010", "Grade 10", levels[4]], ["CG011", "Grade 11", levels[4]], ["CG012", "Grade 12", levels[4]],
							 ["CG013", "PS", levels[0]], ["CG014", "K-1", levels[1]], ["CG015", "K-2", levels[1]]]
    GradeLevel.import columns, values

		GradeSection.delete_all
		columns = [:name, :grade_level_id]
		grades = GradeLevel.all.map(&:id)
		values = [["PS-A", grades[13]], ["PS-B", grades[13]], ["PS-C", grades[13]], ["K-1A", grades[14]], ["K-1B", grades[14]], ["K-1C", grades[14]], ["K-2A", grades[15]], ["K-2B", grades[15]],
 							["K-2C", grades[15]], ["Grade 1A", grades[1]], ["Grade 1B", grades[1]], ["Grade 1C", grades[1]], ["Grade 2A", grades[2]], ["Grade 2B", grades[2]], ["Grade 2C", grades[2]],
 							["Grade 3A", grades[3]], ["Grade 3B", grades[3]], ["Grade 3C", grades[3]], ["Grade 4A", grades[4]], ["Grade 4B", grades[4]], ["Grade 4C", grades[4]],
							["Grade 5A", grades[5]], ["Grade 5B", grades[5]], ["Grade 5C", grades[5]], ["Grade 6A", grades[6]], ["Grade 6B", grades[6]], ["Grade 6C", grades[6]],
							["Grade 7A", grades[7]], ["Grade 7B", grades[7]], ["Grade 7C", grades[7]], ["Grade 8A", grades[8]], ["Grade 8B", grades[8]], ["Grade 8C", grades[8]],
							["Grade 9A", grades[9]], ["Grade 9B", grades[9]], ["Grade 9C", grades[9]], ["Grade 10A", grades[10]], ["Grade 10B", grades[10]], ["Grade 10C", grades[10]],
							["Grade 11A", grades[11]], ["Grade 11B", grades[11]], ["Grade 11C", grades[11]], ["Grade 12A", grades[12]], ["Grade 12B", grades[12]],["Grade 12C", grades[12]]]
		GradeSection.import columns, values

		AcademicYear.delete_all
		columns = [:name, :start_date, :end_date]
		values = (2001..2020).map{|x|x}.map{|y| ["#{y}-#{(y+1)}", Date.new(y, 6, 1), Date.new(y+1, 5, 31)]}
		AcademicYear.import columns, values

		AcademicTerm.delete_all
		columns = [:name, :academic_year_id, :start_date, :end_date]
		values = (2001..2020).map{|x|x}.each_with_index.map do |y,i|
			[["Semester 1 #{y}-#{(y+1)}", i+1, Date.new(y, 6, 1), Date.new(y, 12, 31)],
			 ["Semester 2 #{y}-#{(y+1)}", i+1, Date.new(y+1, 1, 1), Date.new(y+1, 5, 31)]]
		end.reduce([]){|a,x| a<<x.first;a<<x.last}
		AcademicTerm.import columns, values

  end
end
