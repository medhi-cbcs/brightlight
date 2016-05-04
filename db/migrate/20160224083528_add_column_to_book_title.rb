class AddColumnToBookTitle < ActiveRecord::Migration
  def change
    add_column :book_titles, :bkudid, :integer
    add_reference :book_titles, :subject, index: true#, foreign_key: true
  end
end
