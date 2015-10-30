class BookCopy < ActiveRecord::Base
  belongs_to :book_edition
  belongs_to :book_condition
  belongs_to :status
  validates :book_edition, presence: true
  
end
