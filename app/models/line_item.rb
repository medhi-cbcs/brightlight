class LineItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :book_fine
  
  validates :description, presence: true
  validates :price, presence: true
end
