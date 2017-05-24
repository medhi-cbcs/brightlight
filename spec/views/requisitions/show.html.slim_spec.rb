require 'rails_helper'

RSpec.describe "requisitions/show", type: :view do
  before(:each) do
    @requisition = assign(:requisition, Requisition.create!(
      :req_no => "Req No",
      :department => nil,
      :requester => nil,
      :supv_approved => false,
      :supv_notes => "Supv Notes",
      :notes => "Notes",
      :budgetted => false,
      :budget_approved => false,
      :bdgt_appvd_by => nil,
      :bdgt_appvd_name => "Bdgt Appvd Name",
      :bdgt_appv_notes => "Bdgt Appv Notes",
      :sent_purch => false,
      :sent_supv => false,
      :sent_bdgt_appv => false,
      :notes => "Notes",
      :origin => "Origin"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Req No/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Supv Notes/)
    expect(rendered).to match(/Notes/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Bdgt Appvd Name/)
    expect(rendered).to match(/Bdgt Appv Notes/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Notes/)
    expect(rendered).to match(/Origin/)
  end
end
