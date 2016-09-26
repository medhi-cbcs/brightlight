class SmartCard < ActiveRecord::Base
  belongs_to :transport
  validates :code, presence: true
end
