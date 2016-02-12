class Status < ActiveRecord::Base
  validates :name, presence: true
  has_many :book_copies
end
