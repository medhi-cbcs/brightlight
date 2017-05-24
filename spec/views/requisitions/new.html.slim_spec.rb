require 'rails_helper'

RSpec.describe "requisitions/new", type: :view do
  before(:each) do
    assign(:requisition, Requisition.new(
      :req_no => "MyString",
      :department => nil,
      :requester => nil,
      :supv_approved => false,
      :supv_notes => "MyString",
      :notes => "MyString",
      :budgetted => false,
      :budget_approved => false,
      :bdgt_appvd_by => nil,
      :bdgt_appvd_name => "MyString",
      :bdgt_appv_notes => "MyString",
      :sent_purch => false,
      :sent_supv => false,
      :sent_bdgt_appv => false,
      :notes => "MyString",
      :origin => "MyString"
    ))
  end

  it "renders new requisition form" do
    render

    assert_select "form[action=?][method=?]", requisitions_path, "post" do

      assert_select "input#requisition_req_no[name=?]", "requisition[req_no]"

      assert_select "input#requisition_department_id[name=?]", "requisition[department_id]"

      assert_select "input#requisition_requester_id[name=?]", "requisition[requester_id]"

      assert_select "input#requisition_supv_approved[name=?]", "requisition[supv_approved]"

      assert_select "input#requisition_supv_notes[name=?]", "requisition[supv_notes]"

      assert_select "input#requisition_notes[name=?]", "requisition[notes]"

      assert_select "input#requisition_budgetted[name=?]", "requisition[budgetted]"

      assert_select "input#requisition_budget_approved[name=?]", "requisition[budget_approved]"

      assert_select "input#requisition_bdgt_appvd_by_id[name=?]", "requisition[bdgt_appvd_by_id]"

      assert_select "input#requisition_bdgt_appvd_name[name=?]", "requisition[bdgt_appvd_name]"

      assert_select "input#requisition_bdgt_appv_notes[name=?]", "requisition[bdgt_appv_notes]"

      assert_select "input#requisition_sent_purch[name=?]", "requisition[sent_purch]"

      assert_select "input#requisition_sent_supv[name=?]", "requisition[sent_supv]"

      assert_select "input#requisition_sent_bdgt_appv[name=?]", "requisition[sent_bdgt_appv]"

      assert_select "input#requisition_notes[name=?]", "requisition[notes]"

      assert_select "input#requisition_origin[name=?]", "requisition[origin]"
    end
  end
end
