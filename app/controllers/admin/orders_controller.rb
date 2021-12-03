class Admin::OrdersController < Admin::BaseController
  before_action :load_order, only: %i(show)

  def index
    @orders = Order.ordered_by_price
                   .page(params[:page]).per(Settings.atrr.paging_min)
  end

  def show
    @total = total_money @order
  end

  private
  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:warning] = t("flash.not_found", id: params[:id])
    redirect_to action: :index
  end

  def total_money _order
    @order.order_details.includes(:product).reduce(0) do |sum, detail|
      sum + detail.quantity * detail.product_price
    end
  end
end
