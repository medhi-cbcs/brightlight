class CreateBookFines < ActiveRecord::Migration
  def change
    create_table :book_fines do |t|
      t.belongs_to :book_copy, index: true, foreign_key: true
      t.integer :old_condition_id
      t.integer :new_condition_id
      t.decimal :fine
      t.belongs_to :academic_year, index: true, foreign_key: true
      t.belongs_to :student, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end
  end
end
