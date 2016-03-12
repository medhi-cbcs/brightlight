class AddPlaceOfBirthToStudent < ActiveRecord::Migration
  def change
    add_column :students, :place_of_birth, :string
  end
end
