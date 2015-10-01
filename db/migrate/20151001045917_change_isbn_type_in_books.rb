class ChangeIsbnTypeInBooks < ActiveRecord::Migration
  def up
    change_column :books, :isbn10, :string
    change_column :books, :isbn13, :string
  end

  def down
    change_column :books, :isbn10, :integer
    change_column :books, :isbn13, :integer
  end
end
