class CreateCarpools < ActiveRecord::Migration
  def change
    create_table :carpools do |t|
      t.string :category
      t.references :transport, index: true, foreign_key: true
      t.string :barcode, index: true
      t.string :transport_name
      t.string :period
      t.float :sort_order, index: true
      t.boolean :active
      t.string :status
      t.datetime :arrival
      t.datetime :departure
      t.string :notes

      t.timestamps null: false
    end
  end
end
