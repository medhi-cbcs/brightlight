class LineItem < ActiveRecord::Base
  belongs_to :invoice

  validates :description, presence: true
  validates :price, presence: true
end
