require 'rails_helper'

RSpec.describe "req_items/index", type: :view do
  before(:each) do
    assign(:req_items, [
      ReqItem.create!(
        :requisition => nil,
        :description => "Description",
        :qty_reqd => 2.5,
        :unit => "Unit",
        :est_price => "9.99",
        :actual_price => "9.99",
        :notes => "Notes",
        :budgetted => false,
        :budget_item => nil,
        :budget_name => "Budget Name",
        :bdgt_approved => false,
        :bdgt_notes => "Bdgt Notes",
        :bdgt_appvl_by => nil
      ),
      ReqItem.create!(
        :requisition => nil,
        :description => "Description",
        :qty_reqd => 2.5,
        :unit => "Unit",
        :est_price => "9.99",
        :actual_price => "9.99",
        :notes => "Notes",
        :budgetted => false,
        :budget_item => nil,
        :budget_name => "Budget Name",
        :bdgt_approved => false,
        :bdgt_notes => "Bdgt Notes",
        :bdgt_appvl_by => nil
      )
    ])
  end

  it "renders a list of req_items" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => "Unit".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Notes".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Budget Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Bdgt Notes".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
