class OrderDetailsController < ApplicationController
  def index
    check_order
    @orderdetails = @orders.order_details.includes(:product)
  end

  private

  def check_order
    @orders = Order.find_by user_id: current_user.id
    return if @orders
  end
end
