class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :date_of_birth
      t.string :place_of_birth
      t.date :joining_date
      t.string :job_title
      t.string :employee_number
      t.string :marital_status
      t.integer :experience_year
      t.integer :experience_month
      t.string :employment_status
      t.integer :children_count
      t.string :home_address_line1
      t.string :home_address_line2
      t.string :home_city
      t.string :home_state
      t.string :home_country
      t.string :home_postal_code
      t.string :mobile_phone
      t.string :home_phone
      t.string :office_phone
      t.string :other_phone
      t.string :emergency_contact_number
      t.string :emergency_contact_name
      t.string :email
      t.string :photo_uri
      t.string :education_degree
      t.string :education_graduation_date
      t.string :education_school
      t.string :education_degree2
      t.string :education_graduation_date2
      t.string :education_school2
      t.integer :reporting_supervisor_id
      t.integer :department_id
      t.string :nationality
      t.string :blood_type

      t.timestamps null: false
    end
  end
end
