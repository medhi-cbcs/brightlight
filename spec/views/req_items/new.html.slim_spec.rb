require 'rails_helper'

RSpec.describe "req_items/new", type: :view do
  before(:each) do
    assign(:req_item, ReqItem.new(
      :requisition => nil,
      :description => "MyString",
      :qty_reqd => 1.5,
      :unit => "MyString",
      :est_price => "9.99",
      :actual_price => "9.99",
      :notes => "MyString",
      :budgetted => false,
      :budget_item => nil,
      :budget_name => "MyString",
      :bdgt_approved => false,
      :bdgt_notes => "MyString",
      :bdgt_appvl_by => nil
    ))
  end

  it "renders new req_item form" do
    render

    assert_select "form[action=?][method=?]", req_items_path, "post" do

      assert_select "input#req_item_requisition_id[name=?]", "req_item[requisition_id]"

      assert_select "input#req_item_description[name=?]", "req_item[description]"

      assert_select "input#req_item_qty_reqd[name=?]", "req_item[qty_reqd]"

      assert_select "input#req_item_unit[name=?]", "req_item[unit]"

      assert_select "input#req_item_est_price[name=?]", "req_item[est_price]"

      assert_select "input#req_item_actual_price[name=?]", "req_item[actual_price]"

      assert_select "input#req_item_notes[name=?]", "req_item[notes]"

      assert_select "input#req_item_budgetted[name=?]", "req_item[budgetted]"

      assert_select "input#req_item_budget_item_id[name=?]", "req_item[budget_item_id]"

      assert_select "input#req_item_budget_name[name=?]", "req_item[budget_name]"

      assert_select "input#req_item_bdgt_approved[name=?]", "req_item[bdgt_approved]"

      assert_select "input#req_item_bdgt_notes[name=?]", "req_item[bdgt_notes]"

      assert_select "input#req_item_bdgt_appvl_by_id[name=?]", "req_item[bdgt_appvl_by_id]"
    end
  end
end
