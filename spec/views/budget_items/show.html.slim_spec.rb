require 'rails_helper'

RSpec.describe "budget_items/show", type: :view do
  before(:each) do
    @budget_item = assign(:budget_item, BudgetItem.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Notes/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Currency/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Appvl Notes/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
