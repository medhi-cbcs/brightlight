class CopyCondition < ActiveRecord::Base
  belongs_to :book_copy
  belongs_to :book_condition
  belongs_to :academic_year
  belongs_to :user   # user that did the checking

  validates :academic_year, :start_date, :book_copy_id, :book_condition, :barcode, presence: true

  scope :current_year, lambda { where(academic_year:AcademicYear.current) }
  scope :active, lambda { where(deleted_flag:false) }

  scope :for_label, lambda { |label|
    joins(:book_copy).where(book_copies: {book_label_id: label})
  }

  around_save :update_book_copy_condition

  def update_book_copy_condition
    old_condition_id = book_condition_id

    yield

    if old_condition_id != book_condition_id
      book_copy.book_condition_id = book_condition_id
      book_copy.save
    end
  end

end
