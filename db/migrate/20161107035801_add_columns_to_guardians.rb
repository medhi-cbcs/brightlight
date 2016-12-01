class AddColumnsToGuardians < ActiveRecord::Migration
  def change
    add_column :guardians, :email, :string
    add_column :guardians, :email2, :string
  end
end
