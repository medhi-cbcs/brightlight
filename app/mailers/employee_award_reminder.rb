class EmployeeAwardReminder < ActionMailer::Base
  default from: "medhi.widjaja@cahayabangsa.org",
          cc: "medhiwidjaja@yahoo.com"
  
  def sample_email
    @user = Employee.find_by_name 'Medhi Widjaja'
    mail(to: %("#{@user.name}" <#{@user.email}>), subject: 'Another Sample Email')
  end

end
