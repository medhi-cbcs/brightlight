require 'rails_helper'

RSpec.describe "ReqItems", type: :request do
  describe "GET /req_items" do
    it "works! (now write some real specs)" do
      get req_items_path
      expect(response).to have_http_status(200)
    end
  end
end
