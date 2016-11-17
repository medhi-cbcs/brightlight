class BookEdition < ActiveRecord::Base
  validates :title, length: { minimum: 2 }
  validates :isbn10, uniqueness: true, allow_blank: true, allow_nil: true
  validates :isbn13, uniqueness: true, allow_blank: true, allow_nil: true

  belongs_to :book_title
  has_many :book_copies
  accepts_nested_attributes_for :book_copies, allow_destroy: true, reject_if: proc { |attributes| attributes['barcode'].blank? }

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
      num_or_conds = 2
      where(
        terms.map { |term|
          "(LOWER(title) LIKE ? OR LOWER(refno) LIKE ?)"
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
      book_edition.language = book.language unless book.language.blank?
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
        # book_title = self.book_title
        # book_title.image_url = self.small_thumbnail
        # book_title.save
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
        # self.save
      else
        puts "No book info found"
      end
      return self
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

  def has_cover?
    self.small_thumbnail.present?
  end

  def number_of_copies
    book_copies.count
  end

  def isbn
    isbn13 || isbn10 || refno
  end

  def isbn_or_title_for_slug
    "#{isbn || refno}-#{title}".truncate(40)
  end

  def title_for_autocomplete
    "#{title} #{'by '+authors if authors}, ISBN #{isbn13} #{' / ' if isbn13 and isbn10} #{isbn10}"
  end

  def self.find_duplicates(column)
    unless column.class != Symbol
      column_name = column.to_s
      self.find_by_sql "select e.*, be.dupeCount as duplicate_count
                        from book_editions e
                        inner join (
                            SELECT #{column_name}, COUNT(*) AS dupeCount
                            FROM book_editions
                            GROUP BY #{column_name}
                            HAVING COUNT(*) > 1
                        ) be on e.#{column_name} = be.#{column_name}"
    end
  end

  def summary_by_conditions
    summary = BookEdition.find_by_sql ["select b.id, b.code, x.total from
(select c.id, c.code, count(bc.*) total from book_copies bc
left join copy_conditions cc on cc.book_copy_id = bc.id and cc.id = (select id from copy_conditions 
      where book_copy_id = bc.id order by academic_year_id desc, created_at desc limit 1) 
left join book_conditions c on cc.book_condition_id = c.id where bc.book_edition_id = ?
group by c.id, c.code order by c.id) x full outer join book_conditions b on b.id = x.id", id]                      
    summary.map { |x| { :id => x.id, :code => x.code || "N/A", :total => x.total } }
  end

  def summary_by_status
    summary = BookEdition.find_by_sql [
"select ss.id, ss.name, f.total from (select s.id, s.name, count(bc.*) total from book_copies bc 
left join statuses s on s.id = bc.status_id where bc.book_edition_id = ?
group by s.id, s.name order by s.id) f full outer join statuses ss on ss.id = f.id", id]                  
    summary.map { |x| { :id => x.id, :name => x.name || "N/A", :total => x.total } }
  end

  # Strip leading and trailing spaces when assigning values to isbn10 and isbn13
  
  def isbn10=(num)
    write_attribute(:isbn10, num.try(:strip))
  end

  def isbn13=(num)
    write_attribute(:isbn13, num.try(:strip))
  end

  def show_language
    iso = {"en"=>"English", "id"=>"Bahasa Indonesia", "la"=>"Latin", "nl"=>"Dutch", "fr"=>"French", 
           "de"=>"German", "ar"=>"Arabic", "es"=>"Spanish", "zh"=>"Chinese", "it"=>"Italian"}
    iso[language] || language
  end

  scope :with_number_of_copies, lambda { 
    joins('LEFT JOIN book_copies ON book_copies.book_edition_id = book_editions.id')
    .select('book_editions.id,title,subtitle,description,google_book_id,isbndb_id,isbn10,isbn13,refno,currency,price,authors,publisher,published_date,page_count,language,edition_info,tags,subjects,small_thumbnail,thumbnail,book_title_id, count(book_copies.id) as copies')
    .group('book_editions.id,title,subtitle,description,google_book_id,isbndb_id,isbn10,isbn13,refno,currency,price,authors,publisher,published_date,page_count,language,edition_info,tags,subjects,small_thumbnail,thumbnail,book_title_id')
  }
end
