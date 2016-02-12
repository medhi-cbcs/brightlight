class CreateBookCopies < ActiveRecord::Migration
  def change
    create_table :book_copies do |t|
      t.references :book_edition, index: true, foreign_key: true
      t.references :book_condition, index: true, foreign_key: true
      t.references :status, index: true, foreign_key: true
      t.string :barcode
      t.string :copy_no

      t.timestamps null: false
    end
  end
end
