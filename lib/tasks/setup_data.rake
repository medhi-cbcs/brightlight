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
    values =  [["CG001", "Grade 1", 3], ["CG002", "Grade 2", 3], ["CG003", "Grade 3", 3], ["CG004", "Grade 4", 3], ["CG005", "Grade 5", 3],
							 ["CG006", "Grade 6", 3], ["CG007", "Grade 7", 4], ["CG008", "Grade 8", 4], ["CG009", "Grade 9", 4], ["CG010", "Grade 10", 5],
							 ["CG011", "Grade 11", 5], ["CG012", "Grade 12", 5], ["CG013", "PS", 1], ["CG014", "K-1", 2], ["CG015", "K-2", 2]]
    GradeLevel.import columns, values

		GradeSection.delete_all
		columns = [:name, :grade_level_id]
		values = [["PS-A", 13], ["PS-B", 13], ["PS-C", 13], ["K-1A", 14], ["K-1B", 14], ["K-1C", 14], ["K-2A", 15], ["K-2B", 15],
 							["K-2C", 15], ["Grade 1A", 1], ["Grade 1B", 1], ["Grade 1C", 1], ["Grade 2A", 2], ["Grade 2B", 2], ["Grade 2C", 2],
 							["Grade 3A", 3], ["Grade 3B", 3], ["Grade 3C", 3], ["Grade 4A", 4], ["Grade 4B", 4], ["Grade 4C", 4],
							["Grade 5A", 5], ["Grade 5B", 5], ["Grade 5C", 5], ["Grade 6A", 6], ["Grade 6B", 6], ["Grade 6C", 6],
							["Grade 7A", 7], ["Grade 7B", 7], ["Grade 7C", 7], ["Grade 8A", 8], ["Grade 8B", 8], ["Grade 8C", 8],
							["Grade 9A", 9], ["Grade 9B", 9], ["Grade 9C", 9], ["Grade 10A", 10], ["Grade 10B", 10], ["Grade 10C", 10],
							["Grade 11A", 11], ["Grade 11B", 11], ["Grade 11C", 11], ["Grade 12A", 12], ["Grade 12B", 12],["Grade 12C", 12]]
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
