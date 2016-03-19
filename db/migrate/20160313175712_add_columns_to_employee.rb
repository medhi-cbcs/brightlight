class AddColumnsToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :nick_name, :string
    add_column :employees, :is_active, :boolean
    add_column :employees, :family_no, :integer
  end
end
