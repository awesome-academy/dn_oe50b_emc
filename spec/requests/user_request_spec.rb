require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET #new" do
    context "user registers an account" do
      before { get "/users/new" }

      it {should render_template(:new)}
    end
  end

  describe "POST #create" do
    let(:user_params) {FactoryBot.attributes_for(:user)}

    context "success when valid attributes" do
      before do
        post "/users", params: {
            user: user_params
          }
      end

      it "should flash create success" do
        content = I18n.t("flash.please_check_email")
        expect(flash[:info]).to eq(content)
      end
    end

    context "when invalid user params" do
      before do
        post "/users", params: {
          user: {
            name: "",
            email: "",
            phone_number: "0366837259",
            address: "67 Thai Van A",
            id_card: "123456789",
            password: "",
            password_confirmation: ""
          }
        }
      end

      it "should render new user information entry page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT #update" do
    let(:user) {FactoryBot.create(:user)}
    context "when valid user attribute" do
      it "should located the requested" do
        put "/users/%{id}" % { id: user.id }, params: {user: FactoryBot.attributes_for(:user), id: user.id}
        expect(assigns(user)).to eq(@user)
      end
    end
  end

  describe "GET /show" do
    let (:user) { create(:user) }
    context "when valid id" do
      let (:user) { create(:user) }

      before { get "/users/%{id}" % { id: user.id } }

      it "should render show user when params id valid" do
        expect(response).to render_template(:show)
      end

      it "should return user when params id valid" do
        expect(assigns(:user)).to eq(user)
      end
    end

    context "when not invalid id" do
      before { get "/users/-1" }

      it "should redirect new_user when user not found" do
        expect(response).to redirect_to(new_user_path)
      end

      it "should flash warning when user not found" do
        content = I18n.t("flash.user_not_found")
        expect(flash[:warning]).to eq(content)
      end
    end
  end
end
