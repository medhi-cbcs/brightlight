class CreateRawFoods < ActiveRecord::Migration
  def change
    create_table :raw_foods do |t|
      t.string :name
      t.string :brand
      t.string :kind
      t.float :min_stock
      t.integer :raw_unit_id

      t.timestamps null: false
    end
  end
end
