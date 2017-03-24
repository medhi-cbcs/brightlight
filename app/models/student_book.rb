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
  belongs_to :book_loan

  validates :student, presence: true
  validates :book_copy, presence: true
  validates :academic_year, presence: true
  # validates :course, presence: true
  # validates :course_text, presence: true
  validates :grade_level, presence: true
  validates :grade_section, presence: true
  validates :book_copy, uniqueness: { scope: [:academic_year_id, :student_id],
    message: "cannot add same book for the same student in the same year" }

  after_save :update_book_copy_condition

  accepts_nested_attributes_for :book_loan

  scope :current_year, lambda { where(academic_year:AcademicYear.current) }

  scope :standard_books, lambda { |grade_level_id, grade_section_id, year_id, category_id|
    if [11,12].include? grade_level_id
      joins("JOIN standard_books ON student_books.book_edition_id = standard_books.book_edition_id
      AND #{grade_section_id} = standard_books.grade_section_id
      AND standard_books.book_category_id = #{category_id}
      AND standard_books.academic_year_id = #{year_id}")
    else
      joins("JOIN standard_books ON student_books.book_edition_id = standard_books.book_edition_id
      AND #{grade_level_id} = standard_books.grade_level_id
      AND standard_books.book_category_id = #{category_id}
      AND standard_books.academic_year_id = #{year_id}")
    end
    .joins('LEFT JOIN book_editions ON student_books.book_edition_id = book_editions.id')
    .where(academic_year_id:year_id)
    .select('student_books.*, book_editions.title as title')
  }

  # Fine is applied if end condition is 2 steps worser than the initial condition, of if the book is missing
  # Here 'missing' is hardcoded with id=5
  scope :fine_applies, lambda { where('(end_copy_condition_id - initial_copy_condition_id >= 2) OR end_copy_condition_id=5')}

  def initial_condition
    initial_copy_condition #|| book_copy.current_start_condition
  end

  def end_condition
    end_copy_condition
  end

  # Create student book records for a specific student and year, from Book Receipt
  def self.initialize_from_book_receipts(gss:, year:)
    student = gss.student
    if student.present?
      grade_section = student.grade_section_with_academic_year_id(year.id)
      roster_no = student.roster_no_with_academic_year_id(year.id)
      if BookReceipt.where(grade_section:grade_section, roster_no:roster_no, academic_year:year).count > 0
        # Create StudentBook record
        StudentBook.create(
          BookReceipt.where(grade_section:grade_section, roster_no:roster_no, academic_year:year).map { |receipt|
            receipt.attributes
            .except('id', 'created_at', 'updated_at', 'notes', 'roster_no', 'active', 'initial_condition_id', 'return_condition_id')
            .merge('roster_no' => receipt.roster_no.to_s, 'student_id' => student.id, 'issue_date' => receipt.created_at,
                    'deleted_flag' => false, 'student_no' => student.student_no,
                    'initial_copy_condition_id' => receipt.initial_condition_id)
          } 
        ) do |sb|
          book_title_id = sb.book_edition.try(:book_title_id)
          book_title = BookTitle.find book_title_id
          standard_book = StandardBook.where(book_title_id: book_title_id, academic_year_id:sb.academic_year_id).take
          book_category = standard_book.try(:book_category_id)

          # Create BookLoan record
          BookLoan.create({
            academic_year_id: sb.academic_year_id,
            barcode:          sb.barcode,
            book_edition_id:  sb.book_edition_id,
            book_title_id:    book_title_id,
            book_category_id: book_category,
            bkudid:           book_title.try(:bkudid),
            book_copy_id:     sb.book_copy_id,
            out_date:         sb.issue_date,
            loan_status:      'B',
            refno:            sb.book_edition.try(:refno),
            roster_no:        sb.roster_no,
            student_id:       sb.student_id,
            student_no:       sb.student_no,
            deleted_flag:     false
          })
        end
      end
    else
      logger.error "Preparing StudentBook. Student not found for #{gss.grade_section.name} no. #{gss.order_no} #{gss.student_id}"
    end
  end

  private

    # This method is called by around_save
    def update_book_copy_condition
      unless book_copy.book_condition_id == end_copy_condition_id
        book_copy.update(book_condition_id: end_copy_condition_id)
      end
    end
end
