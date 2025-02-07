require 'rails_helper'

RSpec.describe "Readmissions", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/readmissions/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/readmissions/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/readmissions/index"
      expect(response).to have_http_status(:success)
    end
  end

end
