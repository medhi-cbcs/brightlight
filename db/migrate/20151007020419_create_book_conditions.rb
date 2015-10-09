class CreateBookConditions < ActiveRecord::Migration
  def change
    create_table :book_conditions, id: false do |t|
      t.string :code
      t.string :description
      t.integer :order_no
      
      t.timestamps null: false
    end
  end
end
