class ChangeColumnNameInBookTitles < ActiveRecord::Migration
  def change
  	rename_column :book_titles, :author, :authors
  end
end
