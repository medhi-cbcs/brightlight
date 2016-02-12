class CreateStudentBooks < ActiveRecord::Migration
  def change
    create_table :student_books do |t|
      t.belongs_to :student, index: true, foreign_key: true
      t.belongs_to :book_copy, index: true, foreign_key: true
      t.references :academic_year, index: true, foreign_key: true
      t.references :course_text, index: true, foreign_key: true
      t.string :copy_no
      t.references :grade_section, index: true, foreign_key: true
      t.references :grade_level, index: true, foreign_key: true
      t.references :course_text, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.date :issue_date
      t.date :return_date
      t.integer :initial_copy_condition_id
      t.integer :end_copy_condition_id

      t.timestamps null: false
    end
  end
end
