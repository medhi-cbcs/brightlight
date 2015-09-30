class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :google_book_id
      t.string :isbndb_id
      t.string :title
      t.string :subtitle
      t.string :authors
      t.string :publisher
      t.date :published_date
      t.string :description
      t.integer :isbn10
      t.integer :isbn13
      t.integer :page_count
      t.string :small_thumbnail
      t.string :thumbnail
      t.string :language
      t.string :edition_info
      t.string :tags
      t.string :subjects

      t.timestamps null: false
    end
  end
end
