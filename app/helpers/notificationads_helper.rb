module NotificationadsHelper
  def notifi
    @notifications = Notificationad.all.reverse
  end

  def count_notifi
    @count_notifi = Notificationad.total_unread
  end
end
