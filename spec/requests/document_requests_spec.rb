require 'rails_helper'

RSpec.describe "DocumentRequests", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/document_requests/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/document_requests/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/document_requests/show"
      expect(response).to have_http_status(:success)
    end
  end

end
