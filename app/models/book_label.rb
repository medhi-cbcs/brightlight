# Book Labels are in the form of GradeSection.name#number, such as '1A#12' or '12C#3'
class BookLabel < ActiveRecord::Base
  belongs_to :grade_section
  belongs_to :student

  validates :name, presence: true, uniqueness: true

  def self.for_section_and_number(section, number)
    label = section + '#' + number.to_s
    where(name:label).first
  end
end
