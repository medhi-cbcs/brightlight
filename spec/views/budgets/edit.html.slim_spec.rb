require 'rails_helper'

RSpec.describe "budgets/edit", type: :view do
  before(:each) do
    @budget = assign(:budget, Budget.create!(
      :department => nil,
      :owner => nil,
      :grade_level => nil,
      :grade_section => nil,
      :academic_year => nil,
      :submitted => false,
      :approved => false,
      :approver => nil,
      :type => "",
      :category => "MyString",
      :active => false,
      :notes => "MyString"
    ))
  end

  it "renders the edit budget form" do
    render

    assert_select "form[action=?][method=?]", budget_path(@budget), "post" do

      assert_select "input#budget_department_id[name=?]", "budget[department_id]"

      assert_select "input#budget_owner_id[name=?]", "budget[owner_id]"

      assert_select "input#budget_grade_level_id[name=?]", "budget[grade_level_id]"

      assert_select "input#budget_grade_section_id[name=?]", "budget[grade_section_id]"

      assert_select "input#budget_academic_year_id[name=?]", "budget[academic_year_id]"

      assert_select "input#budget_submitted[name=?]", "budget[submitted]"

      assert_select "input#budget_approved[name=?]", "budget[approved]"

      assert_select "input#budget_approver_id[name=?]", "budget[approver_id]"

      assert_select "input#budget_type[name=?]", "budget[type]"

      assert_select "input#budget_category[name=?]", "budget[category]"

      assert_select "input#budget_active[name=?]", "budget[active]"

      assert_select "input#budget_notes[name=?]", "budget[notes]"
    end
  end
end
