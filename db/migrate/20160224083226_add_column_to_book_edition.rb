class AddColumnToBookEdition < ActiveRecord::Migration
  def change
    add_column :book_editions, :price, :decimal
    add_column :book_editions, :currency, :string
    add_column :book_editions, :attachment_index, :integer
    add_column :book_editions, :attachment_name, :string
    add_column :book_editions, :attachment_qty, :integer
    add_column :book_editions, :refno, :string
  end
end
