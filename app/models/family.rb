class Family < ActiveRecord::Base
  has_many :family_members
  validates :family_number, uniqueness: true
  validates :family_no, uniqueness: true

  def guardians               # Hey, we can't use 'parents' here. :parents is a method name in Ruby  
    family_members.guardians.includes(:guardian).map &:guardian
  end 

  def father
    family_members.father.take.guardian
  end 

  def mother
    family_members.mother.take.guardian
  end 

  def children 
    family_members.children.includes(:student).map &:student
  end
end
