class RawFood < ActiveRecord::Base
    validates :name, presence: true
    belongs_to :raw_unit
    
    def to_s
		name 
	end
end
