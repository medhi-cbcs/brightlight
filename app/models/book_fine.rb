class BookFine < ActiveRecord::Base
  belongs_to :book_copy
  belongs_to :academic_year
  belongs_to :student
  belongs_to :old_condition, class_name: 'BookCondition'
  belongs_to :new_condition, class_name: 'BookCondition'

  validates :book_copy, uniqueness: {scope: [:student_id, :academic_year_id]}

  # collect_current will read student_books table and look for book that are applicable for book fine
  # for the current academic year and then save them in book_fines table
  def self.collect_current
    BookFine.create(StudentBook.current_year.fine_applies.map do |b|
      pct = FineScale.fine_percentage_for_condition_change(b.initial_copy_condition_id,b.end_copy_condition_id)
      price = b.try(:book_copy).try(:book_edition).try(:price).try(:to_f) || 0.0
      {
        book_copy_id:     b.book_copy_id,
        old_condition_id: b.initial_copy_condition_id,
        new_condition_id: b.end_copy_condition_id,
        academic_year_id: b.academic_year_id,
        student_id:       b.student_id,
        percentage:       pct,
        fine:             pct * price,
        currency:         b.book_copy.try(:book_edition).try(:currency)
      }
    end)
  end
end
