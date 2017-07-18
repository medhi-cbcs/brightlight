class GradeSection < ActiveRecord::Base
  validates :name, presence: true

  # slug :name
  belongs_to :grade_level
  belongs_to :homeroom, class_name: "Employee"
  belongs_to :assistant, class_name: 'Employee'
  belongs_to :academic_year

  has_many :course_sections
  has_many :grade_sections_students, dependent: :destroy
  has_many :students, through: :grade_sections_students
  has_many :student_books
  has_many :book_labels, -> { order("cast(substring(name from position('#' in name)+1)  as integer)")}
  has_many :grade_section_histories
  has_many :book_receipts

  accepts_nested_attributes_for :students
  accepts_nested_attributes_for :grade_sections_students, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :book_receipts,
    allow_destroy: true,
    reject_if: proc { |attributes| attributes['book_copy_id'].blank? }

  def current_year_students
    grade_sections_students.where(academic_year:AcademicYear.current_id).includes([:student])
  end

  def students_for_academic_year(academic_year_id)
    grade_sections_students.where(academic_year:academic_year_id).includes([:student])
  end

  def current_students
    grade_sections_students.where(academic_year:AcademicYear.current_id).order(:order_no).map &:student
  end

  def number_of_students_for_academic_year_id(year_id)
    self.grade_sections_students.where(academic_year_id:year_id).count
  end

  def number_of_students_for_current_academic_year
    number_of_students_for_academic_year_id AcademicYear.current_id
  end

  def textbooks
    course_sections.map { |cs| cs.textbooks } unless course_sections.blank?
  end

  # TODO: Fix StandardBook where clause to include Track
  def standard_books(year)
    grade_section_books = StandardBook.where(academic_year:year,grade_section_id:self.id)
    if grade_section_books.count > 1
      grade_section_books.includes(:book_edition)
      #BookTitle.joins(:standard_books).where(standard_books: {grade_section_id:self.id, academic_year_id:AcademicYear.current_id})
    else
      StandardBook.where(academic_year:year,grade_level_id:self.grade_level_id).includes(:book_edition)
      #BookTitle.joins(:standard_books).where(standard_books: {grade_level_id:self.grade_level_id, academic_year_id:AcademicYear.current_id})
    end
  end

  def add_student(student, academic_year_id)
    GradeSectionsStudent.create(grade_section: self, student:student, academic_year_id: academic_year_id || current_academic_year_id)
  end

  def homeroom_for_academic_year(academic_year_id)
    if academic_year_id < AcademicYear.current_id
      GradeSectionHistory.where(grade_section:self,academic_year:academic_year_id).take.try(:homeroom)
    else
      homeroom
    end
  end

  def self.book_labels_for_select
    self.all.order(:id).includes(:book_labels).map { |section|
      [ section.name , section.book_labels.map {|label| [label.name, label.id]} ]
    }.reject {|g, labels| labels.blank? }
  end
end
