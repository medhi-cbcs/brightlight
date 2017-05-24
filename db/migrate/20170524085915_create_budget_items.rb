class CreateBudgetItems < ActiveRecord::Migration
  def change
    create_table :budget_items do |t|
      t.belongs_to :budget, index: true, foreign_key: true
      t.string :description
      t.string :notes
      t.decimal :amount
      t.string :currency
      t.decimal :used_amount
      t.boolean :completed
      t.string :appvl_notes
      t.boolean :approved
      t.references :approver, index: true, foreign_key: true
      t.date :date_approved

      t.timestamps null: false
    end
  end
end
