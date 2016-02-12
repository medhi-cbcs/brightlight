class CreateCopyConditions < ActiveRecord::Migration
  def change
    create_table :copy_conditions do |t|
      t.belongs_to :book_copy, index: true, foreign_key: true
      t.references :book_condition, index: true, foreign_key: true
      t.references :academic_year, index: true, foreign_key: true
      t.string :barcode
      t.string :notes
      t.references :user, index: true, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
