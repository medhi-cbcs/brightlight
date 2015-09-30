json.array!(@books) do |book|
  json.extract! book, :id, :google_book_id, :isbndb_id, :title, :subtitle, :authors, :publisher, :published_date, :description, :isbn10, :isbn13, :page_count, :small_thumbnail, :thumbnail, :language, :edition_info, :tags, :subjects
  json.url book_url(book, format: :json)
end
