json.array!(@book_editions) do |book_edition|
  json.extract! book_edition, :id, :google_book_id, :isbndb_id, :title, :subtitle, :authors, :publisher, :published_date, :description, :isbn10, :isbn13, :page_count, :small_thumbnail, :thumbnail, :language, :edition_info, :tags, :subjects, :book_title_id
  json.url book_edition_url(book_edition, format: :json)
end
