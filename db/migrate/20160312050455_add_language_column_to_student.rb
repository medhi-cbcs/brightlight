class AddLanguageColumnToStudent < ActiveRecord::Migration
  def up
    add_column :students, :language, :string
    change_column :students, :student_no, :string
  end

  def down
    remove_column :students, :language, :string
    change_column :students, :student_no, :integer
  end
end
