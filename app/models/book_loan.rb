class BookLoan < ActiveRecord::Base
  belongs_to :book_copy
  belongs_to :book_edition
  belongs_to :book_title
  belongs_to :student
  belongs_to :employee
  belongs_to :book_category
  belongs_to :loan_type
  belongs_to :academic_year
  belongs_to :prev_academic_year, class_name: "AcademicYear"

  scope :current, lambda { where(academic_year: AcademicYear.current) }

  def grade_section_name
    student.grade_section_with_academic_year_id(self.academic_year_id).try(:name)
  end
end
