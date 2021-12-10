require "rails_helper"

RSpec.describe Product, type: :model do
  subject{ FactoryBot.create :product }
  describe "validations" do
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:publisher) }

    context "#name" do
      it do
        should validate_presence_of(:name)
      end
      it do
        should validate_length_of(:name)
        .is_at_least(Settings.atrr.lenght_min)
        .with_message(I18n.t("errors.messages.too_short",
         count: Settings.atrr.lenght_min))
      end
    end

    context "#quantity" do
      it do
        should validate_presence_of(:quantity)
      end

      it do
        should validate_numericality_of(:quantity)
      end
    end

    context "#price" do
      it do
        should validate_presence_of(:price)
      end
      it do
        should validate_numericality_of(:price)
      end
    end
  end

  describe "enum" do
    it { should define_enum_for(:status).with([:Hot, :New, :Trend]) }
  end

  describe "associations" do
    it {should belong_to(:category)}
    it {should delegate_method(:title).to(:category).with_prefix(:category)}
    it {should have_many(:order_details).dependent(:destroy)}
    it {should have_many(:rates).dependent(:destroy)}
    it {should have_one_attached(:image)}
  end

  describe "scopes" do
    let!(:product_1) {FactoryBot.create(:product, price:50000)}
    let!(:product_2) {FactoryBot.create(:product, price:70000)}
    let!(:product_3) {FactoryBot.create(:product, price:80000)}

    it "should return products with create date sort Desc" do
      expect(Product.sort_by_created) == [product_3, product_2, product_1]
    end

    it "should return products with price sort Asc" do
      expect(Product.ordered_by_price) == [product_1, product_2, product_3]
    end
  end

  describe "#defination method" do
    let!(:product) {FactoryBot.create(:product, quantity:10)}

    context "return true or false when compare with quantity params" do
      it "should return true" do
        expect(product.check_enought_quantity?(5)).to eq(true)
      end
      it "should return false" do
        expect(product.check_enought_quantity?(11)).to eq(false)
      end
    end
  end
end
