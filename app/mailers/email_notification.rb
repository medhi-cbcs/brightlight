class EmailNotification < ActionMailer::Base
  default from: "Brightlight <brightlight@cahayabangsa.org>",
          bcc: "medhiwidjaja@cahayabangsa.org"
  
  def sample_email
    @user = Employee.find_by_name 'Medhi Widjaja'
    mail(to: %("#{@user.name}" <#{@user.email}>), subject: 'Another Sample Email')
  end

  def scan_completed(user)
    @user = user
    mail(to: %("#{@user.name}" <#{@user.email}>), subject: 'Book scan completed.')
  end 

end
