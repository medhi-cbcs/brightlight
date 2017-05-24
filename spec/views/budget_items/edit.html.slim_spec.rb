require 'rails_helper'

RSpec.describe "budget_items/edit", type: :view do
  before(:each) do
    @budget_item = assign(:budget_item, BudgetItem.create!(
      :budget => nil,
      :description => "MyString",
      :notes => "MyString",
      :amount => "9.99",
      :currency => "MyString",
      :used_amount => "9.99",
      :completed => false,
      :appvl_notes => "MyString",
      :approved => false,
      :approver => nil
    ))
  end

  it "renders the edit budget_item form" do
    render

    assert_select "form[action=?][method=?]", budget_item_path(@budget_item), "post" do

      assert_select "input#budget_item_budget_id[name=?]", "budget_item[budget_id]"

      assert_select "input#budget_item_description[name=?]", "budget_item[description]"

      assert_select "input#budget_item_notes[name=?]", "budget_item[notes]"

      assert_select "input#budget_item_amount[name=?]", "budget_item[amount]"

      assert_select "input#budget_item_currency[name=?]", "budget_item[currency]"

      assert_select "input#budget_item_used_amount[name=?]", "budget_item[used_amount]"

      assert_select "input#budget_item_completed[name=?]", "budget_item[completed]"

      assert_select "input#budget_item_appvl_notes[name=?]", "budget_item[appvl_notes]"

      assert_select "input#budget_item_approved[name=?]", "budget_item[approved]"

      assert_select "input#budget_item_approver_id[name=?]", "budget_item[approver_id]"
    end
  end
end
