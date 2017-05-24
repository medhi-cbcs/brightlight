require 'rails_helper'

RSpec.describe "budgets/index", type: :view do
  before(:each) do
    assign(:budgets, [
      Budget.create!(
        :department => nil,
        :owner => nil,
        :grade_level => nil,
        :grade_section => nil,
        :academic_year => nil,
        :submitted => false,
        :approved => false,
        :approver => nil,
        :type => "Type",
        :category => "Category",
        :active => false,
        :notes => "Notes"
      ),
      Budget.create!(
        :department => nil,
        :owner => nil,
        :grade_level => nil,
        :grade_section => nil,
        :academic_year => nil,
        :submitted => false,
        :approved => false,
        :approver => nil,
        :type => "Type",
        :category => "Category",
        :active => false,
        :notes => "Notes"
      )
    ])
  end

  it "renders a list of budgets" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Notes".to_s, :count => 2
  end
end
