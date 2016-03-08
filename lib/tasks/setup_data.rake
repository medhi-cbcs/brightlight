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
    values =  [["CG001", "Grade 1", 3],
							 ["CG002", "Grade 2", 3],
							 ["CG003", "Grade 3", 3],
							 ["CG004", "Grade 4", 3],
							 ["CG005", "Grade 5", 3],
							 ["CG006", "Grade 6", 3],
							 ["CG007", "Grade 7", 4],
							 ["CG008", "Grade 8", 4],
							 ["CG009", "Grade 9", 4],
							 ["CG010", "Grade 10", 5],
							 ["CG011", "Grade 11", 5],
							 ["CG012", "Grade 12", 5],
							 ["CG013", "PS", 1],
							 ["CG014", "K-1", 2],
							 ["CG015", "K-2", 2]]
    GradeLevel.import columns, values

		GradeSection.delete_all
		columns = [:name, :grade_level_id]
		values = [["PS-A", 13], ["PS-B", 13], ["PS-C", 13], ["K-1A", 14], ["K-1B", 14], ["K-1C", 14], ["K-2A", 15], ["K-2B", 15],
 							["K-2C", 15], ["GRADE-1A", 1], ["GRADE-1B", 1], ["GRADE-1C", 1], ["GRADE-2A", 2], ["GRADE-2B", 2], ["GRADE-2C", 2],
 							["GRADE-3A", 3], ["GRADE-3B", 3], ["GRADE-3C", 3], ["GRADE-4A", 4], ["GRADE-4B", 4], ["GRADE-4C", 4],
							["GRADE-5A", 5], ["GRADE-5B", 5], ["GRADE-5C", 5], ["GRADE-6A", 6], ["GRADE-6B", 6], ["GRADE-6C", 6],
							["GRADE-7A", 7], ["GRADE-7B", 7], ["GRADE-7C", 7], ["GRADE-8A", 8], ["GRADE-8B", 8], ["GRADE-8C", 8],
							["GRADE-9A", 9], ["GRADE-9B", 9], ["GRADE-9C", 9], ["GRADE-10A", 10], ["GRADE-10B", 10], ["GRADE-10C", 10],
							["GRADE-11A", 11], ["GRADE-11B", 11], ["GRADE-11C", 11], ["GRADE-12A", 12], ["GRADE-12B", 12],["GRADE-12C", 12]]
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
