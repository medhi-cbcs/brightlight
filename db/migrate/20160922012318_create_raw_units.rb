class CreateRawUnits < ActiveRecord::Migration
  def change
    create_table :raw_units do |t|
      t.string :name
      t.string :notes

      t.timestamps null: false
    end
  end
end
