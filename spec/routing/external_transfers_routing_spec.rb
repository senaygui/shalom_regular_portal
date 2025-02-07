require "rails_helper"

RSpec.describe ExternalTransfersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/external_transfers").to route_to("external_transfers#index")
    end

    it "routes to #new" do
      expect(get: "/external_transfers/new").to route_to("external_transfers#new")
    end

    it "routes to #show" do
      expect(get: "/external_transfers/1").to route_to("external_transfers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/external_transfers/1/edit").to route_to("external_transfers#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/external_transfers").to route_to("external_transfers#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/external_transfers/1").to route_to("external_transfers#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/external_transfers/1").to route_to("external_transfers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/external_transfers/1").to route_to("external_transfers#destroy", id: "1")
    end
  end
end
