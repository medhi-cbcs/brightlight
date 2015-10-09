class RenameBooksToBookEditions < ActiveRecord::Migration
  def change
  	rename_table :books, :book_editions
  end
end
