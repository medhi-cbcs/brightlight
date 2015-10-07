class CreateGuardians < ActiveRecord::Migration
  def change
    create_table :guardians do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :mobile_phone
      t.string :home_phone
      t.string :office_phone
      t.string :other_phone
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.integer :family_no

      t.timestamps null: false
    end
  end
end
