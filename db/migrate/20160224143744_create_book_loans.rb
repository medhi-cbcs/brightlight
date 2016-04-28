class CreateBookLoans < ActiveRecord::Migration
  def change
    create_table :book_loans do |t|
      t.belongs_to :book_copy, index: true, foreign_key: true
      t.belongs_to :book_edition, index: true, foreign_key: true
      t.belongs_to :book_title, index: true, foreign_key: true
      t.belongs_to :person, index: true, foreign_key: true
      t.belongs_to :book_category, index: true, foreign_key: true
      t.belongs_to :loan_type, index: true, foreign_key: true
      t.date :out_date
      t.date :due_date
      t.belongs_to :academic_year, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
