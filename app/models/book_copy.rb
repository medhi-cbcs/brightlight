class BookCopy < ActiveRecord::Base
  belongs_to :book_edition
  belongs_to :book_condition
  belongs_to :status
  validates :book_edition, presence: true
  validates :barcode, presence: true, uniqueness: true
  
  def book_title
  	book_edition.book_title
  end

  
end
