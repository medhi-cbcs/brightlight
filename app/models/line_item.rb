class LineItem < ActiveRecord::Base
  belongs_to :invoice

  validates :desription, presence: true
  validates :price, presence: true
end
