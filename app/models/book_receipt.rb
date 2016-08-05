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
  validates :book_copy, uniqueness: {scope: [:academic_year_id]}
  # validates :initial_condition, presence:true

  after_save :update_book_copy_condition

  def self.initialize_book_receipts(previous_year_id, new_year_id)
    GradeSection.all.each do |grade_section|
      self.initialize_with_student_books_for_grade(previous_year_id, new_year_id, grade_section.id)
    end
  end

  def self.initialize_with_student_books_for_grade(previous_year_id, new_year_id, grade_section_id)
    columns = [:book_copy_id, :barcode, :book_edition_id, :academic_year_id, :initial_condition_id,
               :grade_section_id, :grade_level_id, :roster_no, :course_id]
    textbook_category = BookCategory.find_by_code 'TB'
    values = []
    grade_section = GradeSection.find grade_section_id
    grade_level_id = grade_section.grade_level_id
    # Books with 'Poor' condition will not be included
    poor_condition = BookCondition.find_by_slug 'poor'
    student_books = StudentBook.where(grade_section:grade_section,academic_year_id:previous_year_id)
                      .standard_books(grade_section.grade_level.id, grade_section.id, new_year_id, textbook_category.id)
                      .joins(:book_copy).where('book_copies.book_condition_id != ?', poor_condition.id)

    student_books.each_with_index do |sb,i|
      data = [sb.book_copy_id, sb.barcode, sb.book_edition_id, new_year_id, sb.book_copy.book_condition_id,
              sb.grade_section_id, sb.grade_level_id, sb.roster_no.to_i, sb.course_id]
      values << data
      if i % 120 == 0
        BookReceipt.import columns, values
        values = []
      end
    end

    unless values.empty?
      BookReceipt.import columns, values
    end
  end

  def self.initialize_with_student_books(grade_section:, roster_no:, previous_year:, new_year:)
    textbook_category = BookCategory.find_by_code 'TB'
    grade_level_id = grade_section.grade_level_id
    # Books with 'Poor' condition will not be included
    poor_condition = BookCondition.find_by_slug 'poor'
    student_books = StudentBook.where(grade_section:grade_section,academic_year_id:previous_year,roster_no:roster_no.to_s)
                      .standard_books(grade_section.grade_level.id, grade_section.id, new_year, textbook_category.id)
                      .joins(:book_copy).where('book_copies.book_condition_id != ?', poor_condition.id)
    BookReceipt.create(student_books.map { |sb|
      { book_copy_id: sb.book_copy_id, barcode:sb.barcode, book_edition_id:sb.book_edition_id,
        academic_year_id:new_year, initial_condition_id:sb.book_copy.book_condition_id,
        grade_section_id:sb.grade_section_id, grade_level_id:sb.grade_level_id, roster_no:sb.roster_no.to_i, course_id:sb.course_id
      }
    })
  end

  private

    def update_book_copy_condition
      if initial_condition_id != book_copy.book_condition_id
        book_copy.copy_conditions.create([
                academic_year_id: academic_year_id,
                book_condition_id: initial_condition_id,
                barcode: barcode,
                notes: 'Updated through Receipt Form',
                start_date: Date.today,
                deleted_flag: false,
                post: 0
            ])
      end
    end

end
