class BookCopy < ActiveRecord::Base
  belongs_to :book_edition
  belongs_to :book_condition
  belongs_to :status
  belongs_to :book_label
  validates :book_edition, presence: true
  validates :barcode, presence: true, uniqueness: true
  has_many :copy_conditions

  def book_title
  	book_edition.book_title
  end

  def self.copy_with_barcode(barcode)
  	BookCopy.where(barcode:barcode).first
  end

end
