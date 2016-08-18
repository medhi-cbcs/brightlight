class AddIndexToStudent < ActiveRecord::Migration
  def change
    add_index :students, :family_no
  end
end
