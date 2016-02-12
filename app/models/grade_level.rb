class GradeLevel < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :grade_sections, dependent: :destroy
  has_many :book_labels

  accepts_nested_attributes_for :grade_sections, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :book_labels, allow_destroy: true, reject_if: :all_blank
  
end
