class CreateBookGrades < ActiveRecord::Migration
  def change
    create_table :book_grades do |t|
      t.belongs_to :book, index: true, foreign_key: true
      t.belongs_to :book_condition, index: true, foreign_key: true
      t.references :academic_year, index: true, foreign_key: true
      t.string :notes
      t.integer :graded_by
      t.string :notes

      t.timestamps null: false
    end
  end
end
