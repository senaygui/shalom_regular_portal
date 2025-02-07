require 'rails_helper'

RSpec.describe "Reports", type: :request do
  describe "GET /course_assignments" do
    it "returns http success" do
      get "/reports/course_assignments"
      expect(response).to have_http_status(:success)
    end
  end

end
