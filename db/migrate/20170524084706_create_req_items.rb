class CreateReqItems < ActiveRecord::Migration
  def change
    create_table :req_items do |t|
      t.belongs_to :requisition, index: true, foreign_key: true
      t.string :description
      t.float :qty_reqd
      t.string :unit
      t.decimal :est_price
      t.decimal :actual_price
      t.string :notes
      t.date :date_needed
      t.boolean :budgetted
      t.references :budget_item, index: true, foreign_key: true
      t.string :budget_name
      t.boolean :bdgt_approved
      t.string :bdgt_notes
      t.references :bdgt_appvl_by, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
