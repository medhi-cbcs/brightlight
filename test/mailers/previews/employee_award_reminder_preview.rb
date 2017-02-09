class EmployeeAwardReminderPreview < ActionMailer::Preview

  def sample_email
    EmployeeAwardReminder.sample_email
  end
  
end
