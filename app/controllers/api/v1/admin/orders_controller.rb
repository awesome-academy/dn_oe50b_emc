module Api
  module V1
    module Admin
      class OrdersController < ApplicationController
        before_action :load_order, :load_detail_total,
                      except: %i(index)
        skip_before_action :verify_authenticity_token
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

        def index
          @orders = Order.ordered_by_price
          render json: @orders, each_serializer: OrderSerializer,
          status: :ok
        end

        def show
          render json: @order, serializer: OrderSerializer,
          status: :ok
        end

        def approve
          ActiveRecord::Base.transaction do
            @order.approve!
          end
        rescue ActiveRecord::RecordInvalid
          render json:
          {
            message: t("flash.update_order_fail")
          }, status: :bad_request
        else
          render json:
          {
            message: t("flash.update_order_succ")
          }, status: :ok
        end

        def reject
          ActiveRecord::Base.transaction do
            update_quantity_reject @order if @order.pending? || @order.approve?
            @order.pending? ? @order.not_accept! : @order.cancel!
          end
        rescue ActiveRecord::RecordInvalid
          render json:
          {
            message: t("flash.update_order_fail")
          }, status: :bad_request
        else
          render json:
          {
            message: t("flash.update_order_succ")
          }, status: :ok
        end

        private
        def load_order
          @order = Order.find_by id: params[:id]
          return if @order
        end

        def load_detail_total
          @order_detail = @order.order_details.includes(:product)
        end

        def update_quantity_reject _order
          @order.order_details.each do |detail|
            product = detail.product
            product.quantity += detail.quantity
            product.save!
          end
        end

        def record_not_found
          render json:
          {
            message: t("flash.not_found")
          }, status: :not_found
        end
      end
    end
  end
end
