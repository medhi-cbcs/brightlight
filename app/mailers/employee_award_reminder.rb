class EmployeeAwardReminder < ActionMailer::Base
  default from: "hrd@cahayabangsa.org"
  
  def sample_email
    @user = Employee.find_by_name 'Medhi Widjaja'
    mail(to: @user.email, subject: 'Sample Email')
  end

end
