class BookCopy < ActiveRecord::Base
  belongs_to :book_edition
  belongs_to :book_condition
  belongs_to :status
  belongs_to :book_label
  validates :book_edition, presence: true
  validates :barcode, presence: true, uniqueness: true
  has_many :copy_conditions, dependent: :destroy
  has_many :book_fines
  has_many :book_loans
  has_many :book_loan_histories
  has_many :book_receipts
  has_many :student_books

  after_create :create_initial_condition
  before_save :sync_book_label, if: :book_label_id_changed?
  before_save :sync_book_edition, if: :book_edition_id_changed?

  scope :standard_books, lambda { |grade_level_id, grade_section_id, year_id|
    if grade_level_id <= 10
      joins("JOIN standard_books ON book_copies.book_edition_id = standard_books.book_edition_id
              AND #{grade_level_id} = standard_books.grade_level_id
              AND standard_books.academic_year_id = #{year_id}")
    else
      joins("JOIN standard_books ON book_copies.book_edition_id = standard_books.book_edition_id
              AND #{grade_section_id} = standard_books.grade_section_id
              AND standard_books.academic_year_id = #{year_id}")
    end
  }

  
  scope :with_condition, lambda { |condition_id|
    query = self.joins('left join copy_conditions c on c.book_copy_id = book_copies.id and c.id = (select id from copy_conditions 
	                  where book_copy_id = book_copies.id order by academic_year_id desc, created_at desc limit 1)')   
                .joins('left join book_labels on book_copies.book_label_id = book_labels.id')                                
                .joins('left join book_conditions bc on bc.id = c.book_condition_id')
                .select('book_copies.barcode, book_copies.id, book_copies.status_id, book_copies.notes, book_copies.book_label_id, book_copies.book_condition_id, book_labels.name as label, c.book_condition_id as condition_id, bc.code as cond_code, bc.color as cond_color')
    case condition_id 
    when 'na'
      query.where('c.id is null')
    when '1'..'5'
      query.where('c.book_condition_id = ?', condition_id)
    else
      query
    end
  }

  scope :with_status, lambda { |status_id|
    query = self.joins('left join statuses on statuses.id = book_copies.status_id').select('statuses.name as status_name')
    case status_id 
    when 'na'
      query.where('status_id is null')
    when 'all', nil
      query
    else
      query.where(status_id: status_id)
    end
  }

  scope :with_active_loans, lambda {
    joins('left join book_loans l on l.book_copy_id = book_copies.id and l.return_status is null')
    .joins('left join employees e on e.id = l.employee_id')
    .joins('left join students s on s.id = l.student_id')
    .select('e.name as teacher_name, e.id as teacher_id, s.name as student_name, s.id as student_id')
  } 

  def cover_image
    book_edition.try(:small_thumbnail) || 'book-icon.png'
  end

  def book_title
  	book_edition.try(:book_title)
  end

  def create_condition(condition_id, year_id, user_id)
    self.copy_conditions << CopyCondition.new(
        book_condition_id: condition_id,
        academic_year_id: year_id,
        barcode: barcode,
        notes: 'Batch condition update',
        user_id: user_id,
        start_date: Date.today,
        post: 0
      )
    # Note: CopyCondition will synchronize the book_condition_id attribute after creating the new record
  end 

  def latest_copy_condition
    copy_conditions.active.order('academic_year_id DESC,created_at DESC').take
  end

  def latest_condition
    book_condition || 
    copy_conditions.active.order('copy_conditions.academic_year_id DESC,copy_conditions.created_at DESC')
      .take.try(:book_condition)
  end

  def current_start_condition
    copy_conditions.current_year.active.where(post:0).first.try(:book_condition)
  end

  def last_return_condition
    copy_conditions.where(post:1).order('academic_year_id DESC').first.try(:book_condition)
  end

  def start_condition_in_year(academic_year_id)
    copy_conditions.where(academic_year_id:academic_year_id).where(post:0).order('created_at DESC').first.try(:book_condition)
  end

  def return_condition_in_year(academic_year_id)
    copy_conditions.where(post:1).where(academic_year_id:academic_year_id).first.try(:book_condition)
  end

  def active_loan
    BookLoan.where(book_copy_id: self.id, return_status: nil).take
  end

  # Create copy_conditions records based
  def self.update_conditions_from_student_books(academic_year_id, next_academic_year_id)
    category = BookCategory.find_by_code 'TB'
    columns = [:book_copy_id, :barcode, :book_condition_id, :start_date, :end_date, :academic_year_id, :notes, :post, :deleted_flag]
		return_conditions = []
    starting_conditions = []
    GradeSection.all.each do |grade_section|
      grade_level_id = grade_section.grade_level_id
      student_books = StudentBook.where(academic_year_id:academic_year_id)
                        .standard_books(grade_level_id, grade_section.id, academic_year_id, category.id)
                        .where(grade_section: grade_section)
                        .where.not(end_copy_condition_id:nil)
                        .where.not(book_copy_id:nil)
                        .includes([:book_copy])
      if student_books.present?
        student_books.each_with_index do |sb, i|
          return_condition = [sb.book_copy_id, sb.barcode, sb.end_copy_condition_id, sb.return_date, sb.return_date, academic_year_id, sb.notes, 1, false]
          return_conditions << return_condition
          starting_condition = [sb.book_copy_id, sb.barcode, sb.end_copy_condition_id, sb.return_date, nil, next_academic_year_id, sb.notes, 0, false]
          starting_conditions << starting_condition
        end
  			if return_conditions.count > 0
  				CopyCondition.import columns, return_conditions
          CopyCondition.import columns, starting_conditions
  			end
				return_conditions = []
        starting_conditions = []
      end
    end
  end

  def self.copy_with_barcode(barcode)
  	BookCopy.where(barcode:barcode).first
  end

  protected
    def create_initial_condition
      self.copy_conditions << CopyCondition.new(
        book_condition_id: book_condition_id,
        academic_year:AcademicYear.current,
        barcode: barcode,
        notes: 'Initial condition',
        start_date: Date.today,
        post: 0
      )
    end

    def sync_book_label
      self.copy_no = book_label.name      
    end

    def sync_book_edition
      book_loans.update_all book_edition_id: self.book_edition_id
      book_loan_histories.update_all book_edition_id: self.book_edition_id
      book_receipts.update_all book_edition_id: self.book_edition_id
      student_books.update_all book_edition_id: self.book_edition_id
    end
end
