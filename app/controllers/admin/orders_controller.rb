class Admin::OrdersController < Admin::BaseController
  before_action :load_order, :load_detail_total,
                except: %i(index)
  def index
    @search = Order.ransack(params[:q])
    @orders = @search.result(distinct: true).ordered_by_price
                     .page(params[:page]).per(Settings.atrr.paging_min)
  end

  def show
    @total = total_money @order
  end

  def approve
    ActiveRecord::Base.transaction do
      @order.approve!
      Notification.create(recipient: @order.user, actor: current_user,
                          title: t("order.noti.approve"),
                          content: t("order.noti.content_approve"))
      send_mail_change_status
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "flash.update_order_fail"
  else
    flash[:success] = t "flash.update_order_succc"
  ensure
    redirect_to action: :index
  end

  def reject
    ActiveRecord::Base.transaction do
      update_quantity_reject @order if @order.pending? || @order.approve?
      @order.pending? ? @order.not_accept! : @order.cancel!
      Notification.create(recipient: @order.user, actor: current_user,
                          title: t("order.noti.reject"),
                          content: t("order.noti.content_reject"))
      send_mail_change_status
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "flash.update_order_fail"
  else
    flash[:success] = t "flash.update_order_succ"
  ensure
    redirect_to action: :index
  end

  private
  def load_order
    @order = Order.find_by slug: params[:id]
    return if @order

    flash[:warning] = t("flash.not_found")
    redirect_to action: :index
  end

  def total_money _order
    @order.order_details.includes(:product).reduce(0) do |sum, detail|
      sum + detail.quantity * detail.product_price
    end
  end

  def load_detail_total
    @order_detail = @order.order_details.includes(:product)
    @total = total_money @order
  end

  def update_quantity_reject _order
    @order.order_details.each do |detail|
      product = detail.product
      product.quantity += detail.quantity
      product.save!
    end
  end

  def send_mail_change_status
    OrderMailer.order_status(@order, @order_detail, @total).deliver_now
  end
end
