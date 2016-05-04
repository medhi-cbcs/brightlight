class CreateBookLoanHistories < ActiveRecord::Migration
  def change
    create_table :book_loan_histories do |t|
      t.belongs_to :book_title, index: true#, foreign_key: true
      t.belongs_to :book_edition, index: true#, foreign_key: true
      t.belongs_to :book_copy, index: true#, foreign_key: true
      t.belongs_to :user, index: true#, foreign_key: true
      t.date :out_date
      t.date :due_date
      t.date :in_date
      t.belongs_to :condition_out, index: true#, foreign_key: true
      t.belongs_to :condition_in, index: true#, foreign_key: true
      t.float :fine_assessed
      t.float :fine_paid
      t.float :fine_waived
      t.string :remarks
      t.belongs_to :academic_year, index: true#, foreign_key: true
      t.belongs_to :update_by, index: true#, foreign_key: true

      t.timestamps null: false
    end
  end
end
