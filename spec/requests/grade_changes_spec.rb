require 'rails_helper'

RSpec.describe "GradeChanges", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/grade_changes/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/grade_changes/create"
      expect(response).to have_http_status(:success)
    end
  end

end
