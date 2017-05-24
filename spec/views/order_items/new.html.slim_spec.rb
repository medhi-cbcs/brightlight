require 'rails_helper'

RSpec.describe "order_items/new", type: :view do
  before(:each) do
    assign(:order_item, OrderItem.new(
      :purchase_order => nil,
      :no => 1,
      :supplier => "MyString",
      :supplier_id => 1,
      :req_line => nil,
      :invoice_amt => "9.99",
      :dp_amount => "9.99",
      :notes => "MyString"
    ))
  end

  it "renders new order_item form" do
    render

    assert_select "form[action=?][method=?]", order_items_path, "post" do

      assert_select "input#order_item_purchase_order_id[name=?]", "order_item[purchase_order_id]"

      assert_select "input#order_item_no[name=?]", "order_item[no]"

      assert_select "input#order_item_supplier[name=?]", "order_item[supplier]"

      assert_select "input#order_item_supplier_id[name=?]", "order_item[supplier_id]"

      assert_select "input#order_item_req_line_id[name=?]", "order_item[req_line_id]"

      assert_select "input#order_item_invoice_amt[name=?]", "order_item[invoice_amt]"

      assert_select "input#order_item_dp_amount[name=?]", "order_item[dp_amount]"

      assert_select "input#order_item_notes[name=?]", "order_item[notes]"
    end
  end
end
