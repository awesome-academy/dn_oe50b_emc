class Admin::OrdersController < ApplicationController
  def index
    @orders = Order.ordered_by_price
    .page(params[:page]).per(1)
  end

  def edit
  end

  def destroy
  end

  def show_modal
    @orders = Order.find(params[:order_id])
  end
end
