require "spec_helper"
require "rails_helper"

RSpec.describe "admin/products/new", type: :view do
  let(:product) {FactoryBot.build :product}

  before do
    assign :product, product
    render
  end

  describe "content" do

    it "should have title" do
      view.content_for(:title)
    end

    context "have atrribute name field" do
      it "should have atrribute name" do
        render
        expect(rendered).to have_field(I18n.t("product.name"))
      end
      it "should have atrribute image" do
        render
        expect(rendered).to have_field(I18n.t("product.img"))
      end
      it "should have atrribute price" do
        render
        expect(rendered).to have_field(I18n.t("product.price"))
      end
      it "should have atrribute quantity" do
        render
        expect(rendered).to have_field(I18n.t("product.quantity"))
      end
      it "should have atrribute author" do
        render
        expect(rendered).to have_field(I18n.t("product.author"))
      end
      it "should have atrribute description" do
        render
        expect(rendered).to have_field(I18n.t("product.description"))
      end
      it "should have atrribute publisher" do
        render
        expect(rendered).to have_field(I18n.t("product.publisher"))
      end
    end
  end
end
