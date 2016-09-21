class CreateSmartCards < ActiveRecord::Migration
  def change
    create_table :smart_cards do |t|
      t.string :code
      t.belongs_to :transport, index: true, foreign_key: true
      t.string :detail
      t.string :ref

      t.timestamps null: false
    end
  end
end
