class BookTitle < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  has_many :book_editions
  accepts_nested_attributes_for :book_editions, allow_destroy: false
end
