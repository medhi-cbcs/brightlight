class CreateStandardBooks < ActiveRecord::Migration
  def change
    create_table :standard_books do |t|
      t.belongs_to :book_title, index: true#, foreign_key: true
      t.belongs_to :book_edition, index: true#, foreign_key: true
      t.belongs_to :book_category, index: true#, foreign_key: true
      t.belongs_to :grade_level, index: true#, foreign_key: true
      t.belongs_to :grade_section, index: true#, foreign_key: true
      t.belongs_to :academic_year, index: true#, foreign_key: true
      t.string :isbn
      t.string :refno
      t.integer :quantity
      t.string :grade_subject_code
      t.string :grade_name
      t.string :group
      t.string :category
      t.string :bkudid
      t.string :notes
      t.timestamps null: false
    end
  end
end
