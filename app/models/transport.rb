class Transport < ActiveRecord::Base
  validates :category, :name, presence: true
  validates :name, uniqueness: true
  
  has_many :smart_cards
  has_many :passengers
  has_many :students, through: :passengers

  scope :private_cars, lambda { where(category:'private') }
  scope :shuttle_cars, lambda { where(category:'shuttle') }  
end
