class AddBookNumberToBookLabel < ActiveRecord::Migration
  def change
    add_column :book_labels, :book_no, :integer
  end
end
