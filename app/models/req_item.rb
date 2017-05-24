class ReqItem < ActiveRecord::Base
  belongs_to :requisition
  belongs_to :budget_item
  belongs_to :bdgt_appvl_by
end
