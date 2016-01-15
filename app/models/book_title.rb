class BookTitle < ActiveRecord::Base
  validates :title, presence: true
  has_many :course_texts
  has_many :courses, through: :course_texts
  has_many :book_editions
  accepts_nested_attributes_for :book_editions, reject_if: :all_blank, allow_destroy: false

  scope :search_query, lambda { |query|
    return nil  if query.blank?

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
  }

  def has_cover?
    self.book_editions.reduce(true) { |a, edition| a && edition.has_cover? }
  end
  
end
