class Transport < ActiveRecord::Base
  validates :category, :name, presence: true
  validates :name, uniqueness: true

  has_many :passengers
  has_many :students, through: :passengers

  scope :private_cars, lambda { where(category:'PrivateCar') }
  scope :shuttle_cars, lambda { where(category:'Shuttle') }  
end
