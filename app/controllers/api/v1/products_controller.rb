module Api
  module V1
    class ProductsController < ApplicationController
      before_action :load_product, only: %i(show update destroy)
      skip_before_action :verify_authenticity_token
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      def index
        @products = Product.ordered_by_price.includes(:category)
        render json: @products, each_serializer: ProductSerializer,
                      status: :ok
      end

      def show
        render json: @product, serializer: ProductSerializer,
                      status: :ok
      end

      def create
        @product = Product.new(product_params)
        return unless @product.save

        render json: @product, serializer: ProductSerializer,
                      status: :ok
      end

      def update
        return unless @product.update(product_params)

        render json: @product, serializer: ProductSerializer,
                      status: :ok
      end

      def destroy
        return unless @product.destroy

        render json: @product, serializer: ProductSerializer,
                      status: :ok
      end

      private
      def load_product
        @product = Product.find(params[:id])
        return if @product
      end

      def record_not_found
        render json:
          {
            message: t("flash.not_found")
          }, status: :not_found
      end

      def product_params
        params.require(:product).permit(:name, :price, :quantity, :status,
                                        :author, :category_id, :publisher,
                                        :description, :image)
      end
    end
  end
end
