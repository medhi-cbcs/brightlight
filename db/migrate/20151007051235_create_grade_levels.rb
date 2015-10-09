class CreateGradeLevels < ActiveRecord::Migration
  def change
    create_table :grade_levels do |t|
      t.string :name
      t.integer :order_no
      
      t.timestamps null: false
    end
  end
end
