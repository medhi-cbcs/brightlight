class Invoice < ActiveRecord::Base
  belongs_to :student
  belongs_to :user
  has_many   :line_items, dependent: :destroy

  validates :total_amount, presence: true
  validates :bill_to, presence: true
  validates :student_id, presence: true
  validates :tag, uniqueness: true

end
