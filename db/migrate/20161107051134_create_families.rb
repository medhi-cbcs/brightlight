class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string :family_no, index: true
      t.integer :family_number, index: true
      
      t.timestamps null: false
    end
  end
end
