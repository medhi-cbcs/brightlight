class CreateBookTitles < ActiveRecord::Migration
  def change
    create_table :book_titles do |t|
      t.string :title
      t.string :author
      t.string :publisher
      t.string :image_url

      t.timestamps null: false
    end
  end
end
