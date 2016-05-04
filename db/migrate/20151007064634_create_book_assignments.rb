class CreateBookAssignments < ActiveRecord::Migration
  def change
    create_table :book_assignments, id: false do |t|
      t.belongs_to :book_copy, index: true#, foreign_key: true
      t.belongs_to :student, index: true#, foreign_key: true
      t.references :academic_year, index: true#, foreign_key: true
      t.references :course_text, index: true#, foreign_key: true
      t.date :issue_date
      t.date :return_date
      t.integer :initial_condition_id
      t.integer :end_condition_id
      t.references :status, index: true#, foreign_key: true

      t.timestamps null: false
    end
  end
end
