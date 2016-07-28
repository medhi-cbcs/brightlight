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

  def self.initialize_with_student_books(previous_year_id, new_year_id)
    columns = [:book_copy_id, :barcode, :book_edition_id, :academic_year_id, :initial_condition_id,
               :grade_section_id, :grade_level_id, :roster_no, :course_id]
    textbook_category = BookCategory.find_by_code 'TB'
    GradeSection.all.each do |grade_section|
      self.initialize_with_student_books_for_grade(previous_year_id, new_year_id, grade_section.id)
      # values = []
      # grade_level_id = grade_section.grade_level_id
      # student_books = StudentBook.where(grade_section:grade_section)
      #                   .where(academic_year_id:previous_year_id)
      #                   .standard_books(grade_section.grade_level.id, grade_section.id, new_year_id, textbook_category.id)
      #
      # student_books.each_with_index do |sb,i|
      #   data = [sb.book_copy_id, sb.barcode, sb.book_edition_id, new_year_id, sb.initial_copy_condition_id,
      #           sb.grade_section_id, sb.grade_level_id, sb.roster_no.to_i, sb.course_id]
      #   values << data
      #   if i % 200 == 0
      #     BookReceipt.import columns, values
      #     values = []
      #   end
      # end
      #
      # unless values.empty?
      #   BookReceipt.import columns, values
      # end
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
