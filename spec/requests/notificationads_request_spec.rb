require "rails_helper"

RSpec.describe "Notificationads", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/notificationads/index"
      expect(response).to have_http_status(:success)
    end
  end

end
