class StudentBook < ActiveRecord::Base
  belongs_to :student
  belongs_to :book_copy
  belongs_to :book_edition
  belongs_to :academic_year
  belongs_to :prev_academic_year, class_name: "AcademicYear"
  belongs_to :course_text
  belongs_to :grade_section
  belongs_to :grade_level
  belongs_to :course
  belongs_to :initial_copy_condition, class_name: "BookCondition"
  belongs_to :end_copy_condition, class_name: "BookCondition"

  validates :student, presence: true
  validates :book_copy, presence: true
  validates :academic_year, presence: true
  # validates :course, presence: true
  # validates :course_text, presence: true
  validates :grade_level, presence: true
  validates :grade_section, presence: true

  scope :current_year, lambda { where(academic_year:AcademicYear.current) }
  scope :standard_books, lambda { |grade_level_id, year_id|
    joins("JOIN standard_books ON student_books.book_edition_id = standard_books.book_edition_id
            AND student_books.grade_level_id = standard_books.grade_level_id
            AND standard_books.academic_year_id = #{year_id}")
  }

  def initial_condition
    initial_copy_condition #|| book_copy.current_start_condition
  end

  def end_condition
    end_copy_condition
  end
end
