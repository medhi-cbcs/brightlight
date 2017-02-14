class BookLoan < ActiveRecord::Base

  validates :book_copy, presence: true
  validates :academic_year, presence: true
  validates :book_copy_id, uniqueness: {scope: [:academic_year_id, :return_status]}
             # if: Proc.new { |record| record.return_status == nil }

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

  has_many :loan_checks

  scope :current, lambda { where(academic_year: AcademicYear.current) }
  scope :returned, lambda { where(return_status:'R') }
  scope :not_returned, lambda { where(return_status: nil) }
  scope :with_title_and_subject, lambda { joins('LEFT JOIN book_titles ON book_titles.id = book_loans.book_title_id')  
            .joins('LEFT JOIN book_editions ON book_editions.id = book_loans.book_edition_id')   
            .joins('LEFT JOIN subjects ON book_titles.subject_id = subjects.id')                       
            .select('book_loans.*, book_editions.title as title, subjects.name as subject') }

  def self.list_for_teacher(teacher_id, year)
    loans = BookLoan.includes([:employee,:book_copy,:book_edition,:academic_year])
                .joins('LEFT JOIN book_titles ON book_titles.id = book_loans.book_title_id')
                .joins("LEFT JOIN subjects ON subjects.id = book_titles.subject_id")
                .select('book_loans.*, subjects.name as subject, book_titles.title as title')
    if year.present? && year.downcase != 'all' 
      loans = loans.where(academic_year_id:year)
    elsif year.blank?
      loans =  loans.current
    end
    loans = loans.where(employee_id:teacher_id) if teacher_id.present?
  end

  def self.list_for_teachers_receipt(year_id, teacher_id)
    BookLoan.select(['COUNT (book_loans.loan_status) AS loan_qty',
        "COUNT (case when book_loans.return_status = 'R' then 1 else null end) AS return_qty",
        'subjects.name','book_editions.title','book_editions.authors','book_editions.publisher', 
        'book_editions.isbn13','book_editions.isbn10', 'book_loans.notes'])
      .where('book_loans.academic_year_id = ? AND book_loans.employee_id = ?', year_id, teacher_id)      
      .joins("LEFT JOIN book_editions ON book_editions.id = book_loans.book_edition_id")
      .joins("LEFT JOIN book_titles ON book_titles.id = book_loans.book_title_id")
      .joins("LEFT JOIN subjects ON subjects.id = book_titles.subject_id")
      .group('subjects.name','book_editions.title', 'book_editions.authors','book_editions.publisher', 'book_editions.isbn13', 'book_editions.isbn10','book_loans.notes')
      .order('name','title')
  end

  def self.initialize_teacher_loans_from_previous_year(previous_year_id, new_year_id)
    columns = [:book_copy_id, :book_edition_id, :book_title_id, :person_id, :book_category_id, :loan_type_id,
                :out_date, :due_date, :academic_year_id, :user_id, :barcode, :refno,
                :prev_academic_year_id, :loan_status, :bkudid, :employee_id, :deleted_flag]
    values = []
    BookLoan.where(academic_year_id: previous_year_id).where.not(employee_id: nil).each do |bl|
      data = [bl.book_copy_id, bl.book_edition_id, bl.book_title_id, bl.person_id, bl.book_category_id, bl.loan_type_id,
                Date.today, Date.today+360, new_year_id, bl.user_id, bl.barcode, bl.refno,
                previous_year_id, 'B', bl.bkudid, bl.employee_id, false]
      values << data
    end
    BookLoan.import columns, values
  end

  # BookLoan.move_all_books(from:Employee.find(3),to:Employee.find(4),from_year:AcademicYear.current_id-1,to_year:AcademicYear.current)
  def self.move_all_books(from:,to:, from_year:, to_year:)
    source = Employee.find(from.id)
    destination = Employee.find(to.id)

    # This would be efficient, but it doesn't update the updated_at field
    # BookLoan.where(employee:source,academic_year:from_year).update_all(employee_id:to.id, academic_year_id:to_year.id)

    tmp = source.book_loans.where(academic_year:from_year).map { |x|
            x.attributes.except('created_at','updated_at','id').merge('academic_year_id'=>to_year)
          }
    source.book_loans.where(academic_year:from_year).delete_all if from_year == to_year
    destination.book_loans.create(tmp)
  end

  def move_book(to:, to_year:nil)
    if to_year == nil or academic_year_id == to_year.id
      r = update_attribute :employee, to
      return !!r
    else
      r = BookLoan.create attributes.except('created_at','updated_at','id').merge('employee_id'=>to.id,'academic_year_id'=>to_year.id)
      return r.valid?
    end
  end
  
  def grade_section_name
    student.grade_section_with_academic_year_id(self.academic_year_id).try(:name) if student.present?
  end
end
