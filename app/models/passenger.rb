class Passenger < ActiveRecord::Base
  validates :student, presence: true

  belongs_to :grade_section
  belongs_to :student
  belongs_to :transport

  # after_create :fill_in_details

  # We store student name and grade_section in this table, we will need to synchronize the data when the student's grade_section changes
  def synchronize_grade_section
    # TODO: finish synchronize_grade_section method
  end

  # private
  #
  #   def fill_in_details
  #
  #   end

end
