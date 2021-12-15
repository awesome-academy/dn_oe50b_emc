require "spec_helper"
require "rails_helper"

RSpec.describe "users/new", type: :view do
  let(:user) {FactoryBot.build :user}

  before do
    assign :user, user
    render
  end

  describe "content" do

    it "should have title" do
      view.content_for(:title)
    end

    context "have atrribute name field" do
      it {assert_select "form[action*=?]",users_path}

      it "should have atrribute name" do
        render
        expect(rendered).to have_field "user_name"
      end
      it "should have atrribute email" do
        render
        expect(rendered).to have_field "user_email"
      end
      it "should have atrribute id card" do
        render
        expect(rendered).to have_field "user_id_card"
      end
      it "should have atrribute phone number" do
        render
        expect(rendered).to have_field "user_phone_number"
      end
      it "should have atrribute address" do
        render
        expect(rendered).to have_field "user_address"
      end
      it "should have atrribute password" do
        render
        expect(rendered).to have_field "user_password"
      end
      it "should have atrribute password confirmation" do
        render
        expect(rendered).to have_field "user_password_confirmation"
      end
    end
  end
end
