class OrderDetailsController < ApplicationController
  before_action :find_order, only: [:index]

  def index
    @order_detais = @order.order_details.includes(:product)
                          .page(params[:page]).per(Settings.per_5)
  end

  private

  def find_order
    @order = Order.find_by(id: params[:order_id])
    return if @order

    flash[:danger] = t "flash.order_not_found"
    redirect_to root_path
  end
end
