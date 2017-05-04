class StandardBook < ActiveRecord::Base
  belongs_to :book_title
  belongs_to :book_edition
  belongs_to :book_category
  belongs_to :grade_level
  belongs_to :grade_section
  belongs_to :academic_year

  validates :book_edition, uniqueness: {scope: [:grade_level, :track, :book_category, :academic_year]}
  validates :book_edition, presence: true
  validates :grade_level, presence: true
  validates :academic_year, presence: true 
  validates :book_category, presence: true

  scope :current_year, lambda { where(academic_year:AcademicYear.current) }

  def self.initialize_from_previous_year (prev_academic_year_id, new_academic_year_id)
    columns = [:book_title_id, :book_edition_id, :book_category_id, :grade_level_id, :grade_section_id,
                :academic_year_id, :isbn, :refno, :quantity, :grade_subject_code, :grade_name,
                :group, :category, :bkudid]
    values = []
    StandardBook.where(academic_year_id: prev_academic_year_id).each do |sb|
      data = [sb.book_title_id, sb.book_edition_id, sb.book_category_id, sb.grade_level_id, sb.grade_section_id,
                new_academic_year_id, sb.isbn, sb.refno, sb.quantity, sb.grade_subject_code, sb.grade_name,
                sb.group, sb.category, sb.bkudid]
      values << data
    end
    StandardBook.import columns, values
  end
end
