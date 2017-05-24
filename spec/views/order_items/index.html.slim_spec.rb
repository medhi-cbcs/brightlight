require 'rails_helper'

RSpec.describe "order_items/index", type: :view do
  before(:each) do
    assign(:order_items, [
      OrderItem.create!(
        :purchase_order => nil,
        :no => 2,
        :supplier => "Supplier",
        :supplier_id => 3,
        :req_line => nil,
        :invoice_amt => "9.99",
        :dp_amount => "9.99",
        :notes => "Notes"
      ),
      OrderItem.create!(
        :purchase_order => nil,
        :no => 2,
        :supplier => "Supplier",
        :supplier_id => 3,
        :req_line => nil,
        :invoice_amt => "9.99",
        :dp_amount => "9.99",
        :notes => "Notes"
      )
    ])
  end

  it "renders a list of order_items" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Supplier".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Notes".to_s, :count => 2
  end
end
