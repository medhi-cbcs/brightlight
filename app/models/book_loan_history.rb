class BookLoanHistory < ActiveRecord::Base
  belongs_to :book_title
  belongs_to :book_edition
  belongs_to :book_copy
  belongs_to :user
  belongs_to :condition_out
  belongs_to :condition_in
  belongs_to :academic_year
  belongs_to :update_by, class_name: 'User'
end
