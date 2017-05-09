class TeachersBook < ActiveRecord::Base
  self.primary_key = :id

  belongs_to :book_copy
  belongs_to :book_edition
  belongs_to :book_title
  belongs_to :student
  belongs_to :employee
  belongs_to :book_category
  belongs_to :loan_type
  belongs_to :academic_year
  belongs_to :prev_academic_year, class_name: "AcademicYear"
  belongs_to :user
  has_many :loan_checks, foreign_key: 'book_loan_id'

  scope :for, lambda { |teacher| where(employee: teacher) }
  scope :year, lambda { |year| where(academic_year: year) }

  private

  def read_only?
    true
  end
    
end