class OrderItem < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :req_line
end
