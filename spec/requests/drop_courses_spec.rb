require 'rails_helper'

RSpec.describe "DropCourses", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/drop_courses/index"
      expect(response).to have_http_status(:success)
    end
  end

end
