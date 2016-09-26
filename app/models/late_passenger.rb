class LatePassenger < ActiveRecord::Base
  belongs_to :carpool
  belongs_to :transport
  belongs_to :student
  belongs_to :grade_section

  scope :active, lambda { where(active: true) }
end
