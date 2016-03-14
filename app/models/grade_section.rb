class GradeSection < ActiveRecord::Base
  validates :name, presence: true
  # validates :academic_year, presence: true
  slug :name
  belongs_to :grade_level
  belongs_to :homeroom, class_name: "Employee"
  belongs_to :academic_year

  has_many :course_sections
  has_many :grade_sections_students, dependent: :destroy
  has_many :students, through: :grade_sections_students
  has_many :student_books
  has_many :book_labels

  scope :with_academic_year, lambda {|academic_year| where(academic_year: academic_year)}

  accepts_nested_attributes_for :students
  accepts_nested_attributes_for :grade_sections_students, allow_destroy: true, reject_if: :all_blank

  def textbooks
    course_sections.map { |cs| cs.textbooks } unless course_sections.blank?
  end

  def add_student(student, academic_year_id)
    GradeSectionsStudent.create(grade_section: self, student:student, academic_year_id: academic_year_id || AcademicYear.current_id)
  end

end
