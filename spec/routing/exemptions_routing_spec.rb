require "rails_helper"

RSpec.describe ExemptionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/exemptions").to route_to("exemptions#index")
    end

    it "routes to #new" do
      expect(get: "/exemptions/new").to route_to("exemptions#new")
    end

    it "routes to #show" do
      expect(get: "/exemptions/1").to route_to("exemptions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/exemptions/1/edit").to route_to("exemptions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/exemptions").to route_to("exemptions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/exemptions/1").to route_to("exemptions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/exemptions/1").to route_to("exemptions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/exemptions/1").to route_to("exemptions#destroy", id: "1")
    end
  end
end
