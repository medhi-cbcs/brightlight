class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :invoice_number
      t.date :invoice_date
      t.string :bill_to
      t.references :student, index: true, foreign_key: true
      t.string :grade_section
      t.string :roster_no
      t.string :total_amount
      t.string :received_by
      t.string :paid_by
      t.string :paid_amount
      t.string :currency
      t.string :notes
      t.boolean :paid
      t.string :statuses
      t.string :tag
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
