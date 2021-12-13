require "rails_helper"

RSpec.describe "Admin::Products", type: :request do
  let (:products) { create_list(:product, Settings.atrr.paging_min)}

  describe "GET" do
    let!(:product) {FactoryBot.create(:product)}
    context "#index" do
      before { get "/admin/products"}

      it "should render index template" do
        expect(response).to render_template(:index)
      end

      it "assigns all products as @products" do
        expect(assigns(:products)) == Product.all
      end
    end

    context "#new" do
      before { get "/admin/products/new"}

      it "should render new template" do
        expect(response).to render_template(:new)
      end

      it "assigns a new product as @product" do
        expect(assigns(:product)).to be_a_new(Product)
      end
    end

    describe "#edit" do
      context "found product" do
        before { get "/admin/products/%{id}/edit" % {id: product.id} }

        it "should return product" do
          expect(assigns(:product)).to eq(product)
        end
      end

      context "not found product" do
        before { get "/admin/products/%{id}/edit" % {id: -1} }
        it "return flash danger" do
          expect(flash[:error]).to eq I18n.t("flash.not_found")
        end
      end
    end
  end

  describe "POST #create" do
    let(:product_params) {FactoryBot.attributes_for(:product, status: :Hot)}

    context "success when valid attributes" do
      before do
        post "/admin/products", params: {
            product: product_params
          }
      end

      it "flash create success" do
        content = I18n.t("flash.create_succ")
        expect(flash[:info]) == content
      end
    end
  end

  describe "DELETE #destroy" do
    product = FactoryBot.create(:product)
    before { delete "/admin/products/%{id}" % {id: product.id} }

    it "should return flash success" do
      expect(flash[:success]) == I18n.t("flash.hide_succ")
    end

    it "should be false" do
      expect(Product.exists?(product.id)).to be_falsey
    end
  end

  describe "PUT #update" do
    let(:product) {FactoryBot.create(:product)}
    context "success when valid user attribute" do
      it "located the requested" do
        put "/admin/products/%{id}" % { id: product.id },
        params: {product: FactoryBot.attributes_for(:product, status: :Trend), id: product.id}
        expect(assigns(product)).to eq(@product)
      end
    end
  end
end
