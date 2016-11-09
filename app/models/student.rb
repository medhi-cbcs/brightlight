class Student < ActiveRecord::Base
  has_many :grade_sections_students
	has_many :grade_sections, through: :grade_sections_students
	has_many :course_sections, through: :rosters
  has_many :rosters, dependent: :destroy
	has_one  :student_admission_info, autosave: true
	has_many :student_books
	has_many :book_loans
	has_many :book_fines
	has_one  :passenger
	has_one  :transport, through: :passenger
 	belongs_to :person
	belongs_to :family

  validates :name, :student_no, presence: true

	accepts_nested_attributes_for :student_books, allow_destroy: true, reject_if: :all_blank
	accepts_nested_attributes_for :book_loans, allow_destroy: true, reject_if: :all_blank

	scope :current, lambda { joins('INNER JOIN grade_sections_students ON grade_sections_students.student_id = students.id
											INNER JOIN grade_sections ON grade_sections.id = grade_sections_students.grade_section_id')
		.where(grade_sections_students: {academic_year: AcademicYear.current}) }
  
	scope :with_academic_year, lambda {|academic_year|
		joins(:grade_sections_students)
			.where(grade_sections_students: {academic_year: academic_year}) }
	# scope :for_section, lambda {|section|
	# 	joins(:grade_sections_students)
	# 		.where(grade_sections_students: {grade_section: section, academic_year: AcademicYear.current})
	# 		.select('students.id,students.name,grade_sections_students.grade_section_id,grade_sections_students.order_no')
	# 		.order('grade_sections_students.order_no')
	# }
	scope :for_section, lambda {|section, year:AcademicYear.current|
		joins('INNER JOIN "grade_sections_students" ON "grade_sections_students"."student_id" = "students"."id"	INNER JOIN "grade_sections" ON "grade_sections"."id" = "grade_sections_students"."grade_section_id"') 
		.where(grade_sections_students: {grade_section: section, academic_year: year})
		.select('students.id, students.name, students.family_no, grade_sections_students.grade_section_id, grade_sections_students.order_no, grade_sections.name as grade')
			.order('grade_sections_students.order_no')
	}

	scope :search_name, lambda { |name| where('UPPER(students.name) LIKE ?', "%#{name.upcase}%") }

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query
    ]
  )

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
        "(LOWER(name) LIKE ?)"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("students.created_at #{ direction }")
    when /^name/
      order("LOWER(students.name) #{ direction }")
    when /^family_no/
      order("LOWER(students.family_no) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Admission No', 'admission_no_asc'],
      ['Family No', 'family_id_asc']
    ]
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |student|
        csv << student.attributes.values_at(*column_names)
      end
    end
  end

	def current_grade_section
		grade_section_with_academic_year_id(AcademicYear.current_id)
	end

	def current_roster_no
		roster_no_with_academic_year_id(AcademicYear.current_id)
	end

	def roster_no_with_academic_year_id(academic_year_id)
		grade_sections_students
				.with_academic_year(academic_year_id)
				.pluck(:order_no)
				.first
	end

	def grade_section_with_academic_year_id(academic_year_id)
		GradeSection.joins(:grade_sections_students)
			.where(grade_sections_students: {academic_year_id:academic_year_id, student:self})
			.select('grade_sections.*, grade_sections_students.track as track').take
	end

	def self.having_books_with_condition(condition)
	  ## The following statement, unforetunately, won't work. So we fallback to sql statement.
	  # @students = Student.joins(:student_books)
	  #                   .where(student_books: {end_copy_condition:missing})
	  #                   .order('student_books.grade_section_id' ,'CAST(student_books.roster_no AS int)')
	  #                   .uniq
		Student.find_by_sql [
			"SELECT DISTINCT students.*, student_books.grade_section_id, CAST(student_books.roster_no AS int)
			 FROM students
			 INNER JOIN student_books ON student_books.student_id = students.id
			 WHERE student_books.end_copy_condition_id = ?
			 ORDER BY student_books.grade_section_id, CAST(student_books.roster_no AS int)", condition.id
		]
	end

	def self.in_section_having_books_with_condition(condition, section:)
		Student.find_by_sql [
			"SELECT DISTINCT students.*, student_books.grade_section_id, CAST(student_books.roster_no AS int)
			 FROM students
			 INNER JOIN student_books ON student_books.student_id = students.id
			 WHERE student_books.end_copy_condition_id = ? AND grade_section_id = ?
			 ORDER BY student_books.grade_section_id, CAST(student_books.roster_no AS int)",
			 condition.id, section.id
		]
	end

	def sibs
		FamilyMember.where(family_id:self.family_id, relation:'child').where.not(student_id:self.id).includes(:student).map &:student
	end

	def guardians
		FamilyMember.where(family_id:self.family_id).guardians.includes(:guardian)
	end
end
