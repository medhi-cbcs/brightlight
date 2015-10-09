class BookCopy < ActiveRecord::Base
  belongs_to :book
  belongs_to :book_condition
  belongs_to :status
end
