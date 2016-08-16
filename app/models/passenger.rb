class Passenger < ActiveRecord::Base
  validates :student, presence: true
  validates :student, uniqueness: true, if: "active == true"

  belongs_to :grade_section
  belongs_to :student

  # We store grade_section in this table, we will need to synchronize the data when the student's grade_section changes
  def synchronize_grade_section
    # TODO: finish synchronize_grade_section method
  end

end
