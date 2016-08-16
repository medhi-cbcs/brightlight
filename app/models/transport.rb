class Transport < ActiveRecord::Base
  validates :type, :name, presence: true

  has_many :passengers
  has_many :students, through: :passengers
end
