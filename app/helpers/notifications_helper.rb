module NotificationsHelper
  def check_read notification
    notification.read_at.nil?
  end
end
