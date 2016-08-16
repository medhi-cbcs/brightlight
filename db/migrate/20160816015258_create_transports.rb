class CreateTransports < ActiveRecord::Migration
  def change
    create_table :transports do |t|
      t.string :type
      t.string :name
      t.string :status
      t.boolean :active
      t.string :notes
      t.integer :contact_id
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.string :family_no, index: true

      t.timestamps null: false
    end
  end
end
