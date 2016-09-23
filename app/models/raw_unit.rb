class RawUnit < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
    has_many :raw_foods
    
    def to_s
		name 
	end
end
