class BookCondition < ActiveRecord::Base
	validates :code, presence: true, uniqueness: true
	has_many :book_copies

	COLORS = {"new"=>"blue", "good"=>"green", "fair"=>"orange", "poor"=>"red"}

  def self.fine_percentage_for_condition_change(old, new)
    FineScale.where(old_condition:old).where(new_condition:new).first.try(:percentage) || 0.0
  end
end
