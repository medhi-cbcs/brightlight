class AddDisposedToBookCopy < ActiveRecord::Migration
  def change
    add_column :book_copies, :disposed, :boolean
    add_column :book_copies, :disposed_at, :date
  end
end
