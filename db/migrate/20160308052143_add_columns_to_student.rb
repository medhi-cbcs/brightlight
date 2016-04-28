class AddColumnsToStudent < ActiveRecord::Migration
  def change
    add_column :students, :nick_name, :string
    add_column :students, :family_no, :string
    add_column :students, :home_to_school_1, :float
    add_column :students, :home_to_school_2, :float
    add_column :students, :siblings, :integer
    add_column :students, :adopted_siblings, :integer
    add_column :students, :step_siblings, :integer
    add_column :students, :birth_order, :integer
    add_column :students, :transport, :string
    add_column :students, :parental_status, :string
    add_column :students, :parents_status, :string
    add_column :students, :address_rt, :string
    add_column :students, :address_rw, :string
    add_column :students, :address_kelurahan, :string
    add_column :students, :address_kecamatan, :string
    add_column :students, :living_with, :string
  end
end
