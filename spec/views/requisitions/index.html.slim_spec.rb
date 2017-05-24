require 'rails_helper'

RSpec.describe "requisitions/index", type: :view do
  before(:each) do
    assign(:requisitions, [
      Requisition.create!(
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
      ),
      Requisition.create!(
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
      )
    ])
  end

  it "renders a list of requisitions" do
    render
    assert_select "tr>td", :text => "Req No".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Supv Notes".to_s, :count => 2
    assert_select "tr>td", :text => "Notes".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Bdgt Appvd Name".to_s, :count => 2
    assert_select "tr>td", :text => "Bdgt Appv Notes".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Notes".to_s, :count => 2
    assert_select "tr>td", :text => "Origin".to_s, :count => 2
  end
end
