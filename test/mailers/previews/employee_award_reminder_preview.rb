class EmployeeAwardReminderPreview < ActionMailer::Preview

  def sample_mail_preview
    EmployeeAwardReminder.sample_email
  end
  
end
