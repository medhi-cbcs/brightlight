class BookEdition < ActiveRecord::Base
  validates :title, length: { minimum: 2 }
  validates :isbn10, uniqueness: true, allow_blank: true, allow_nil: true
  validates :isbn13, uniqueness: true, allow_blank: true, allow_nil: true

  slug :isbn_or_title_for_slug

  belongs_to :book_title
  has_many :book_copies
  accepts_nested_attributes_for :book_copies, allow_destroy: true, reject_if: :all_blank

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query
    ]
  )

  scope :search_query, lambda { |query|
    return nil  if query.blank?

    # ISBN10_REGEX = /^(?:\d[\ |-]?){9}[\d|X]$/i
    # ISBN13_REGEX = /^(?:\d[\ |-]?){13}$/i

    # check if search query looks like an isbn number
    if /^(?:\d[\ |-]?){9}[\d|X]$/i =~ query.to_s
      where(isbn10:query.delete('- '))

    elsif /^(?:\d[\ |-]?){13}$/i =~ query.to_s
      where(isbn13:query.delete('- '))

    else
      # condition query, parse into individual keywords
      terms = query.downcase.split(/\s+/)

      # replace "*" with "%" for wildcard searches,
      # append '%', remove duplicate '%'s
      terms = terms.map { |e|
        ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
      }
      # configure number of OR conditions for provision
      # of interpolation arguments. Adjust this if you
      # change the number of OR conditions.
      num_or_conds = 1
      where(
        terms.map { |term|
          "(LOWER(title) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
      )
    end
  }

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("book_editions.created_at #{ direction }")
    when /^title_/
      order("LOWER(book_editions.title) #{ direction }")
    when /^authors_/
      order("LOWER(book_editions.authors) #{ direction }")
    when /^publisher_/
      order("LOWER(book_editions.publisher) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['Title (a-z)', 'title_asc'],
      ['Authors', 'authors_asc'],
      ['Publisher', 'publisher_asc']
    ]
  end

  def self.searchGoogleAPI(isbn)
    results = GoogleBooks::API.search("isbn:#{isbn}",{api_key:ENV["GOOGLE_API_KEY"]})
    unless results.total_results == 0
      book_edition = BookEdition.new
      book = results.first
      book_edition.title = book.title
      book_edition.authors = book.authors.join(', ')
      book_edition.publisher = book.publisher
      book_edition.isbn13 = book.isbn || (isbn if isbn.length == 13)
      book_edition.isbn10 = book.isbn_10 || (isbn if isbn.length == 10)
      book_edition.page_count = book.page_count
      book_edition.small_thumbnail = book.covers[:small]
      book_edition.thumbnail = book.covers[:thumbnail]
      book_edition.published_date = book.published_date
      book_edition.language = book.language
      book_edition.google_book_id = book.id
      return book_edition
    else
      return nil
    end
  end

  def self.googleAPI(query)
    results = GoogleBooks::API.search(query)
  end

  def self.searchISBNDB(isbn)
    result = ISBNDBClient::API.find(isbn)
    unless result.nil?
      book_edition = BookEdition.new
      book = result
      book_edition.title = book.title
      book_edition.description = book.description
      book_edition.authors = book.authors.map {|data| data['name']}.join(', ')
      book_edition.publisher = book.publisher
      book_edition.isbn13 = book.isbn
      book_edition.isbn10 = book.isbn10
      book_edition.page_count = book.page_count
      book_edition.published_date = book.published_date
      book_edition.edition_info = book.edition_info
      book_edition.language = book.language
      book_edition.isbndb_id = book.book_id
      return book_edition
    else
      raise ISBNDBClient::API::Error
    end
  end

  def update_metadata
    unless isbn.blank?
      results = GoogleBooks::API.search("isbn:#{isbn13}") if isbn13.present?
      if results.total_results == 0 and isbn10.present?
        results = GoogleBooks::API.search("isbn:#{isbn10}")
      end
      unless results.total_results == 0
        book = results.first
        self.google_book_id = book.id
        self.authors = book.authors.join(', ') unless book.authors.blank?
        self.small_thumbnail = book.covers[:small]
        self.thumbnail = book.covers[:thumbnail]
        book_title = self.book_title
        book_title.image_url = self.small_thumbnail
        book_title.save
      else
        book = ISBNDBClient::API.find(isbn)
        if book.present?
          self.isbndb_id = book.book_id
          self.authors = book.authors.map {|data| data['name']}.join(', ') unless book.authors.blank?
          self.description = book.description unless book.description.blank?
          self.edition_info = book.edition_info unless book.edition_info.blank?
        end
      end
      if book.present?
        self.title = book.title
        self.publisher = book.publisher unless book.publisher.blank?
        self.isbn13 ||= book.isbn
        self.isbn10 ||= book.respond_to?(:isbn_10) ? book.isbn_10 : book.isbn10
        self.page_count = book.page_count unless book.page_count.blank?
        self.published_date = book.published_date unless book.published_date.blank?
        self.language = book.language unless book.language.blank?
        self.save
      else
        puts "No book info found"
      end
    else
      raise "Invalid ISBN"
    end
  end

  def create_book_title
    book_title = BookTitle.create(
      title: self.title,
      publisher: self.publisher,
      authors: self.authors,
      image_url: self.small_thumbnail
    )
    self.book_title_id = book_title.id
    self.save
  end

  def create_book_copies(num=1)
    condition_ids = BookCondition.all.map {|bc| bc.id}
    status = Status.where(name:'On loan').first
    num.times do
      self.book_copies << BookCopy.new(
        book_condition_id: condition_ids[rand(condition_ids.count)],
        status_id: status.id,
        barcode: rand(9876543210)
      )
    end
  end

  def has_cover?
    self.small_thumbnail.present?
  end

  def number_of_copies
    book_copies.length
  end

  def isbn
    isbn13 || isbn10
  end

  def isbn_or_title_for_slug
    "#{isbn || refno}-#{title}".truncate(40)
  end
end
