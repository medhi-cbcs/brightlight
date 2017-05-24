require 'rails_helper'

RSpec.describe "budget_items/index", type: :view do
  before(:each) do
    assign(:budget_items, [
      BudgetItem.create!(
        :budget => nil,
        :description => "Description",
        :notes => "Notes",
        :amount => "9.99",
        :currency => "Currency",
        :used_amount => "9.99",
        :completed => false,
        :appvl_notes => "Appvl Notes",
        :approved => false,
        :approver => nil
      ),
      BudgetItem.create!(
        :budget => nil,
        :description => "Description",
        :notes => "Notes",
        :amount => "9.99",
        :currency => "Currency",
        :used_amount => "9.99",
        :completed => false,
        :appvl_notes => "Appvl Notes",
        :approved => false,
        :approver => nil
      )
    ])
  end

  it "renders a list of budget_items" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Notes".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Currency".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Appvl Notes".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
