class BookCondition < ActiveRecord::Base
	validates :code, presence: true, uniqueness: true
	has_many :book_copies
	has_many :copy_conditions
	slug :code

	COLORS = {"new"=>"blue", "good"=>"green", "fair"=>"orange", "poor"=>"red"}

	scope :sorted, lambda { order(:order_no) }

  def self.fine_percentage_for_condition_change(old, new)
    FineScale.where(old_condition:old).where(new_condition:new).first.try(:percentage) || 0.0
  end
end
