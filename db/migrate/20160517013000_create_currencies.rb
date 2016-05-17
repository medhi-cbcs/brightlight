class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :foreign
      t.string :base
      t.float :rate
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
