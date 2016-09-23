class CreateFoodLists < ActiveRecord::Migration
  def change
    create_table :food_lists do |t|
      t.string :name
      t.string :notes
      t.string :picture_url

      t.timestamps null: false
    end
  end
end
