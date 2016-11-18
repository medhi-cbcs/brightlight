class CreateLoanChecks < ActiveRecord::Migration
  def change
    create_table :loan_checks do |t|
      t.belongs_to :book_loan, index: true, foreign_key: true
      t.belongs_to :book_copy, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :loaned_to
      t.integer :scanned_for
      t.references :academic_year, index: true, foreign_key: true
      t.boolean :emp_flag
      t.boolean :matched
      t.string :notes

      t.timestamps null: false
    end
  end
end
