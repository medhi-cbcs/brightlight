require "rails_helper"

RSpec.describe ReqItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/req_items").to route_to("req_items#index")
    end

    it "routes to #new" do
      expect(:get => "/req_items/new").to route_to("req_items#new")
    end

    it "routes to #show" do
      expect(:get => "/req_items/1").to route_to("req_items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/req_items/1/edit").to route_to("req_items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/req_items").to route_to("req_items#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/req_items/1").to route_to("req_items#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/req_items/1").to route_to("req_items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/req_items/1").to route_to("req_items#destroy", :id => "1")
    end

  end
end
