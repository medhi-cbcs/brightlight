class LoanCheck < ActiveRecord::Base
  belongs_to :book_loan
  belongs_to :book_copy
  belongs_to :user
  belongs_to :academic_year

  scope :for_year, lambda {|year| where(academic_year_id: year) }
  scope :current, lambda { where(academic_year_id: AcademicYear.current_id) }
  scope :for_employee, lambda { |emp_id| where(loaned_to: emp_id) }
  scope :all_matched, lambda { where(matched: true) }

  def loaned_to_employee
    Employee.find loaned_to if loaned_to
  end 

  def scanned_for_employee 
    Employee.find scanned_for if scanned_for 
  end 
end
