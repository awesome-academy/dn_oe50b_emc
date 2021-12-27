module Api::V1
  class OrdersController < ApplicationController
    before_action :ensure_params_exist, :load_product, only: [:create]
    before_action :load_order, only: [:show]
    skip_before_action :verify_authenticity_token
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def create
      @order = Order.new order_params
      @order_details = OrderDetail.new orderdetails_params
      @order.total_money = @product.price * @order_details.quantity

      ActiveRecord::Base.transaction do
        @order.save
        @order_details.price = @product.price
        @order_details.order_id = @order.id
        @order_details.save
        render json: {order: @order, order_details: @order_details}, status: :ok
      end
    end

    def show
      @order_details = @order.order_details
      render json: @order_details, each_serializer: OrderDetailSerializer,
                   status: :ok
    end

    private

    def order_params
      params.require(:order).permit(:name_customer, :phone_number, :address,
                                    :user_id, :product_id, :quantity)
    end

    def orderdetails_params
      params.require(:order_details).permit(:product_id, :quantity)
    end

    def ensure_params_exist
      return if params[:order].present? && params[:order_details].present?

      render json: {message: "Missing params"}, status: :unprocessable_entity
    end

    def record_not_found
      render json:
        {
          message: "not found"
        }, status: :not_found
    end

    def load_product
      @product = Product.find_by id: orderdetails_params[:product_id]
      return if @product

      render json: {message: "Product not found"}, status: :not_found
    end

    def load_order
      @order = Order.find_by(id: params[:id])
      return if @order

      render json: {message: "Order not found"}, status: :not_found
    end
  end
end
