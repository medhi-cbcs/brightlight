class AddColumnToStandardBooks < ActiveRecord::Migration
  def change
    add_column :standard_books, :track, :string
  end
end
