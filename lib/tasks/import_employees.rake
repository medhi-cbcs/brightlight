namespace :data do
	desc "Import book employees"
	task import_employees: :environment do

    # Read Book title from Employee_Master
    xl = Roo::Spreadsheet.open('lib/tasks/Database_2.xlsx')
    sheet = xl.sheet('Employee_Master')

    header = {id:"EMP_IDLIST", employee_no:"EMP_ID", family_no:"FAMILY_ID", first_name:"EMP_NAME1", last_name:"EMP_NAME2", name:"EMP_NAMECOMPLETE",
              nick_name:"EMP_NICKNAME", gender:"EMP_GENDER",date_input:"EMP_DATEINPUT", time_input:"EMP_TIMEINPUT", index:"EMP_INDEX", user_id:"EMP_IDUSER",
              date_accepted:"EMP_DATEACCEPTED"}

		sheet.each_with_index(header) do |row,i|
			next if i < 1
			# break if i > 21

      employee = Employee.new(
        employee_number: row[:employee_no],
        first_name: row[:first_name],
        last_name: row[:last_name],
        name: row[:name],
        nick_name: row[:nick_name],
        gender: row[:gender],
        joining_date: row[:date_accepted],
        is_active: row[:index] == 1
      )

			employee.save
			puts "#{i}. #{employee.name}"
		end
  end
end
