class NotificationsController < ApplicationController
  before_action :load_notification

  def show
    mask_as_read if @notification.read_at.nil?
  end

  def mask_as_read
    @notification.update(read_at: Time.zone.now)
  end

  private
  def load_notification
    @notification = Notification.find_by id: params[:id]
    return if @notification.present?

    flash[:danger] = t "flash.not_found"
    redirect_to root_url
  end
end
