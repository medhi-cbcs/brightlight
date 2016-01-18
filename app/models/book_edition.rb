class BookEdition < ActiveRecord::Base
  validates :title, length: { minimum: 2 }
  validates :isbn10, uniqueness: true, allow_blank: true, allow_nil: true
  validates :isbn13, uniqueness: true, allow_blank: true, allow_nil: true

  belongs_to :book_title
  has_many :book_copies
  accepts_nested_attributes_for :book_copies, allow_destroy: false
  
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

end
