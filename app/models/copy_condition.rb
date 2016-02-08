class CopyCondition < ActiveRecord::Base
  belongs_to :book_copy
  belongs_to :book_condition
  belongs_to :academic_year
  belongs_to :user   # user that did the checking

  default_scope { order('created_at DESC') }

  scope :current_year, lambda { where(academic_year:AcademicYear.current) }
  
  scope :for_label_id, lambda { |id|
    joins(:book_copy).where(book_copies: {book_label_id: id})
  }

end
