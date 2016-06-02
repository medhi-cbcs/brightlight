class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :description
      t.string :quantity
      t.string :price
      t.string :ext1
      t.string :ext2
      t.string :ext3
      t.string :notes
      t.string :status
      t.belongs_to :invoice, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
