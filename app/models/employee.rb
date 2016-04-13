class Employee < ActiveRecord::Base
 	validates :name, presence: true

 	belongs_to :person, class_name: "User"
	belongs_to :department
	belongs_to :supervisor, class_name: "Employee"
	has_many :subordinates, class_name: "Employee", foreign_key: "supervisor_id"
  has_many :book_loans
  has_many :grade_sections, foreign_key: "homeroom_id"
  has_many :course_sections, foreign_key: "instructor_id"

  accepts_nested_attributes_for :book_loans, allow_destroy: true, reject_if: :all_blank

	scope :all_teachers, lambda { where(job_title:'Teacher') }
  scope :active, lambda { where(is_active:true).order(:name) }

  def name
  	original = self[:name]
  	original.titleize
  end

	def to_s
		name
	end
end
