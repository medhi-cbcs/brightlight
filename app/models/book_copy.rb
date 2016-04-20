class BookCopy < ActiveRecord::Base
  belongs_to :book_edition
  belongs_to :book_condition
  belongs_to :status
  belongs_to :book_label
  # validates :book_edition, :book_condition, :copy_no, presence: true
  validates :barcode, presence: true, uniqueness: true
  has_many :copy_conditions
  has_many :book_loans

  after_create :create_initial_condition

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

  def cover_image
    book_edition.try(:small_thumbnail) || 'book-icon.png'
  end

  def book_title
  	book_edition.try(:book_title)
  end

  def self.copy_with_barcode(barcode)
  	BookCopy.where(barcode:barcode).first
  end

  def latest_condition
    copy_conditions.active.order('academic_year_id DESC,created_at DESC').first.try(:book_condition)
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

  protected
    def create_initial_condition
      self.copy_conditions << CopyCondition.new(
        book_condition_id: book_condition_id,
        academic_year:AcademicYear.current,
        barcode: barcode,
        notes: 'Initial condition',
        start_date: Date.today
      )
    end
end
