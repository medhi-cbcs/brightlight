class BookReceipt < ActiveRecord::Base
  belongs_to :book_copy
  belongs_to :academic_year
  belongs_to :student
  belongs_to :book_edition
  belongs_to :grade_section
  belongs_to :grade_level
  belongs_to :initial_condition, class_name: "BookCondition"
  belongs_to :return_condition, class_name: "BookCondition"
  belongs_to :course
  belongs_to :course_text

  validates :book_copy, presence:true
  validates :academic_year, presence:true
  validates :grade_section, presence:true
  validates :grade_level, presence:true
  validates :roster_no, presence:true
  validates :initial_condition, presence:true

  def self.initialize_with_student_books(previous_year_id, new_year_id)
    columns = [:book_copy_id, :barcode, :book_edition_id, :academic_year_id, :initial_condition_id,
               :grade_section_id, :grade_level_id, :roster_no, :course_id]
    values = []
    textbook_category = BookCategory.find_by_code 'TB'
    GradeSection.all.each do |grade_section|
      grade_level_id = grade_section.grade_level_id
      student_books = StudentBook.where(grade_section:grade_section)
                        .where(academic_year_id:previous_year_id)
                        .standard_books(grade_section.grade_level.id, grade_section.id, new_year_id, textbook_category.id)
      student_books.each do |sb|
        data = [sb.book_copy_id, sb.barcode, sb.book_edition_id, new_year_id, sb.initial_condition_id, 
                sb.grade_section_id, sb.grade_level_id, sb.roster_no.to_i, sb.course_id]
        values << data
      end
      BookReceipt.import columns, values
      values = []
    end
  end

end
