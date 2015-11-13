class BookLabel < ActiveRecord::Base
  belongs_to :grade_section
  belongs_to :student

  validates :name, presence: true, uniqueness: true
end
