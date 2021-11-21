require 'rails_helper'

RSpec.describe "Products", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/products/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/products/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /list" do
    it "returns http success" do
      get "/products/list"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/products/delete"
      expect(response).to have_http_status(:success)
    end
  end

end
