class Requisition < ActiveRecord::Base
  belongs_to :department
  belongs_to :requester
  belongs_to :bdgt_appvd_by
end
