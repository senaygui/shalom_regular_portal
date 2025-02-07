require 'rails_helper'

RSpec.describe "ApplyGradeChanges", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/apply_grade_change/index"
      expect(response).to have_http_status(:success)
    end
  end

end
