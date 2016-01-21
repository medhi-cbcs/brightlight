class CourseSection < ActiveRecord::Base
  validates :name, presence: true
  validates :grade_section, presence: true
  validates :course, presence: true

  belongs_to :course
  belongs_to :grade_section
  belongs_to :instructor, class_name: "Employee"

  has_many :rosters, dependent: :destroy
  has_many :students, through: :rosters

  scope :with_grade_level_id, lambda {|id| joins(:grade_section).where(grade_sections: {grade_level_id: id})}
  scope :with_course_id, lambda {|id| where(course_od: id)}

  def textbooks
    if course.has_course_texts?
      course.book_titles
    end unless course.blank?
  end

end
