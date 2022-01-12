class NotificationadsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notificationad_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
