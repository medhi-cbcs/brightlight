namespace :data do
	desc "Setup data"
	task setup_data: :environment do

    BookCondition.delete_all
    columns = [:code, :description, :order_no, :color]
    values = [['New', 'New', 1, 'blue'], ['Good', 'Good', 2, 'green'], ['Fair', 'Fair', 3, 'yellow'], ['Poor', 'Poor', 4, 'red'], ['Missing', 'Missing', 5, 'maroon']]
    BookCondition.import columns, values

    BookCategory.delete_all
    columns = [:code, :name]
    values = [['TB', 'Textbook'],['TM',"Teacher's Manual"],['SB','Story Book'],['PC','Packet'],['S','Sample']]
    BookCategory.import columns, values


  end
end
