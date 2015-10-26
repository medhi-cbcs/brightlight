class BookTitle < ActiveRecord::Base
	has_many :book_editions
	accepts_nested_attributes_for :book_editions, allow_destroy: false
end
