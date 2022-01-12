class NotificationadBroadcastJob < ApplicationJob
  queue_as :default

  def perform counter, notification
    ActionCable.server.broadcast "notificationad_channel",
                                 counter: render_counter(counter),
                                 notification: render_notification(notification)
  end

  private

  def render_counter counter
    ApplicationController.renderer.render(partial: "notificationads/counter",
                                          locals: {counter: counter})
  end

  def render_notification notification
    ApplicationController.renderer.render(
      partial: "notificationads/notification",
      locals: {notification: notification}
    )
  end
end
