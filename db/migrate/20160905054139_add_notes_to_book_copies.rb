class AddNotesToBookCopies < ActiveRecord::Migration
  def change
    add_column :book_copies, :notes, :string
  end
end
