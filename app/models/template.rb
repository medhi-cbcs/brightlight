class Template < ActiveRecord::Base
  belongs_to :academic_year
  belongs_to :user
end
