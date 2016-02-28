class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :full_name
      t.string :first_name
      t.string :last_name
      t.string :nick_name
      t.date :date_of_birth
      t.string :place_of_birth
      t.string :gender
      t.string :passport_no
      t.string :blood_type
      t.string :mobile_phone
      t.string :home_phone
      t.string :other_phone
      t.string :email
      t.string :other_email
      t.string :bbm_pin
      t.string :sm_twitter
      t.string :sm_facebook
      t.string :sm_line
      t.string :sm_path
      t.string :sm_instagram
      t.string :sm_google_plus
      t.string :sm_linked_in
      t.string :gravatar
      t.string :photo_uri
      t.string :nationality
      t.string :religion
      t.string :address_line1
      t.string :address_line2
      t.string :kecamatan
      t.string :kabupaten
      t.string :city
      t.string :postal_code
      t.string :state
      t.string :country

      t.timestamps null: false
    end
  end
end
