class AddSubjectToBookTitles < ActiveRecord::Migration
  def change
    add_column :book_titles, :subject, :string
  end
end
