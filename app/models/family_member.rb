class FamilyMember < ActiveRecord::Base
  belongs_to :family
  belongs_to :guardian
  belongs_to :student
  validates :relation, presence: true
  validates :guardian, uniqueness: {scope: [:family_id, :relation] }, allow_nil: true
  validates :student, uniqueness: {scope: [:family_id] }, allow_nil: true

  scope :father, lambda { where("LOWER(relation) = 'father'") }
  scope :mother, lambda { where("LOWER(relation) = 'mother'") }
  scope :guardians, lambda { where("LOWER(relation) = 'mother' OR LOWER(relation) = 'father'") }  # Hey, we can't use 'parents' here. :parents is a method name in Ruby
  scope :children, lambda { where("LOWER(relation) = 'child'") }  
end
