require 'rails_helper'

RSpec.describe "budgets/show", type: :view do
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
      :type => "Type",
      :category => "Category",
      :active => false,
      :notes => "Notes"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Notes/)
  end
end
