class Transport < ActiveRecord::Base
  validates :category, :name, presence: true
  validates :name, uniqueness: true
  
  has_many :smart_cards
  has_many :passengers
  has_many :students, through: :passengers

  scope :private_cars, lambda { where(category:'private') }
  scope :shuttle_cars, lambda { where(category:'shuttle') }  

  accepts_nested_attributes_for :smart_cards, allow_destroy: true, reject_if: proc { |attributes| attributes['code'].blank? }
end
