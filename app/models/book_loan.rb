class BookLoan < ActiveRecord::Base
  belongs_to :book_copy
  belongs_to :book_edition
  belongs_to :book_title
  belongs_to :user
  belongs_to :book_category
  belongs_to :loan_type
  belongs_to :academic_year
end
