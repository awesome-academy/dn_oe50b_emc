class Admin::OrdersController < ApplicationController
  def index
    @orders = Order.ordered_by_price
                   .page(params[:page]).per(Settings.atrr.paging_min)
  end
end
