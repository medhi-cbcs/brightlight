class Student < ActiveRecord::Base
	has_many :students_guardians
	has_many :guardians, through: :students_guardians
  has_many :grade_sections_students, dependent: :destroy
	has_many :grade_sections, through: :grade_sections_students
	has_many :course_sections, through: :rosters
  has_many :rosters, dependent: :destroy  
 	belongs_to :person
  validates :name, :gender, presence: true
  validates :person, presence: true

	scope :current, lambda { joins(:grade_sections_students).where(grade_sections_students: {academic_year: AcademicYear.current_id}) }
  scope :with_academic_year, lambda {|academic_year| joins(:grade_sections_students).where(grade_sections_students: {academic_year: academic_year}) }
	scope :for_section, lambda {|section| joins(:grade_sections_students).where(grade_sections_students: {grade_section: section}) }

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
    when /^admission_no/
      order("LOWER(students.admission_no) #{ direction }")
    when /^family_id/
      order("LOWER(students.family_id) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Admission No', 'admission_no_asc'],
      ['Family No', 'famimly_id_asc']
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
end
