class CopyCondition < ActiveRecord::Base
  belongs_to :book_copy
  belongs_to :book_condition
  belongs_to :academic_year
  belongs_to :user   # user that did the checking

  # validates :academic_year, :start_date, :book_copy_id, :book_condition, :barcode, presence: true

  scope :current_year, lambda { where(academic_year:AcademicYear.current) }

  scope :for_label, lambda { |label|
    joins(:book_copy).where(book_copies: {book_label_id: label})
  }

end
