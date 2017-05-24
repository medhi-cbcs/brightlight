require 'rails_helper'

RSpec.describe "req_items/show", type: :view do
  before(:each) do
    @req_item = assign(:req_item, ReqItem.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/Unit/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Notes/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Budget Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Bdgt Notes/)
    expect(rendered).to match(//)
  end
end
