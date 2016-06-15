class CreateBookReceipts < ActiveRecord::Migration
  def change
    create_table :book_receipts do |t|
      t.belongs_to :book_copy, index: true#, foreign_key: true
      t.belongs_to :academic_year, index: true#, foreign_key: true
      t.belongs_to :student, index: true#, foreign_key: true
      t.belongs_to :book_edition, index: true#, foreign_key: true
      t.belongs_to :grade_section, index: true#, foreign_key: true
      t.belongs_to :grade_level, index: true#, foreign_key: true
      t.integer :roster_no
      t.string :copy_no
      t.date :issue_date
      t.belongs_to :initial_condition, index: true#, foreign_key: true
      t.belongs_to :return_condition, index: true#, foreign_key: true
      t.string :barcode
      t.string :notes
      t.string :grade_section_code
      t.string :grade_subject_code
      t.belongs_to :course, index: true#, foreign_key: true
      t.belongs_to :course_text, index: true#, foreign_key: true
      t.boolean :active

      t.timestamps null: false
    end
  end
end
