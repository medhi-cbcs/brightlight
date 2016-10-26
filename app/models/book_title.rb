class BookTitle < ActiveRecord::Base
  validates :title, presence: true
  has_many :course_texts
  has_many :courses, through: :course_texts
  has_many :book_editions
  has_many :standard_books
  belongs_to :subject

  accepts_nested_attributes_for :book_editions, reject_if: :all_blank, allow_destroy: true

  scope :search_query, lambda { |query|
    return nil  if query.blank?

    query = query.strip     # trim leading and ending spaces from query

    # check if search query looks like Barcode
    # Barcode consist of 3 letters, dash, an a series of number (INV-0001234)
    if /^(?:[A-Z]{3}-\d+)$/i =~ query   # checking if it's a barcode
      joins(book_editions: :book_copies)
      .where("book_copies.barcode = ? OR  LOWER(book_editions.refno) LIKE ?", query.upcase, "%#{query.downcase}%")

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

      # find the search terms in book_titles.title, OR book_editions.title OR book_editions.refno
      joins(:book_editions).
      where(
        terms.map { |term|
          "(LOWER(book_titles.title) LIKE ?)"
        }.join(' AND ') + " OR " +
        terms.map { |term|
          "(LOWER(book_editions.title) LIKE ?)"
        }.join(' AND ') +
          " OR book_editions.isbn10 = ?" +
          " OR book_editions.isbn13 = ?" +
          " OR LOWER(book_editions.refno) LIKE ?",
        *terms.map { |e| [e] * num_or_conds }.flatten,
        *terms.map { |e| [e] * num_or_conds }.flatten,
        query.delete(' -'), query.delete(' -'),
        "%#{query.downcase}%"
      )
    end
  }

  def has_cover?
    self.book_editions.reduce(true) { |a, edition| a && edition.has_cover? }
  end

  def number_of_copies
    self.book_editions.reduce(0) {|t, edition| t + edition.number_of_copies }
  end

end
