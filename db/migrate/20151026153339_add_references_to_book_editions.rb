class AddReferencesToBookEditions < ActiveRecord::Migration
  def change
  	add_reference :book_editions, :book_title, index: true, foreign_key: true
  end
end
