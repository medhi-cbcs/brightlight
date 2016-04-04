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
    subject_classes = ['CG011.1','CG011.2','CG012.1','CG012.2']
    if subject_classes.include? grade_section_code
      GradeSection.select(:name).where(subject_code: grade_subject_code).take.try(:name)
    else
      GradeSection.select(:name).where(parallel_code: grade_section_code).take.try(:name)
    end
  end
end
