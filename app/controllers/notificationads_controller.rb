class NotificationadsController < ApplicationController
  before_action :load_notification, except: %i(index)

  def index
    @notifications = Notificationad.all.reverse
  end

  def update_to_read
    ActiveRecord::Base.transaction do
      @notification.update(read_at: Time.zone.now)
      if @notification.order_id.nil?
        redirect_to admin_orders_path
      else
        redirect_to admin_order_path(@notification.order_id)
      end
    rescue ActiveRecord::RecordInvalid
      redirect_to admin_products_path
    end
  end

  private

  def load_notification
    @notification = Notificationad.find_by id: params[:id]
    return if @notification.present?

    flash[:danger] = t "flash.not_found"
    redirect_to root_url
  end
end
