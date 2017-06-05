class LoanCheck < ActiveRecord::Base
  belongs_to :book_loan
  belongs_to :book_copy
  belongs_to :user
  belongs_to :academic_year

  scope :for_year, lambda {|year| where(academic_year_id: year) }
  scope :current, lambda { where(academic_year_id: AcademicYear.current_id) }
  scope :for_employee, lambda { |emp_id| where(loaned_to: emp_id) }
  scope :all_matched, lambda { where(matched: true) }
  scope :details, lambda {
    joins('LEFT JOIN employees lt ON lt.id = loaned_to')
    .joins('LEFT JOIN employees sf ON sf.id = scanned_for')
    .joins(:user)
    .select("book_loan_id, book_copy_id, loan_checks.user_id, loaned_to, scanned_for, academic_year_id, matched, loan_checks.created_at, lt.name loaned_to_name, sf.name scanned_for_name, users.name checked_by_name")
    .order('loan_checks.created_at DESC')
  }
  def loaned_to_employee
    Employee.find loaned_to if loaned_to
  end 

  def scanned_for_employee 
    Employee.find scanned_for if scanned_for 
  end 
end
