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
    copy_conditions.active.order('created_at DESC').first.try(:book_condition)
  end

  protected
    def create_initial_condition
      self.copy_conditions << CopyCondition.new(
        book_condition_id: book_condition_id,
        academic_year_id: AcademicYear.current_id,
        barcode: barcode,
        notes: 'Initial condition',
        start_date: Date.today
      )
    end
end
