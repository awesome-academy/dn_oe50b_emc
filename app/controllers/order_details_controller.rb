class OrderDetailsController < ApplicationController
  before_action :check_order, only: [:index]

  def index
    @orderdetails = @orders.order_details.includes(:product)
  end

  private

  def check_order
    @orders = Order.find_by user_id: current_user.id
    return if @orders

    flash[:warning] = t "flash.product_not_found"
    redirect_to home_client_path
  end
end
