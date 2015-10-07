class CreateBookConditions < ActiveRecord::Migration
  def change
    create_table :book_conditions do |t|
      t.string :code
      t.string :description

      t.timestamps null: false
    end
  end
end
