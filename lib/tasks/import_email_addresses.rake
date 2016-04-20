namespace :data do
	desc "Import email addresses"
	task import_email_addresses: :environment do

    xl = Roo::Spreadsheet.open('lib/tasks/ListEmail2015-2016.xlsx')
    sheet = xl.sheet('Sheet1')

    header = {email: "Email address", first_name: "First name", last_name: "Last name"}

    sheet.each_with_index(header) do |row,i|
			next if i < 1
      email = row[:email]
      first_name = row[:first_name]
      last_name = row[:last_name]

      employee = Employee.where('LOWER(name) = ?', first_name.downcase+' '+last_name.downcase).take
      if employee.blank?
        employee = Employee.where('LOWER(first_name) LIKE ?', "%#{first_name.downcase.split(" ")[0]}%").where('LOWER(last_name) LIKE ?', "%#{last_name.downcase.split(" ")[0]}%").take
      end
      if employee.present?
        employee.email = email
        employee.save
      else
        puts "#{employee.try(:name)}, #{email}"
      end
    end
    Employee.all.each do |employee|
      if employee.email.present?
        unless User.exists?(email:employee.email)
          employee.build_person(email:employee.email, name:employee.name, first_name:employee.first_name, last_name:employee.last_name)
        else
          user = User.where(email:employee.email).take
          user.update(name:employee.name,first_name:employee.first_name,last_name:employee.last_name)
          employee.person = user
        end
        employee.save
      end
    end
  end
end
