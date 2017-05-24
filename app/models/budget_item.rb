class BudgetItem < ActiveRecord::Base
  belongs_to :budget
  belongs_to :approver
end
