class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.belongs_to :purchase_order, index: true, foreign_key: true
      t.integer :no
      t.date :order_date
      t.string :supplier
      t.integer :supplier_id
      t.references :req_line, index: true, foreign_key: true
      t.decimal :invoice_amt
      t.decimal :dp_amount
      t.date :dp_date
      t.string :notes

      t.timestamps null: false
    end
  end
end
