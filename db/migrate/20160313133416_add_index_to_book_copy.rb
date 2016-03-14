class AddIndexToBookCopy < ActiveRecord::Migration
  def change
    add_index  :book_copies, :barcode, :unique => true
  end
end
