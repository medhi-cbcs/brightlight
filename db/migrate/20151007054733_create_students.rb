class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :admission_no
      t.integer :family_id
      t.string :gender
      t.string :blood_type
      t.string :nationality
      t.string :religion
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :mobile_phone
      t.string :home_phone
      t.string :email
      t.string :photo_uri
      t.string :status
      t.string :status_description
      t.boolean :is_active
      t.boolean :is_deleted
      t.integer :student_no
      t.string :passport_no
      t.string :enrollment_date

      t.timestamps null: false
    end
  end
end
