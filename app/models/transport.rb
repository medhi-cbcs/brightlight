class Transport < ActiveRecord::Base
  validates :category, :name, presence: true
  validates :name, uniqueness: true
  
  has_many :smart_cards
  has_many :passengers
  has_many :students, through: :passengers

  scope :private_cars, lambda { where(category:'private') }
  scope :shuttle_cars, lambda { where(category:'shuttle') }  
  scope :with_grades, lambda {
    joins("left join families f on f.family_no = transports.family_no")
    .joins("left join family_members fm on f.id = fm.family_id and fm.relation = 'child'")
    .joins("left join grade_sections_students gss on gss.student_id = fm.student_id ")
    .where("gss.academic_year_id = ?", AcademicYear.current_year.take.id)
  }
  scope :am_carpool, lambda {
    with_grades.where("gss.grade_section_id < 12")
  }
  scope :pm_carpool, lambda {
    with_grades.where("gss.grade_section_id > 12")
  }

  accepts_nested_attributes_for :smart_cards, allow_destroy: true, reject_if: proc { |attributes| attributes['code'].blank? }
  accepts_nested_attributes_for :passengers, allow_destroy: true, reject_if: :all_blank

end
