require "rails_helper"

RSpec.describe "Admin::StatisticProducts", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/admin/statistic_products/index"
      expect(response).to have_http_status(:success)
    end
  end

end
