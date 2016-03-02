class Person < ActiveRecord::Base
  belongs_to :user
  has_one :student
  has_one :employee
  has_one :guardian

  def is_a_teacher?
    employee.present? ? employee.job_title == 'teacher' : false
  end

  def is_a_staff?
    employee.present? ? employee.job_title != 'teacher' : false
  end

  def is_a_student?
    student.present?
  end

  def is_a_guardian?
    guardian.present?
  end
end
