class Subject < ActiveRecord::Base
    validates :name, presence: true
    validates_uniqueness_of :name, message: "Subject Name Already Exist"
    has_many :book_titles
    before_destroy :check_for_books
    
    
private
  def check_for_books
    if book_titles.count > 0
      return false
    end
  end
    
end
