class OrdersController < ApplicationController
  before_action :logged_in_user, only: %i(new create update_status)
  before_action :find_order, only: [:update_status]
  before_action :check_status?, only: [:update_status]

  def new
    @order = current_user.orders.build
    @cart_items = get_line_items_in_cart
  end

  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build
      @cart_items = get_line_items_in_cart
      create_order_details
      @order.assign_attributes(order_params)
      @order.save!
      Notificationad.create(event: "#{@order.user_name} đã đặt đơn hàng mới",
                            order_id: @order.id)
      send_mail_new_order
      flash[:success] = t "order.order_success"
      session[:cart] = nil
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def index
    @orders = current_user.orders.sort_by_created.page(params[:page])
                          .per(Settings.per_5)
  end

  def update_status
    ActiveRecord::Base.transaction do
      @order.update!(status: params[:status])
      @order.rollback_quantity if params[:status].eql?("cancel")
      @order.recovery_quantity if params[:status].eql?("pending")
      flash[:info] = t "flash.update_order_succ"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "flash.update_order_fail"
    ensure
      redirect_to orders_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:name_customer, :phone_number, :address,
                                  :total_money)
  end

  def create_order_details
    @cart_items.each do |item|
      check_enough_quantity(item)
      line_item = {product_id: item[:product].id, quantity: item[:quantity]}
      @order.order_details.build(line_item)
    end
  end

  def check_enough_quantity item
    return if item[:product].quantity >= item[:quantity]

    flash.now[:warning] = t("product.please_update_quantity",
                            name: item[:product].name)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "flash.order_not_found"
    redirect_to orders_path
  end

  def check_status?
    return if Order.statuses.keys.include?(params[:status])

    flash[:danger] = t "flash.invalid_status"
    redirect_to orders_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.please_login"
    redirect_to login_url
  end

  def send_mail_new_order
    SendEmailJob.set(wait: Settings.wait_time.minute).perform_later @order
  end
end
