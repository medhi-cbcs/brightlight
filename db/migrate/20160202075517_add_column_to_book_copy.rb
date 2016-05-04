class AddColumnToBookCopy < ActiveRecord::Migration
  def change
    add_reference :book_copies, :book_label, index: true#, foreign_key: true
  end
end
